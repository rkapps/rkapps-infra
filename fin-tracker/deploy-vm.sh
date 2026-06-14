#!/bin/bash
source $(dirname $0)/config.sh $1

VM_NAME="ollama-server-nvidia-gpu"
VM_GPU_TYPE="nvidia-tesla-t4"
VM_MACHINE_TYPE="n1-standard-1"
VM_GPU_COUNT=1
VM_DISK_SIZE="100GB"
VM_IMAGE_FAMILY="ubuntu-2204-lts"
VM_IMAGE_PROJECT="ubuntu-os-cloud"
OLLAMA_PORT=11434
OLLAMA_MODEL="qwen3:14b-q4_K_M"

echo "Project ID: $PROJECT_ID"
echo "Deploying Ollama VM..."

# Enable compute API
gcloud services enable compute.googleapis.com \
  --project=$PROJECT_ID

# ── Find available zone for T4 ────────────────────────────────────────────────
T4_ZONES=(
  "us-central1-a"
  "us-central1-b"
  "us-central1-c"
  "us-central1-f"
  "us-east1-c"
  "us-east1-d"
  "us-west1-b"
)

VM_ZONE=""
for zone in "${T4_ZONES[@]}"; do
  echo "Trying zone $zone..."
  ERROR=$(gcloud compute instances create $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$zone \
    --machine-type=$VM_MACHINE_TYPE \
    --accelerator="type=$VM_GPU_TYPE,count=$VM_GPU_COUNT" \
    --image-family=$VM_IMAGE_FAMILY \
    --image-project=$VM_IMAGE_PROJECT \
    --boot-disk-size=$VM_DISK_SIZE \
    --boot-disk-type=pd-ssd \
    --maintenance-policy=TERMINATE \
    --restart-on-failure \
    --service-account=$COMPUTE_SA \
    --scopes="https://www.googleapis.com/auth/cloud-platform" \
    --tags=ollama-server-nvidia-gpu \
    --quiet 2>&1)

  if [ $? -eq 0 ]; then
    VM_ZONE=$zone
    echo "VM created in zone $VM_ZONE"
    break
  else
    echo "Error in $zone: $ERROR"
    echo "---"
  fi
done

if [ -z "$VM_ZONE" ]; then
  echo "==========================================="
  echo "ERROR: Could not create VM in any zone"
  echo "T4 GPUs may be fully exhausted in this region"
  echo "Try again later or use a different region"
  echo "==========================================="
  exit 1
fi

# Save zone for other scripts to use
echo "$VM_ZONE" > "$(dirname $0)/.vm-zone"
echo "VM zone saved to scripts/.vm-zone"

# ── Create firewall rule ───────────────────────────────────────────────────────
if gcloud compute firewall-rules describe allow-ollama \
  --project=$PROJECT_ID &>/dev/null; then
  echo "Firewall rule already exists, skipping..."
else
  echo "Creating firewall rule..."
  gcloud compute firewall-rules create allow-ollama \
    --project=$PROJECT_ID \
    --allow=tcp:$OLLAMA_PORT \
    --target-tags=ollama-server-nvidia-gpu \
    --source-ranges=0.0.0.0/0 \
    --description="Allow Ollama API access"
fi

# ── Wait for VM to be SSH-able ────────────────────────────────────────────────
echo "Waiting for VM to be ready..."
for i in $(seq 1 20); do
  STATUS=$(gcloud compute instances describe $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$VM_ZONE \
    --format="value(status)")
  echo "  Status: $STATUS ($i/20)"
  if [ "$STATUS" = "RUNNING" ]; then
    break
  fi
  sleep 10
done
sleep 15

# ── Install NVIDIA drivers and reboot ─────────────────────────────────────────
echo "Installing NVIDIA drivers..."
gcloud compute ssh $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE \
  --strict-host-key-checking=no \
  --command="
    set -euo pipefail
    echo '--- Updating system ---'
    sudo apt-get update -q
    sudo apt-get install -y linux-headers-\$(uname -r)
    echo '--- Installing NVIDIA drivers ---'
    sudo apt-get install -y nvidia-driver-535 nvidia-cuda-toolkit
    echo '--- Rebooting to load drivers ---'
    sudo reboot
  " || true  # reboot causes SSH to exit with error, ignore it

# ── Wait for VM to come back up ───────────────────────────────────────────────
echo "Waiting for VM to reboot..."
sleep 60
for i in $(seq 1 20); do
  STATUS=$(gcloud compute instances describe $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$VM_ZONE \
    --format="value(status)")
  echo "  Status: $STATUS ($i/20)"
  if [ "$STATUS" = "RUNNING" ]; then
    break
  fi
  sleep 10
done
sleep 15

# ── Install Ollama and pull model ─────────────────────────────────────────────
echo "Installing Ollama..."
gcloud compute ssh $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE \
  --strict-host-key-checking=no \
  --command="
    set -euo pipefail

    echo '--- Verifying GPU ---'
    nvidia-smi

    echo '--- Installing Ollama ---'
    curl -fsSL https://ollama.com/install.sh | sudo sh

    echo '--- Configuring Ollama ---'
    sudo mkdir -p /etc/systemd/system/ollama.service.d
    sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null <<EOF
[Service]
Environment=\"OLLAMA_HOST=0.0.0.0\"
Environment=\"OLLAMA_NUM_PARALLEL=4\"
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable ollama
    sudo systemctl restart ollama

    echo '--- Waiting for Ollama to start ---'
    sleep 5

    echo '--- Pulling model in background ---'
    nohup ollama pull $OLLAMA_MODEL > /tmp/ollama-pull.log 2>&1 &
    echo 'Model pull started in background'
    echo 'Check progress: tail -f /tmp/ollama-pull.log'

    echo '--- Verifying Ollama ---'
    ollama list
    nvidia-smi
  "

# ── Get VM external IP ────────────────────────────────────────────────────────
VM_IP=$(gcloud compute instances describe $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE \
  --format="value(networkInterfaces[0].accessConfigs[0].natIP)")

# Save IP for other scripts
echo "$VM_IP" > "$(dirname $0)/.vm-ip"
echo "VM IP saved to scripts/.vm-ip"

echo "==========================================="
echo "Ollama VM deployed successfully"
echo "VM Name:  $VM_NAME"
echo "Zone:     $VM_ZONE"
echo "IP:       $VM_IP"
echo "Ollama:   http://$VM_IP:$OLLAMA_PORT"
echo "Model:    $OLLAMA_MODEL"
echo "==========================================="
echo ""
echo "Add to your env/$ENV.env:"
echo "OLLAMA_BASE_URL=http://$VM_IP:$OLLAMA_PORT"
echo "OLLAMA_MODEL=$OLLAMA_MODEL"
echo ""
echo "Model is pulling in background."
echo "Check progress:"
echo "  gcloud compute ssh $VM_NAME --project=$PROJECT_ID --zone=$VM_ZONE --command='tail -f /tmp/ollama-pull.log'"
echo ""

# ── Test connection ───────────────────────────────────────────────────────────
echo "Testing Ollama connection..."
if curl -s --max-time 15 "http://$VM_IP:$OLLAMA_PORT" | grep -q "Ollama"; then
  echo "Connection successful"
else
  echo "==========================================="
  echo "Connection test failed — may need a moment to start"
  echo "Test manually: curl http://$VM_IP:$OLLAMA_PORT"
  echo "If GPU drivers not loaded try:"
  echo "  gcloud compute instances reset $VM_NAME --project=$PROJECT_ID --zone=$VM_ZONE"
  echo "==========================================="
fi

echo "VM deployment complete for $PROJECT_ID"