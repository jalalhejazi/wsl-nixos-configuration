#!/usr/bin/env bash
# kubectl-helper: A Bash utility script for effective Kubernetes cluster management
# Usage: ./kubectl-helper.sh [command] [options]

set -euo pipefail

# Ensure kubectl is installed
command -v kubectl >/dev/null 2>&1 || { echo >&2 "Error: kubectl is not installed."; exit 1; }

# Print script usage
usage() {
  cat <<EOF
Usage: \$0 <action> [args]

Actions:
  ctx-switch   <context>           Switch to a different kubeconfig context
  ns-list                          List all namespaces
  ns-create    <namespace>         Create a new namespace
  pod-list     [namespace]         List pods in a namespace (default: all)
  deploy-list  [namespace]         List deployments
  describe     <resource> <name> [namespace]  Describe a resource
  logs         <pod> [container] [namespace]  Fetch logs from a pod/container
  exec         <pod> [container] [namespace]  Exec into a pod/container
  scale        <deployment> <replicas> [namespace]  Scale a deployment
  rollout      <deployment> [namespace]  View rollout status
  rollout-restart <deployment> [namespace]  Restart a deployment
  top-pods     [namespace]         Show resource usage of pods
  port-forward <pod> <local_port>:<pod_port> [namespace]  Forward port from pod
  apply        <manifest-file>     Apply Kubernetes manifest
  delete       <resource> <name> [namespace]  Delete a resource
  explain      <resource>          Show API documentation for a resource
  help                             Show this help message
EOF
}

# Main dispatcher
action=${1:-help}
shift || true

case "$action" in
  ctx-switch)
    echo "Switching context to '$1'..."
    kubectl config use-context "$1";;
  ns-list)
    kubectl get ns;;
  ns-create)
    kubectl create namespace "$1";;
  pod-list)
    ns=${1:-"--all-namespaces"}
    kubectl get pods -n $ns;;
  deploy-list)
    ns=${1:-"--all-namespaces"}
    kubectl get deployments -n $ns;;
  describe)
    kubectl describe "$1" "$2" ${3:+-n $3};;
  logs)
    kubectl logs "$1" ${2:+-c $2} ${3:+-n $3};;
  exec)
    kubectl exec -it "$1" ${2:+-c $2} ${3:+-n $3} -- /bin/sh;;
  scale)
    kubectl scale deployment "$1" --replicas="$2" ${3:+-n $3};;
  rollout)
    kubectl rollout status deployment "$1" ${2:+-n $2};;
  rollout-restart)
    kubectl rollout restart deployment "$1" ${2:+-n $2};;
  top-pods)
    kubectl top pods ${1:+-n $1};;
  port-forward)
    kubectl port-forward "$1" "$2" ${3:+-n $3};;
  apply)
    kubectl apply -f "$1";;
  delete)
    kubectl delete "$1" "$2" ${3:+-n $3};;
  explain)
    kubectl explain "$1";;
  help|*)
    usage;;
esac

