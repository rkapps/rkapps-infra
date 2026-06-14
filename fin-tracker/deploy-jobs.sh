#!/bin/bash
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_services=info,fin_core=info,fin_tracker_pipeline=info,fin_tracker_admin=info"

RUST_LOG_VALUE_DEBUG="fin_services=trace,fin_core=debug,fin_tracker_pipeline=debug,fin_tracker_admin=debug"

# tickers eod
gcloud run jobs create pipeline-tickers-eod \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "tickers-eod" \
  --task-timeout 1000 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-tickers-eod \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --task-timeout 1000 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# realtime stocks etfs
gcloud run jobs create pipeline-realtime-stocks-etfs \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "realtime-stocks-etfs" \
  --task-timeout 1000 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-realtime-stocks-etfs \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --task-timeout 1000 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# realtime crypto
gcloud run jobs create pipeline-realtime-cryptos \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "realtime-cryptos" \
  --task-timeout 300 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-realtime-cryptos \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --task-timeout 300 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# build ticker prediction models
gcloud run jobs create pipeline-build-ticker-prediction-models \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "build-ticker-prediction-models" \
  --memory 4Gi \
  --cpu 4 \
  --task-timeout 3600 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-build-ticker-prediction-models \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --memory 4Gi \
  --cpu 4 \
  --task-timeout 3600 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \


# update ticker news
gcloud run jobs create pipeline-update-tickers-news \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "update-tickers-news" \
  --task-timeout 600 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-update-tickers-news \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "update-tickers-news" \
  --task-timeout 600 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \


# build admin load-tickers-test
gcloud run jobs create admin-load-tickers-test \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nasdaq.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-load-tickers-test \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nasdaq.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# build admin-load-tickers-nasdaq
gcloud run jobs create admin-load-tickers-nasdaq \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nasdaq.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-load-tickers-nasdaq \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nasdaq.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \


# build admin-load-tickers-nyse
gcloud run jobs create admin-load-tickers-nyse \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nyse.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-load-tickers-nyse \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nyse.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# build admin-load-tickers-nysearca
gcloud run jobs create admin-load-tickers-nysearca \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nysearca.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-load-tickers-nysearca \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-nysearca.xlsx" \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# build admin-load-tickers-crypto
gcloud run jobs create admin-load-tickers-crypto \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-crypto.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-load-tickers-crypto \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "load-tickers,--file,gs://fin-tracker-data-$ENV/tickers-crypto.xlsx" \
  --task-timeout 3600 \
  --memory 1Gi \
  --cpu 2 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

gcloud run jobs create admin-prune-indicators \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "prune-indicators" \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-prune-indicators \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \


gcloud run jobs create admin-prune-sentiments \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "prune-sentiments" \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-prune-sentiments \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

  gcloud run jobs create admin-prune-embeddings \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "prune-embeddings" \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-prune-embeddings \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \


# admin tickers eod (check)
gcloud run jobs create admin-tickers-eod \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "tickers-eod,--symbols,ARM" \
  --task-timeout 1000 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE_DEBUG" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update admin-tickers-eod \
  --image $IMAGE_REGISTRY/fin-tracker-admin/fin-tracker-admin \
  --region $REGION \
  --args "tickers-eod,--symbols,DIA" \
  --task-timeout 1000 \
  --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
  --set-env-vars MONGO_URI=$MONGO_URI \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE_DEBUG" \
  --set-env-vars LOG_FORMAT=json \

