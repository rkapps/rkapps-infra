#!/bin/bash
# deploy-scheduler.sh
source config.sh

PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
BASE_URI="https://$REGION-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/$PROJECT_NUMBER/jobs"

echo "Creating schedulers for project: $PROJECT_ID"
echo "Project number: $PROJECT_NUMBER"
echo "Scheduler SA: $SCHEDULER_SA"
echo "Base URI: $BASE_URI"


create_or_update_scheduler() {
  local job_name=$1
  local schedule=$2
  local uri=$3

  if gcloud scheduler jobs describe $job_name --location $REGION &>/dev/null; then
    echo "Updating $job_name..."
    gcloud scheduler jobs update http $job_name \
      --location $REGION \
      --schedule "$schedule" \
      --uri "$uri" \
      --message-body "{}" \
      --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
      --oauth-service-account-email $SCHEDULER_SA \
      --time-zone "UTC"
  else
    echo "Creating $job_name..."
    gcloud scheduler jobs create http $job_name \
      --location $REGION \
      --schedule "$schedule" \
      --uri "$uri" \
      --message-body "{}" \
      --oauth-token-scope "https://www.googleapis.com/auth/cloud-platform" \
      --oauth-service-account-email $SCHEDULER_SA \
      --time-zone "UTC"
  fi
}


# usage
create_or_update_scheduler \
  "pipeline-update-tickers-eod" \
  "0 21 * * 1-5" \
  "$BASE_URI/pipeline-update-tickers-eod:run"

create_or_update_scheduler \
  "pipeline-update-stocks-etfs-realtime" \
  "*/8 13-20 * * 1-5" \
  "$BASE_URI/pipeline-update-stocks-etfs-realtime:run"

create_or_update_scheduler \
  "pipeline-update-cryptos-realtime" \
  "*/3 * * * *" \
  "$BASE_URI/pipeline-update-cryptos-realtime:run"  

create_or_update_scheduler \
  "pipeline-update-tickers-news" \
  "0 18-22/2 * * *" \
  "$BASE_URI/pipeline-update-tickers-news:run"  