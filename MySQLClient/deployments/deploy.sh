#!/bin/bash

NAMESPACE=kubearmor

if [ ! -z $1 ]; then
    NAMESPACE=$1
else
    echo "Default Namespace: $NAMESPACE"
fi

kubectl get namespace $NAMESPACE > /dev/null 2>&1
if [ $? != 0 ]; then
    kubectl create namespace $NAMESPACE
fi

KUBEARMOR_MYSQL=$(kubectl get pods -n $NAMESPACE | grep mysql | wc -l)
if [ $KUBEARMOR_MYSQL == 0 ]; then
    kubectl apply -n $NAMESPACE -f mysql/mysql-deployment.yaml
fi

KUBEARMOR_CLIENT=$(kubectl get pods -n $NAMESPACE | grep mysql-client | wc -l)
if [ $KUBEARMOR_CLIENT == 0 ]; then
    kubectl apply -n $NAMESPACE -f client-deployment.yaml
fi
