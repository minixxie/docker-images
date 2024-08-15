#!/bin/bash

set -e

push=1

scriptPath=$(cd $(dirname "$0") && pwd)

cd omniparse
commitID=$(git rev-parse HEAD)

image=minixxie/omniparse-cuda
platforms=linux/amd64,linux/arm64/v8
platforms=linux/amd64
nerdctl build . \
	--namespace=k8s.io \
	-f ./Dockerfile \
	--platform $platforms \
	--tag $image:$commitID
nerdctl --namespace=k8s.io tag $image:$commitID $image:latest

if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl --namespace=k8s.io push --platform $platforms $image:$commitID
	nerdctl --namespace=k8s.io push --platform $platforms $image:latest
fi
