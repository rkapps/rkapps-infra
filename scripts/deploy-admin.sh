#!/bin/bash
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_services=info,fin_core=info,fin_tracker_admin=info"

cd /media/raghu/data2/Workspace/Projects/fin-tracker-backend-rs

gcloud artifacts repositories create fin-tracker-admin \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || true

docker build -f Dockerfile.admin \
  -t us-central1-docker.pkg.dev/$PROJECT_ID/fin-tracker-admin/fin-tracker-admin . \
  && docker push us-central1-docker.pkg.dev/$PROJECT_ID/fin-tracker-admin/fin-tracker-admin \
#   && gcloud run jobs create fin-tracker-admin \
#     --image us-central1-docker.pkg.dev/$PROJECT_ID/fin-tracker-admin/fin-tracker-admin \
#     --region $REGION \
#     --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
#     --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
#     --set-env-vars LOG_FORMAT=json \
#     2>/dev/null || gcloud run jobs update fin-tracker-admin \
#     --image us-central1-docker.pkg.dev/$PROJECT_ID/fin-tracker-admin/fin-tracker-admin \
#     --region $REGION