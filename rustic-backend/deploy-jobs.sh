source config.sh

RUST_LOG_VALUE="rustic_ai_api=info,rustic_boot=info,rustic_finance=info"

# tickers eod
gcloud run jobs create pipeline-update-tickers-eod \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-tickers-eod" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-update-tickers-eod \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-tickers-eod" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json


# stocks-etfs-realtime
gcloud run jobs create pipeline-update-stocks-etfs-realtime \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-stocks-etfs-realtime" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-update-stocks-etfs-realtime \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-stocks-etfs-realtime" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json


# cryptos-realtime
gcloud run jobs create pipeline-update-cryptos-realtime \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-cryptos-realtime" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-update-cryptos-realtime \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-cryptos-realtime" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json



# tickers-news
gcloud run jobs create pipeline-update-tickers-news \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-tickers-news" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-update-tickers-news \
    --image $IMAGE_REGISTRY/rustic-backend/rustic-pipeline \
    --region $REGION \
    --args "update-tickers-news" \
    --task-timeout 1000 \
    --set-env-vars MONGO_URI=$MONGO_URI \
    --set-env-vars RUSTIC_FINANCE_DB_NAME=$RUSTIC_FINANCE_DB_NAME \
    --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
    --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
    --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
    --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
    --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
    --set-env-vars LOG_FORMAT=json

