source config.sh

RUST_LOG_VALUE="rustic_ai_api=info,rustic_boot=info,rustic_agent=info"
OTEL_ENDPOINT="https://cloudtrace.googleapis.com"

#OTEL_ENDPOINT=https://cloudtrace.googleapis.com/v2/projects/YOUR_PROJECT_ID/traces

# cd to the project source path.
cd $RUSTIC_AI_PROJECT_SOURCE_PATH




# ✅ Check first, create only if missing, fail loudly if creation fails
echo "Checking Artifact Registry repository..."
if ! gcloud artifacts repositories describe rustic-backend \
  --location=us-central1 \
  --project=$PROJECT_ID &>/dev/null; then

  echo "Creating repository rustic-backend..."
  gcloud artifacts repositories create rustic-backend \
    --repository-format=docker \
    --location=us-central1 \
    --project=$PROJECT_ID
  echo "✅ Repository created"
else
  echo "✅ Repository already exists"
fi


#docker build --no-cache -f Dockerfile.api \
docker build -f Dockerfile.api \
  -t $IMAGE_REGISTRY/rustic-backend/rustic-ai-api . \
  --build-arg GITHUB_USERNAME=$GITHUB_USERNAME \
  --build-arg GITHUB_TOKEN=$GITHUB_TOKEN \
  && docker push $IMAGE_REGISTRY/rustic-backend/rustic-ai-api \
  && gcloud run deploy rustic-ai-api \
        --image $IMAGE_REGISTRY/rustic-backend/rustic-ai-api \
        --region us-central1 \
        --allow-unauthenticated \
        --set-env-vars RUSTIC_AI_PROJECT_ID=$PROJECT_ID \
        --set-env-vars RUSTIC_AI_CONFIG_PATH=$RUSTIC_AI_CONFIG_PATH \
        --set-env-vars MONGO_URI=$MONGO_URI \
        --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
        --set-env-vars RUSTIC_ECONOMIC_DB_NAME=$RUSTIC_ECONOMIC_DB_NAME \
        --set-env-vars RUSTIC_PLATFORM_DB_NAME=$RUSTIC_PLATFORM_DB_NAME \
        --set-env-vars RUSTIC_AI_BSET_DATA_PATH=$RUSTIC_AI_BSET_DATA_PATH \
        --set-env-vars GCP_LLM_BASE_URL=$GCP_LLM_BASE_URL \
        --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
        --set-env-vars GEMINI_API_KEY=$GEMINI_API_KEY \
        --set-env-vars ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY \
        --set-env-vars FRED_API_KEY=$FRED_API_KEY \
        --set-env-vars CENSUS_API_KEY=$CENSUS_API_KEY \
        --set-env-vars BEA_API_KEY=$BEA_API_KEY \
        --set-env-vars APIFY_API_KEY=$APIFY_API_KEY \
        --set-env-vars OTEL_ENDPOINT=$OTEL_ENDPOINT \
        --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
        --set-env-vars LOG_FORMAT=json

