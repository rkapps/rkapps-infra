source $(dirname $0)/config.sh $1
LOG_LEVEL="INFO"

cd /media/raghu/data2/Workspace/Projects/fin-tracker-backend-go

gcloud artifacts repositories create fin-tracker-go-pipeline \
  --repository-format=docker \
  --location=$REGION \
  --quiet 2>/dev/null || true


docker build --no-cache -f Dockerfile.gopipeline \
  -t $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline . \
  && docker push $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline
