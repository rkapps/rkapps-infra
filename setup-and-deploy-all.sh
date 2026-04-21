#!/bin/bash
source $(dirname $0)/scripts/config.sh $1

if [ -z "$ENV" ]; then
  echo "Usage: ./setup-and-deploy-all.sh <env>"
  echo "Example: ./setup-and-deploy-all.sh dev"
  exit 1
fi

# verify all scripts exist before starting
SCRIPTS=(
  "scripts/setup.sh"
  "scripts/deploy-go-api.sh"
  "scripts/deploy-api.sh"
  "scripts/deploy-pipeline.sh"
  "scripts/deploy-jobs.sh"
  "scripts/deploy-schedulers.sh"
)

for script in "${SCRIPTS[@]}"; do
  if [ ! -f "$(dirname $0)/$script" ]; then
    echo "ERROR: Missing script $script"
    exit 1
  fi
done

echo "All scripts found, starting deployment for $ENV..."
echo "Setting up environment: $ENV"
echo "Project ID: $PROJECT_ID"
echo "Region: $REGION"

# Step 1 - setup GCP project
echo "Step 1: Setting up GCP project..."
./scripts/setup.sh $ENV

# Step 2 - deploy Go API
echo "Step 2: Deploying Go API..."
./scripts/deploy-go-api.sh $ENV

# Step 3 - deploy Rust API
echo "Step 3: Deploying Rust API..."
./scripts/deploy-api.sh $ENV

# Step 4 - build and push pipeline image
echo "Step 4: Deploying pipeline..."
./scripts/deploy-pipeline.sh $ENV

# Step 5 - build and push admin image
echo "Step 4: Deploying admin..."
./scripts/deploy-admin.sh $ENV

# Step 6 - create Cloud Run jobs
echo "Step 6: Creating Cloud Run jobs..."
./scripts/deploy-jobs.sh $ENV

# Step 7 - create Cloud Scheduler jobs
echo "Step 7: Creating Cloud Scheduler jobs..."
./scripts/deploy-schedulers.sh $ENV

echo "Deployment complete for $ENV"
echo "Go API:   $(gcloud run services describe fin-tracker-go-api --region $REGION --format='value(status.url)')"
echo "Rust API: $(gcloud run services describe fin-tracker-api --region $REGION --format='value(status.url)')"