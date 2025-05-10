#!/usr/bin/env bash
# kubectl-helper: A Bash utility script for effective Kubernetes cluster management & troubleshooting
# Usage: ./kubectl-helper.sh [command] [options]

set -euo pipefail

# Ensure kubectl is installed
command -v kubectl >/dev/null 2>&1 || { echo >&2 "Error: kubectl is not installed."; exit 1; }

# Print script usage
usage() {
  cat <<EOF
Usage: \$0 <action> [args]

Actions:
  ctx-switch       <context>                       Switch to a different kubeconfig context
  ns-list                                            List all namespaces
  ns-create         <namespace>                     Create a new namespace
  pod-list          [namespace]                     List pods in a namespace (default: all)
  deploy-list       [namespace]                     List deployments
  describe          <resource> <name> [namespace]   Describe a resource
  logs              <pod> [container] [namespace]   Fetch logs from a pod/container
  exec              <pod> [container] [namespace]   Exec into a pod/container
  scale             <deployment> <replicas> [ns]     Scale a deployment
  rollout           <deployment> [namespace]        View rollout status
  rollout-restart   <deployment> [namespace]        Restart a deployment
  top-pods          [namespace]                     Show resource usage of pods
  port-forward      <pod> <local:pod_port> [ns]      Forward port from pod
  apply             <manifest-file>                 Apply Kubernetes manifest
  delete            <resource> <name> [namespace]   Delete a resource
  explain           <resource>                      Show API documentation for a resource

Troubleshooting:
  events            [namespace]                     Show recent events (default: all)
  node-list                                          List nodes and their status
  node-info         <node>                          Describe a specific node
  cs-status                                         Show control-plane component statuses
  pvc-list          [namespace]                     List persistent volume claims
  debug-pod         <pod> [container] [namespace]   Start an ephemeral debug container in a pod
  describe-all      <resource> [namespace]          Describe all resources of a type
  help                                              Show this help message
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
  describe-all)
    ns=${2:+"-n $2"}
    kubectl describe "$1" $ns;;
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

  # Troubleshooting Commands
  events)
    ns=${1:-"--all-namespaces"}
    kubectl get events -n $ns --sort-by='.metadata.lastTimestamp';;
  node-list)
    kubectl get nodes;;
  node-info)
    kubectl describe node "$1";;
  cs-status)
    kubectl get componentstatus;;
  pvc-list)
    ns=${1:-"--all-namespaces"}
    kubectl get pvc -n $ns;;
  debug-pod)
    # Requires Kubernetes v1.18+ with debug support
    ns=${3:-"default"}
    kubectl debug -it "$1" ${2:+-c $2} --image=busybox -n $ns -- /bin/sh;;
  help|*)
    usage;;
esac

