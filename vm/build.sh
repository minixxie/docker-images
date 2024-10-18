#!/bin/bash

set -e

push=1

scriptPath=$(cd $(dirname "$0") && pwd)

image=minixxie/vm
tag=ubuntu2204-0.0.1
platforms=linux/amd64,linux/arm64/v8
#platforms=linux/amd64
nerdctl build . \
	--namespace=k8s.io \
	-f ./Containerfile \
	--platform $platforms \
	--tag $image:$tag
nerdctl --namespace=k8s.io tag $image:$tag $image:latest

if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl --namespace=k8s.io push --platform $platforms $image:$tag
	nerdctl --namespace=k8s.io push --platform $platforms $image:latest
fi
