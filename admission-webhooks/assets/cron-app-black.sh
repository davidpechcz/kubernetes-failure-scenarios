#!/bin/bash

while [ true ]; do
    kubectl run --image=nginx app-black$RANDOM -n app-black
    sleep 20;
done;
