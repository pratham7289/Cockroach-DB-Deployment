#!/bin/bash
# Deploy CockroachDB on RHEL 9.6 with k3s
set -e

echo "Updating system..."
sudo dnf update -y
sudo dnf install -y curl

echo "Checking SELinux status..."
sestatus

echo "Installing k3s..."
curl -sfL https://get.k3s.io | sh -

echo "Verifying k3s service..."
sudo systemctl status k3s

echo "Configuring kubectl..."
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $USER:$USER $HOME/.kube/config
echo 'export KUBECONFIG=$HOME/.kube/config' >> ~/.bashrc
source ~/.bashrc

echo "Configuring firewall..."
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=26257/tcp
sudo firewall-cmd --permanent --add-port=26258/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-source=10.42.0.0/16
sudo firewall-cmd --permanent --zone=public --add-source=192.168.0.0/24
sudo firewall-cmd --reload

echo "Deploying CockroachDB Operator..."
curl -s https://raw.githubusercontent.com/cockroachdb/cockroach-operator/v2.12.0/install/crds.yaml -o crds.yaml
kubectl apply -f crds.yaml
curl -s https://raw.githubusercontent.com/cockroachdb/cockroach-operator/v2.12.0/install/operator.yaml -o operator.yaml
kubectl apply -f operator.yaml

echo "Verifying Operator..."
kubectl get pods -n cockroach-operator-system

echo "Creating CockroachDB namespace..."
kubectl create namespace cockroachdb

echo "Deploying CockroachDB cluster..."
kubectl apply -f manifests/cockroachdb-cluster.yaml

echo "Verifying deployment..."
kubectl get pods -n cockroachdb
echo "Access Admin UI at http://localhost:8080 after running:"
echo "kubectl port-forward svc/cockroachdb-public -n cockroachdb 8080:8080"
