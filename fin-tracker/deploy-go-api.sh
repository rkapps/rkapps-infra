#!/bin/bash
# deploy-go-api.sh
source $(dirname $0)/config.sh $1
LOG_LEVELS="INFO"

cd /media/raghu/data2/Workspace/Projects/fin-tracker-backend-go

gcloud artifacts repositories create fin-tracker-go-api \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || true

docker build --no-cache -f Dockerfile.goapi \
  -t $IMAGE_REGISTRY/fin-tracker-go-api/fin-tracker-go-api . \
  && docker push $IMAGE_REGISTRY/fin-tracker-go-api/fin-tracker-go-api \
  && gcloud run deploy fin-tracker-go-api \
    --image $IMAGE_REGISTRY/fin-tracker-go-api/fin-tracker-go-api \
    --region $REGION \
    --allow-unauthenticated \
    --memory 512Mi \
    --cpu 1 \
    --min-instances 0 \
    --max-instances 3 \
    --concurrency 80 \
    --timeout 60 \
    --set-secrets FINTRACKER_DB_NAME=FINTRACKER_DB_NAME:latest \
    --set-secrets FINTRACKER_MONGO_URI=FINTRACKER_MONGO_URI:latest \
    --set-secrets FINTRACKER_PROJECT_ID=FINTRACKER_PROJECT_ID:latest \
    --set-secrets FINTRACKER_CREDENTIAL_ENCRYPTION_KEY=FINTRACKER_CREDENTIAL_ENCRYPTION_KEY:latest \
    --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
    --set-secrets RUSTIC_FINANCE_MONGO_URI=RUSTIC_FINANCE_MONGO_URI:latest \
    --set-env-vars LOG_LEVELS=$LOG_LEVELS \
    --set-env-vars LOG_FORMAT=json
    
