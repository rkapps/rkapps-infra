ORG_ID=$RUSTIC_AI_ORG_ID
PROJECT_ID=$RUSTIC_AI_PROJECT_ID
REGION="us-central1"
IMAGE_REGISTRY="us-central1-docker.pkg.dev/$PROJECT_ID"
COMPUTE_SA_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
COMPUTE_SA="$COMPUTE_SA_NUMBER-compute@developer.gserviceaccount.com"
GCS_BUCKET="$PROJECT_ID-data"
SCHEDULER_SA="cloud-scheduler-sa@$PROJECT_ID.iam.gserviceaccount.com"

RUSTIC_AI_CONFIG_PATH="gs://$GCS_BUCKET/config"
RUSTIC_AI_BSET_DATA_PATH="gs://$GCS_BUCKET/bset"
