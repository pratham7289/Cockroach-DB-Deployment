CockroachDB Fintech Demo

This repository demonstrates a CockroachDB deployment on RHEL 9.6 using k3s, with automated tests for high availability, leader election, load balancing, and backup/restore. It showcases DevOps, distributed systems, and database skills through detailed documentation, automation scripts, and a fintech scenario (PayFast app).
Overview
CockroachDB is a cloud-native, distributed SQL database designed for scalability, reliability, and strong consistency, ideal for fintech applications. This project includes:

Deployment of a 3-pod CockroachDB cluster on RHEL 9.6 with k3s.
Tests validating high availability (HA), leader election, load balancing, and backup/restore.
Explanation of core concepts (nodes, ranges, Raft, gossip) using a PayFast payment app scenario.

Contents

Introduction to CockroachDB: Overview and fintech relevance.
Architecture and Core Concepts: Nodes, ranges, Raft, and gossip with PayFast examples.
Deployment Guide: Step-by-step setup on RHEL 9.6 with k3s.
Test Plans:
High Availability
Leader Election
Load Balancing
Backup and Restore


Scripts: Automation for deployment and tests.
Kubernetes Manifest: 3-pod cluster configuration.
Diagrams: Architecture visuals and Admin UI screenshots.

Setup

Clone the repository:git clone https://github.com/[Your-GitHub-Username]/cockroachdb-fintech-demo
cd cockroachdb-fintech-demo


Deploy the cluster:./scripts/deploy-cockroachdb.sh


Access the Admin UI:kubectl port-forward svc/cockroachdb-public -n cockroachdb 8080:8080

Open http://localhost:8080.

Running Tests
Execute test scripts:
./scripts/ha-test.sh
./scripts/leader-election-test.sh
./scripts/load-test.sh
./scripts/backup-restore.sh
./scripts/cleanup.sh  # Reset environment

Visuals

Architecture diagrams: docs/diagrams/cluster-architecture.png, docs/diagrams/raft-consensus.png.
Admin UI screenshots: docs/diagrams/admin-ui-screenshots/.

Prerequisites

RHEL 9.6 VM (3 vCPUs, 8GB RAM).
Root/sudo privileges.
Internet access.

Contributing
See CONTRIBUTING.md for guidelines.
License
MIT
