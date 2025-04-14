#!/bin/bash

echo

kubectl create ns app-black

while [ true ]; do
    echo "Trying to start app-black instance via background cron"
    kubectl run --image=nginx app-black$RANDOM -n app-black
    sleep 20;
done;

echo
