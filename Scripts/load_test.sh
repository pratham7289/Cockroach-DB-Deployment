#!/bin/bash
# Load Balancing Test for CockroachDB
set -e

echo "Setting up bank database and accounts table..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "CREATE DATABASE IF NOT EXISTS bank;"
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "
CREATE TABLE IF NOT EXISTS bank.accounts (id INT PRIMARY KEY, balance DECIMAL);"

echo "Inserting 10,000 rows..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "
BEGIN;
INSERT INTO bank.accounts (id, balance)
SELECT generate_series AS id, (random() * 10000)::DECIMAL(10,2) AS balance
FROM generate_series(1, 10000);
COMMIT;"

echo "Inserting 1,000,000 rows..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "
BEGIN;
INSERT INTO bank.accounts (id, balance)
SELECT generate_series + 10000 AS id, (random() * 10000)::DECIMAL(10,2) AS balance
FROM generate_series(1, 1000000);
COMMIT;"

echo "Verifying data..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "SELECT count(*) FROM bank.accounts;"

echo "Checking node health..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach node status --insecure

echo "Verifying load distribution..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "SELECT lease_holder, count(*) FROM crdb_internal.ranges GROUP BY lease_holder;"
