#!/bin/bash
# deploy-api.sh
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_services=info,fin_core=info,fin_tracker_api=info,agentic_boot=info"

cd /media/raghu/data2/Workspace/Projects/fin-tracker-backend-rs

gcloud artifacts repositories create fin-tracker-api \
  --repository-format=docker \
  --location=us-central1 \
  --quiet 2>/dev/null || true

docker build --no-cache -f Dockerfile.api \
  -t $IMAGE_REGISTRY/fin-tracker-api/fin-tracker-api . \
  --build-arg GITHUB_USERNAME=$GITHUB_USERNAME \
  --build-arg GITHUB_TOKEN=$GITHUB_TOKEN \
  && docker push $IMAGE_REGISTRY/fin-tracker-api/fin-tracker-api \
  && gcloud run deploy fin-tracker-api \
        --image $IMAGE_REGISTRY/fin-tracker-api/fin-tracker-api \
        --region us-central1 \
        --allow-unauthenticated \
        --set-env-vars FINTRACKER_CONFIG_PATH=$FINTRACKER_CONFIG_PATH \
        --set-env-vars FINTRACKER_PROJECT_ID=$FINTRACKER_PROJECT_ID \
        --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
        --set-env-vars GCP_LLM_BASE_URL=$GCP_LLM_BASE_URL \
        --set-env-vars MONGO_URI=$MONGO_URI \
        --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
        --set-env-vars GEMINI_API_KEY=$GEMINI_API_KEY \
        --set-env-vars ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
        --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
        --set-env-vars LOG_FORMAT=json
