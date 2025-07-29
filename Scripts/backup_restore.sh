#!/bin/bash
# Backup and Restore Test for CockroachDB
set -e

echo "Creating backup of bank database..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure --execute \
"BACKUP DATABASE bank INTO 'nodelocal://1/backup-bank';"

echo "Verifying backup files..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- /bin/sh -c "ls /cockroach/cockroach-data/extern/backups/backup-bank"

echo "Restoring database..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure --execute \
"RESTORE DATABASE bank FROM 'nodelocal://1/backup-bank';"

echo "Verifying restored data..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "SELECT count(*) FROM bank.accounts;"

echo "Note: nodelocal backups are not persistent. Use S3 or Persistent Volumes in production."
