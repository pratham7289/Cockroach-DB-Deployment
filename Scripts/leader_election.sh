#!/bin/bash
# Leader Election Test for CockroachDB
set -e

echo "Creating bank database and accounts table..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "CREATE DATABASE IF NOT EXISTS bank;"
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -d bank -e "
CREATE TABLE IF NOT EXISTS accounts (id INT PRIMARY KEY, balance DECIMAL);"

echo "Inserting sample data..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -d bank -e "
INSERT INTO accounts (id, balance) VALUES (1, 1000.00), (2, 1500.50), (3, 750.25), (4, 2100.00), (5, 300.00);"

echo "Verifying data..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -d bank -e "SELECT count(*) FROM accounts;"

echo "Checking initial leaseholders..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "SELECT lease_holder, count(*) FROM crdb_internal.ranges GROUP BY lease_holder;"

echo "Simulating node failure..."
kubectl delete pod cockroachdb-1 -n cockroachdb

echo "Checking leaseholders after failure..."
kubectl exec -it cockroachdb-0 -n cockroachdb -- ./cockroach sql --insecure -e "SELECT lease_holder, count(*) FROM crdb_internal.ranges GROUP BY lease_holder;"

echo "Monitoring pod recovery..."
kubectl get pods -n cockroachdb -w
