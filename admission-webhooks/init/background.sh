#!/bin/bash

# wait fo k8s ready
while ! kubectl get nodes | grep -w "Ready"; do
  echo "WAIT FOR NODES READY"
  sleep 1
done
touch /ks/.k8sfinished

# allow pods to run on controlplane
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-

kubectl create ns app-white
kubectl run --image=nginx app-white -n app-white

helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
helm install kyverno kyverno/kyverno -n kyverno \
 --set backgroundController.enabled=false \
 --set cleanupController.enabled=false \
 --set reportsController.enabled=false \
 --create-namespace \
 --set features.autoUpdateWebhooks.enabled=false

echo -n "Waiting to see webhooks"

while [ $( kubectl get ValidatingWebhookConfiguration,MutatingWebhookConfiguration | wc -l ) -gt 5 ]; do
    echo -n '.'
    sleep 1;
done;
echo " done waiting for webhooks"

# make sure all webhooks are installed
sleep 2;

kubectl scale deployment kyverno -n kyverno --replicas=0

# mark init finished
touch /ks/.initfinished