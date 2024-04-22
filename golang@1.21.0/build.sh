#!/bin/bash

set -e
push=1

scriptPath=$(cd $(dirname "$0") && pwd)

image=minixxie/golang
tag=1.21.0
platforms=linux/amd64,linux/arm64/v8

nerdctl build . \
	-f Dockerfile \
	--platform $platforms \
	--tag $image:$tag \
	--namespace=k8s.io
if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl push --platform $platforms $image:$tag --namespace=k8s.io
fi
