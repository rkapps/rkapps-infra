#!/bin/bash
# deploy-pipeline.sh
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_services=info,fin_core=info,fin_tracker_pipeline=info"

cd /media/raghu/data2/Workspace/Projects/fin-tracker-backend-rs

docker build -f Dockerfile.pipeline \
  -t $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline . \
  && docker push $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline 
  # && gcloud run jobs create fin-tracker-tickers-eod \
  #   --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  #   --region $REGION \
  #   --args "tickers-eod" \
  #   --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  #   --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  #   --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  #   --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  #   --set-env-vars LOG_FORMAT=json \
  #   2>/dev/null || gcloud run jobs update fin-tracker-tickers-eod \
  #   --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  #   --region $REGION \
  # && gcloud run jobs create fin-tracker-realtime-stocks-etfs \
  #   --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  #   --region $REGION \
  #   --args "realtime-stocks-etfs" \
  #   --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  #   --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  #   --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  #   --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  #   --set-env-vars LOG_FORMAT=json \
  #   2>/dev/null || gcloud run jobs update fin-tracker-realtime-stocks-etfs \
  #   --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  #   --region $REGION \
  # && gcloud run jobs create fin-tracker-realtime-crypto \
  #   --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  #   --region $REGION \
  #   --args "realtime-crypto" \
  #   --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  #   --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  #   --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  #   --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  #   --set-env-vars LOG_FORMAT=json \
  #   2>/dev/null || gcloud run jobs update fin-tracker-realtime-crypto \
  #   --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  #   --region $REGION