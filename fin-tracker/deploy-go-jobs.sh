source $(dirname $0)/config.sh $1


# tickers eod
gcloud run jobs create pipeline-accounts-refresh \
  --image $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline \
  --region $REGION \
  --args "refresh-all" \
  --task-timeout 1000 \
    --set-env-vars FINTRACKER_MONGO_URI=$FINTRACKER_MONGO_URI \
    --set-env-vars FINANCE_MONGO_URI=$FINANCE_MONGO_URI \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars FIREBASE_PROJECT_ID=$PROJECT_ID \
    --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
    --set-env-vars FINTRACKER_PROJECT_ID=$FINTRACKER_PROJECT_ID \
    --set-env-vars LOG_FORMAT=json
      2>/dev/null || gcloud run jobs update pipeline-accounts-refresh \
  --image $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline \
  --region $REGION \
  --args "refresh-all" \
  --task-timeout 1000 \
    --set-env-vars FINTRACKER_MONGO_URI=$FINTRACKER_MONGO_URI \
    --set-env-vars FINANCE_MONGO_URI=$FINANCE_MONGO_URI \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars FIREBASE_PROJECT_ID=$PROJECT_ID \
    --set-env-vars FINTRACKER_DB_NAME=$FINTRACKER_DB_NAME \
    --set-env-vars FINTRACKER_PROJECT_ID=$FINTRACKER_PROJECT_ID \
    --set-env-vars LOG_FORMAT=json
    
