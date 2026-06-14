#!/bin/bash
source $(dirname $0)/config.sh $1

VM_NAME="ollama-server"
ZONE_FILE="$(dirname $0)/.vm-zone"

# Read zone from saved file
if [ -f "$ZONE_FILE" ]; then
  VM_ZONE=$(cat "$ZONE_FILE")
  echo "Using saved zone: $VM_ZONE"
else
  VM_ZONE="$REGION-a"
  echo "No saved zone found, using default: $VM_ZONE"
fi

echo "Project ID: $PROJECT_ID"
echo "Destroying Ollama VM..."

if gcloud compute instances describe $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$VM_ZONE &>/dev/null; then
  echo "Deleting VM $VM_NAME..."
  gcloud compute instances delete $VM_NAME \
    --project=$PROJECT_ID \
    --zone=$VM_ZONE \
    --quiet
  rm -f "$ZONE_FILE"
  echo "VM deleted"
else
  echo "VM $VM_NAME does not exist, skipping..."
fi

echo "VM teardown complete for $PROJECT_ID"