#!/bin/bash
source $(dirname $0)/config.sh $1

VM_NAME="ollama-server"
VM_ZONE="us-central1-a"        # single zone, no loop needed
VM_MACHINE_TYPE="n2-standard-8"
VM_DISK_SIZE="50GB"
VM_IMAGE_FAMILY="ubuntu-2204-lts"
VM_IMAGE_PROJECT="ubuntu-os-cloud"
OLLAMA_PORT=11434
OLLAMA_MODEL="qwen3.5:4b"


echo "Project ID: $PROJECT_ID"
echo "Deploying Ollama VM..."

# Enable compute API
gcloud services enable compute.googleapis.com \
  --project=$PROJECT_ID

echo "Creating VM $VM_NAME..."
gcloud compute instances create $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE \
  --machine-type=$VM_MACHINE_TYPE \
  --image-family=$VM_IMAGE_FAMILY \
  --image-project=$VM_IMAGE_PROJECT \
  --boot-disk-size=$VM_DISK_SIZE \
  --boot-disk-type=pd-ssd \
  --restart-on-failure \
  --service-account=$COMPUTE_SA \
  --scopes="https://www.googleapis.com/auth/cloud-platform" \
  --tags=ollama-server


# Create firewall rule (skip if exists)
if gcloud compute firewall-rules describe allow-ollama \
  --project=$PROJECT_ID &>/dev/null; then
  echo "Firewall rule already exists, skipping..."
else
  echo "Creating firewall rule..."
  gcloud compute firewall-rules create allow-ollama \
    --project=$PROJECT_ID \
    --allow=tcp:$OLLAMA_PORT \
    --target-tags=ollama-server \
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
sleep 15  # extra buffer for SSH daemon to start


gcloud compute ssh $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE \
  --strict-host-key-checking=no \
  --command="
    set -euo pipefail

    echo '--- Updating system ---'
    sudo apt-get update -q
    sudo apt-get upgrade -y

    echo '--- Installing Ollama ---'
    curl -fsSL https://ollama.com/install.sh | sudo sh

    echo '--- Configuring Ollama ---'
    sudo mkdir -p /etc/systemd/system/ollama.service.d
    sudo tee /etc/systemd/system/ollama.service.d/override.conf > /dev/null <<EOF
[Service]
Environment=\"OLLAMA_HOST=0.0.0.0\"
Environment=\"OLLAMA_NUM_PARALLEL=1\"
Environment=\"OLLAMA_NUM_THREADS=16\"
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable ollama
    sudo systemctl restart ollama

    echo '--- Waiting for Ollama to start ---'
    sleep 5

    echo '--- Pulling model ---'
    ollama pull $OLLAMA_MODEL

    echo '--- Verifying ---'
    ollama list
  "


echo "$VM_ZONE" > "$(dirname $0)/.vm-zone"
echo "VM zone saved to scripts/.vm-zone"

# ── Get VM external IP ────────────────────────────────────────────────────────
VM_IP=$(gcloud compute instances describe $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE \
  --format="value(networkInterfaces[0].accessConfigs[0].natIP)")

echo "==========================================="
echo "Ollama VM deployed successfully"
echo "VM Name:  $VM_NAME"
echo "Zone:     $VM_ZONE"
echo "IP:       $VM_IP"
echo "Ollama:   http://$VM_IP:$OLLAMA_PORT"
echo "Model:    $OLLAMA_MODEL"
echo "==========================================="
echo ""
echo "Add to your .env.$ENV:"
echo "GCP_LLM_BASE_URL=http://$VM_IP:$OLLAMA_PORT"
echo ""

# Test connection
echo "Testing connection..."
if curl -s --max-time 15 "http://$VM_IP:$OLLAMA_PORT" | grep -q "Ollama"; then
  echo "Connection successful"
else
  echo "==========================================="
  echo "Connection test failed — Ollama may still be starting"
  echo "Wait 30 seconds and try: curl http://$VM_IP:$OLLAMA_PORT"
  echo "Run: gcloud compute instances reset $VM_NAME --project=$PROJECT_ID --zone=$VM_ZONE"
  echo "Then: curl http://$VM_IP:$OLLAMA_PORT"
  echo "==========================================="
fi

echo "VM deployment complete for $PROJECT_ID"