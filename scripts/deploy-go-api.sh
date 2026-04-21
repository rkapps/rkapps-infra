#!/bin/bash
# deploy-go-api.sh
source $(dirname $0)/config.sh $1
LOG_LEVEL="INFO"

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
    --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars FIREBASE_PROJECT_ID=$PROJECT_ID \
    --set-env-vars LOG_FORMAT=json
    
