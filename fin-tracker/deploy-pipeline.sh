#!/bin/bash
# deploy-pipeline.sh
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_services=info,fin_core=info,fin_tracker_pipeline=info"

cd /media/raghu/data2/Workspace/Projects/fin-tracker-backend-rs

docker build -f Dockerfile.pipeline \
  -t $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline . \
  && docker push $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline 
  