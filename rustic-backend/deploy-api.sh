source config.sh

RUST_LOG_VALUE="rustic_ai_api=info,bin_shared=info,rustic_boot=info,rustic_agent=info,rustic_core=trace"
OTEL_ENDPOINT="https://cloudtrace.googleapis.com"
RUSTIC_AI_ECONOMIC_CONFIG_USAGE_FILE="economic_config_furniture.json"

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
        --set-secrets RUSTIC_CORE_MONGO_URI=RUSTIC_CORE_MONGO_URI:latest \
        --set-secrets RUSTIC_CLIENT_MONGO_URI=RUSTIC_CLIENT_MONGO_URI:latest \
        --set-secrets RUSTIC_AI_PROJECT_ID=RUSTIC_AI_PROJECT_ID:latest \
        --set-secrets RUSTIC_AI_CONFIG_PATH=RUSTIC_AI_CONFIG_PATH:latest \
        --set-secrets RUSTIC_ECONOMIC_DB_NAME=RUSTIC_ECONOMIC_DB_NAME:latest \
        --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
        --set-secrets RUSTIC_PLATFORM_DB_NAME=RUSTIC_PLATFORM_DB_NAME:latest \
        --set-secrets OPENAI_API_KEY=OPENAI_API_KEY:latest \
        --set-secrets GEMINI_API_KEY=GEMINI_API_KEY:latest \
        --set-secrets ANTHROPIC_API_KEY=ANTHROPIC_API_KEY:latest \
        --set-secrets TOGETHER_API_KEY=TOGETHER_API_KEY:latest \
        --set-secrets FIREWORKS_API_KEY=FIREWORKS_API_KEY:latest \
        --set-secrets MISTRAL_API_KEY=MISTRAL_API_KEY:latest \
        --set-secrets GROQ_API_KEY=GROQ_API_KEY:latest \
        --set-secrets CEREBRAS_API_KEY=CEREBRAS_API_KEY:latest \
        --set-secrets AKASHML_API_KEY=AKASHML_API_KEY:latest \
        --set-secrets ASIONE_API_KEY=ASIONE_API_KEY:latest \
        --set-secrets FRED_API_KEY=FRED_API_KEY:latest \
        --set-secrets CENSUS_API_KEY=CENSUS_API_KEY:latest \
        --set-secrets BEA_API_KEY=BEA_API_KEY:latest \
        --set-secrets TAVILY_API_KEY=TAVILY_API_KEY:latest \
        --set-env-vars RUSTIC_AI_ECONOMIC_CONFIG_USAGE_FILE=$RUSTIC_AI_ECONOMIC_CONFIG_USAGE_FILE \
        --set-env-vars OTEL_ENDPOINT=$OTEL_ENDPOINT \
        --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
        --set-env-vars LOG_FORMAT=json

