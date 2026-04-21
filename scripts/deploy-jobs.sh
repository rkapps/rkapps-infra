#!/bin/bash
source $(dirname $0)/config.sh $1
RUST_LOG_VALUE="fin_services=info,fin_core=info,fin_tracker_pipeline=info"

# tickers eod
gcloud run jobs create pipeline-tickers-eod \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "tickers-eod" \
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-tickers-eod \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-realtime-stocks-etfs \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \

# realtime crypto
gcloud run jobs create pipeline-realtime-crypto \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --args "realtime-crypto" \
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
  2>/dev/null || gcloud run jobs update pipeline-realtime-crypto \
  --image $IMAGE_REGISTRY/fin-tracker-pipeline/fin-tracker-pipeline \
  --region $REGION \
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
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
  --set-env-vars MONGO_ATLAS_CONN_STR=$MONGO_ATLAS_CONN_STR \
  --set-env-vars ALPHA_API_KEY=$ALPHA_API_KEY \
  --set-env-vars TIINGO_API_TOKEN=$TIINGO_API_TOKEN \
  --set-env-vars COINMARKETCAP_API_KEY=$COINMARKETCAP_API_KEY \
  --set-env-vars OPENAI_API_KEY=$OPENAI_API_KEY \
  --set-env-vars "^|^RUST_LOG=$RUST_LOG_VALUE" \
  --set-env-vars LOG_FORMAT=json \
