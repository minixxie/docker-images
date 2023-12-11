#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

cd static-healthcheck
commitID=$(git rev-parse --short HEAD)

nerdctl build --platform linux/amd64,linux/arm64/v8 --tag minixxie/static-healthcheck:$commitID .
nerdctl tag minixxie/static-healthcheck:$commitID minixxie/static-healthcheck:latest
nerdctl login
nerdctl push --platform linux/amd64,linux/arm64/v8 minixxie/static-healthcheck:$commitID
nerdctl push --platform linux/amd64,linux/arm64/v8 minixxie/static-healthcheck:latest
