# This script sets up a Minikube cluster with Calico CNI
## minikube delete -p nixos-dev-cluster
minikube start --network-plugin=cni --cni=calico -p nixos-dev-cluster
kubectx nixos-dev-cluster
kubectl get all 

