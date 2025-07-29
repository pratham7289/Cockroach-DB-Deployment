#!/bin/bash
# Cleanup Script for CockroachDB Tests
set -e

echo "Dropping test_ha table..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "DROP TABLE IF EXISTS test_ha;"

echo "Dropping bank database..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "DROP DATABASE IF EXISTS bank;"

echo "Cleaning up backup files..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- /bin/sh -c "rm -rf /cockroach/cockroach-data/extern/backups/backup-bank"

echo "Cleanup complete."
