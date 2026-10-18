#!/bin/bash
# deploy-api.sh
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_tracker_api=info,rustic_boot=info,rustic_agent=info,rustic_finance=info"
OTEL_ENDPOINT="https://cloudtrace.googleapis.com"

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
        --set-secrets FINTRACKER_CONFIG_PATH=FINTRACKER_CONFIG_PATH:latest \
        --set-secrets FINTRACKER_PROJECT_ID=FINTRACKER_PROJECT_ID:latest \
        --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
        --set-secrets RUSTIC_FINANCE_MONGO_URI=RUSTIC_FINANCE_MONGO_URI:latest \
        --set-secrets AKASHML_API_KEY=AKASHML_API_KEY:latest \
        --set-secrets ANTHROPIC_API_KEY=ANTHROPIC_API_KEY:latest \
        --set-secrets ASIONE_API_KEY=ASIONE_API_KEY:latest \
        --set-secrets CEREBRAS_API_KEY=CEREBRAS_API_KEY:latest \
        --set-secrets FIREWORKS_API_KEY=FIREWORKS_API_KEY:latest \
        --set-secrets GEMINI_API_KEY=GEMINI_API_KEY:latest \
        --set-secrets MISTRAL_API_KEY=MISTRAL_API_KEY:latest \
        --set-secrets OPENAI_API_KEY=OPENAI_API_KEY:latest \
        --set-secrets TOGETHER_API_KEY=TOGETHER_API_KEY:latest \
        --set-env-vars OTEL_ENDPOINT=$OTEL_ENDPOINT \
        --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
        --set-env-vars LOG_FORMAT=json
