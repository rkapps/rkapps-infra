source $(dirname $0)/config.sh $1


# accounts refresh
gcloud run jobs create pipeline-accounts-refresh \
  --image $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline \
  --region $REGION \
  --args "refresh-all" \
  --task-timeout 1000 \
    --set-secrets FINTRACKER_DB_NAME=FINTRACKER_DB_NAME:latest \
    --set-secrets FINTRACKER_MONGO_URI=FINTRACKER_MONGO_URI:latest \
    --set-secrets FINTRACKER_PROJECT_ID=FINTRACKER_PROJECT_ID:latest \
    --set-secrets FINTRACKER_CREDENTIAL_ENCRYPTION_KEY=FINTRACKER_CREDENTIAL_ENCRYPTION_KEY:latest \
    --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
    --set-secrets RUSTIC_FINANCE_MONGO_URI=RUSTIC_FINANCE_MONGO_URI:latest \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars LOG_FORMAT=json \
    2>/dev/null || gcloud run jobs update pipeline-accounts-refresh \
  --image $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline \
  --region $REGION \
  --args "refresh-all" \
  --task-timeout 1000 \
    --set-secrets FINTRACKER_DB_NAME=FINTRACKER_DB_NAME:latest \
    --set-secrets FINTRACKER_MONGO_URI=FINTRACKER_MONGO_URI:latest \
    --set-secrets FINTRACKER_PROJECT_ID=FINTRACKER_PROJECT_ID:latest \
    --set-secrets FINTRACKER_CREDENTIAL_ENCRYPTION_KEY=FINTRACKER_CREDENTIAL_ENCRYPTION_KEY:latest \
    --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
    --set-secrets RUSTIC_FINANCE_MONGO_URI=RUSTIC_FINANCE_MONGO_URI:latest \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars LOG_FORMAT=json
    

# accounts refresh
gcloud run jobs create pipeline-accounts-sync \
  --image $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline \
  --region $REGION \
  --args "sync-all" \
  --task-timeout 1000 \
    --set-secrets FINTRACKER_DB_NAME=FINTRACKER_DB_NAME:latest \
    --set-secrets FINTRACKER_MONGO_URI=FINTRACKER_MONGO_URI:latest \
    --set-secrets FINTRACKER_PROJECT_ID=FINTRACKER_PROJECT_ID:latest \
    --set-secrets FINTRACKER_CREDENTIAL_ENCRYPTION_KEY=FINTRACKER_CREDENTIAL_ENCRYPTION_KEY:latest \
    --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
    --set-secrets RUSTIC_FINANCE_MONGO_URI=RUSTIC_FINANCE_MONGO_URI:latest \
    --set-secrets CARDANO_BLOCKFROST_PROJECT_ID=CARDANO_BLOCKFROST_PROJECT_ID:latest \
    --set-secrets SOLANA_ALCHEMY_API_KEY=SOLANA_ALCHEMY_API_KEY:latest \
    --set-secrets ETHERSCAN_API_KEY=ETHERSCAN_API_KEY:latest \
    --set-secrets POLKADOT_API_KEY=POLKADOT_API_KEY:latest \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars LOG_FORMAT=json \
    2>/dev/null || gcloud run jobs update pipeline-accounts-sync \
  --image $IMAGE_REGISTRY/fin-tracker-go-pipeline/fin-tracker-go-pipeline \
  --region $REGION \
  --args "sync-all" \
  --task-timeout 1000 \
    --set-secrets FINTRACKER_DB_NAME=FINTRACKER_DB_NAME:latest \
    --set-secrets FINTRACKER_MONGO_URI=FINTRACKER_MONGO_URI:latest \
    --set-secrets FINTRACKER_PROJECT_ID=FINTRACKER_PROJECT_ID:latest \
    --set-secrets FINTRACKER_CREDENTIAL_ENCRYPTION_KEY=FINTRACKER_CREDENTIAL_ENCRYPTION_KEY:latest \
    --set-secrets RUSTIC_FINANCE_DB_NAME=RUSTIC_FINANCE_DB_NAME:latest \
    --set-secrets RUSTIC_FINANCE_MONGO_URI=RUSTIC_FINANCE_MONGO_URI:latest \
    --set-secrets CARDANO_BLOCKFROST_PROJECT_ID=CARDANO_BLOCKFROST_PROJECT_ID:latest \
    --set-secrets SOLANA_ALCHEMY_API_KEY=SOLANA_ALCHEMY_API_KEY:latest \
    --set-secrets ETHERSCAN_API_KEY=ETHERSCAN_API_KEY:latest \
    --set-secrets POLKADOT_API_KEY=POLKADOT_API_KEY:latest \
    --set-env-vars LOG_LEVEL=$LOG_LEVEL \
    --set-env-vars LOG_FORMAT=json
    
