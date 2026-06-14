source config.sh

RUST_LOG_VALUE="rustic_pipeline=info,rustic_boot=info,rustic_economic=info,rustic_finance=info"

# cd to the project source path.
cd $RUSTIC_AI_PROJECT_SOURCE_PATH

docker build -f Dockerfile.pipeline \
  -t $IMAGE_REGISTRY/rustic-backend/rustic-pipeline . \
  --build-arg GITHUB_USERNAME=$GITHUB_USERNAME \
  --build-arg GITHUB_TOKEN=$GITHUB_TOKEN \
  && docker push $IMAGE_REGISTRY/rustic-backend/rustic-pipeline 

  