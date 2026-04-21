# scripts/config.sh
ENV=$1
ORG_ID="1032448450426"
PROJECT_ID="fin-tracker-backend-$ENV"
REGION="us-central1"
IMAGE_REGISTRY="us-central1-docker.pkg.dev/$PROJECT_ID"
SCHEDULER_SA="cloud-scheduler-sa@$PROJECT_ID.iam.gserviceaccount.com"
COMPUTE_SA_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
COMPUTE_SA="$COMPUTE_SA_NUMBER-compute@developer.gserviceaccount.com"
