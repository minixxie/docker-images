#!/bin/bash

set -e

push=0

scriptPath=$(cd $(dirname "$0") && pwd)

tag=0.0.1
platforms=linux/amd64
image=minixxie/kokoro-tts

nerdctl build . \
	-f Containerfile --platform $platforms \
	--tag $image:$tag \
	--namespace=k8s.io
nerdctl tag $image:$tag $image:latest --namespace=k8s.io

if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl --namespace=k8s.io push --platform $platforms $image:$tag
	nerdctl --namespace=k8s.io push --platform $platforms $image:latest
fi
