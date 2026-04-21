#!/bin/bash
# deploy-scheduler.sh
source $(dirname $0)/config.sh $1

PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
BASE_URI="https://$REGION-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/$PROJECT_NUMBER/jobs"

echo "Creating schedulers for project: $PROJECT_ID"
echo "Project number: $PROJECT_NUMBER"
echo "Scheduler SA: $SCHEDULER_SA"
echo "Base URI: $BASE_URI"

# realtime stocks etfs
gcloud scheduler jobs create http pipeline-realtime-stocks-etfs \
  --location $REGION \
  --schedule "*/3 13-20 * * 1-5" \
  --uri "$BASE_URI/pipeline-realtime-stocks-etfs:run" \
  --message-body "{}" \
  --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
  --oauth-service-account-email $SCHEDULER_SA \
  --time-zone "UTC" \
  2>/dev/null || gcloud scheduler jobs update http pipeline-realtime-stocks-etfs \
  --location $REGION \
  --schedule "*/3 13-20 * * 1-5" \
  --uri "$BASE_URI/pipeline-realtime-stocks-etfs:run" \
  --message-body "{}" \
  --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
  --oauth-service-account-email $SCHEDULER_SA \
  --time-zone "UTC" 


# realtime crypto
gcloud scheduler jobs create http pipeline-realtime-crypto \
  --location $REGION \
  --schedule "*/3 * * * *" \
  --uri "$BASE_URI/pipeline-realtime-crypto:run" \
  --message-body "{}" \
  --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
  --oauth-service-account-email $SCHEDULER_SA \
  --time-zone "UTC" \
  2>/dev/null || gcloud scheduler jobs update http pipeline-realtime-crypto \
  --location $REGION \
  --schedule "*/3 * * * *" \
  --uri "$BASE_URI/pipeline-realtime-crypto:run" \
  --message-body "{}" \
  --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
  --oauth-service-account-email $SCHEDULER_SA \
  --time-zone "UTC" 

# tickers eod
gcloud scheduler jobs create http pipeline-tickers-eod \
  --location $REGION \
  --schedule "0 21 * * 1-5" \
  --uri "$BASE_URI/pipeline-tickers-eod:run" \
  --message-body "{}" \
  --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
  --oauth-service-account-email $SCHEDULER_SA \
  --time-zone "UTC" \
  2>/dev/null || gcloud scheduler jobs update http pipeline-tickers-eod \
  --location $REGION \
  --schedule "0 21 * * 1-5" \
  --uri "$BASE_URI/pipeline-tickers-eod:run" \
  --message-body "{}" \
  --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
  --oauth-service-account-email $SCHEDULER_SA \
  --time-zone "UTC" 
  