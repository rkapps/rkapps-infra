#!/bin/bash
source $(dirname $0)/config.sh $1

echo "Project ID: $PROJECT_ID"

# Login
gcloud auth login

# Create project only if it doesn't exist
if gcloud projects describe $PROJECT_ID &>/dev/null; then
  echo "Project $PROJECT_ID already exists, skipping creation..."
else
  echo "Creating project $PROJECT_ID..."
  gcloud projects create $PROJECT_ID \
    --name "Fin Tracker $ENV" \
    --organization $ORG_ID
fi

# Set active project
gcloud config set project $PROJECT_ID

# Pause for billing setup
BILLING=$(gcloud billing projects describe $PROJECT_ID --format="value(billingEnabled)")
if [ "$BILLING" != "True" ]; then
  echo "==========================================="
  echo "ACTION REQUIRED: Enable billing for project $PROJECT_ID"
  echo "1. Go to https://console.cloud.google.com/billing/projects"
  echo "2. Link a billing account to $PROJECT_ID"
  echo "3. Press ENTER when done..."
  echo "==========================================="
  read -p ""

  while true; do
    BILLING=$(gcloud billing projects describe $PROJECT_ID --format="value(billingEnabled)")
    if [ "$BILLING" = "True" ]; then
      echo "Billing confirmed active, continuing..."
      break
    else
      echo "Billing not yet active, waiting 10 seconds..."
      sleep 10
    fi
  done
else
  echo "Billing already active, skipping..."
fi

# Get project number
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
COMPUTE_SA="$PROJECT_NUMBER-compute@developer.gserviceaccount.com"

# Enable APIs (safe to run multiple times)
gcloud services enable \
  run.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  cloudscheduler.googleapis.com \
  secretmanager.googleapis.com \
  iam.googleapis.com \
  storage.googleapis.com

echo "Waiting for APIs to propagate..."
sleep 60

# Grant roles (safe to run multiple times - adds if not exists)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$COMPUTE_SA" \
  --role="roles/editor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$COMPUTE_SA" \
  --role="roles/run.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$COMPUTE_SA" \
  --role="roles/secretmanager.secretAccessor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$COMPUTE_SA" \
  --role="roles/firebase.admin"

# Create Cloud Scheduler service account (skip if exists)
gcloud iam service-accounts create cloud-scheduler-sa \
  --display-name "Cloud Scheduler Service Account" \
  2>/dev/null || echo "cloud-scheduler-sa already exists, skipping..."

# Grant scheduler service account roles (safe to run multiple times)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:cloud-scheduler-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.invoker"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:cloud-scheduler-sa@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

# Create Artifact Registry repositories (skip if exists)
gcloud artifacts repositories create fin-tracker-go-api \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || echo "fin-tracker-go-api repository already exists, skipping..."

gcloud artifacts repositories create fin-tracker-api \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || echo "fin-tracker-api repository already exists, skipping..."

gcloud artifacts repositories create fin-tracker-pipeline \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || echo "fin-tracker-pipeline repository already exists, skipping..."

gcloud artifacts repositories create fin-tracker-admin \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || echo "fin-tracker-admin repository already exists, skipping..."

# Create GCS bucket (skip if exists)
gcloud storage buckets create gs://fin-tracker-data-$ENV \
  --location $REGION \
  --project $PROJECT_ID \
  --quiet 2>/dev/null || echo "Bucket fin-tracker-data-$ENV already exists, skipping..."

# Grant compute service account access to bucket
gcloud storage buckets add-iam-policy-binding gs://fin-tracker-data-$ENV \
  --member="serviceAccount:$COMPUTE_SA" \
  --role="roles/storage.objectViewer"  

echo "Setup complete for $PROJECT_ID"
echo "Project number: $PROJECT_NUMBER"
echo "Compute SA: $COMPUTE_SA"