#!/bin/bash

set -e

push=1

scriptPath=$(cd $(dirname "$0") && pwd)

commitID=1faa464713cc83ed3ae6b6fde3b5f44bf77f98da
platforms=linux/amd64,linux/arm64/v8
image=minixxie/nutlope-llamacoder

nerdctl build . \
	-f Containerfile --platform $platforms \
	--tag $image:$commitID \
	--build-arg GIT_COMMIT_ID=$commitID \
	--namespace=k8s.io
nerdctl tag $image:$commitID $image:latest --namespace=k8s.io

if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl --namespace=k8s.io push --platform $platforms $image:$commitID
	nerdctl --namespace=k8s.io push --platform $platforms $image:latest
fi
