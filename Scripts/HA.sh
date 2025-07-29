#!/bin/bash
# High Availability Test for CockroachDB
set -e

echo "Removing existing test data..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "DROP TABLE IF EXISTS test_ha;"

echo "Verifying cluster health..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach node status --insecure

echo "Checking replication configuration..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "SHOW ZONE CONFIGURATION FOR DATABASE defaultdb;"

echo "Creating and populating test table..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "
CREATE TABLE test_ha (id INT PRIMARY KEY, name STRING);
INSERT INTO test_ha VALUES (1, 'test1'), (2, 'test2');
SELECT * FROM test_ha;"

echo "Verifying data replication..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "SHOW RANGES FROM TABLE test_ha;"

echo "Simulating node failure..."
kubectl delete pod -n cockroachdb cockroachdb-1

echo "Testing query availability..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "
SELECT * FROM test_ha;
INSERT INTO test_ha VALUES (3, 'test3');
SELECT * FROM test_ha;"

echo "Confirming data post-recovery..."
kubectl exec -it -n cockroachdb cockroachdb-0 -- ./cockroach sql --insecure -e "SELECT * FROM test_ha;"

echo "Check Admin UI at http://localhost:8080 (run: kubectl port-forward svc/cockroachdb-public -n cockroachdb 8080:8080)"
