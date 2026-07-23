#!/bin/bash

set -e

push=1

scriptPath=$(cd $(dirname "$0") && pwd)

cd colibri
commitID=$(git rev-parse HEAD)
platforms=linux/amd64,linux/arm64/v8
#platforms=linux/amd64
image=minixxie/colibri-i

cd "$scriptPath"

nerdctl build . \
	-f "$scriptPath"/Dockerfile --platform $platforms \
	--tag $image:$commitID \
	--build-arg GIT_COMMIT_ID=$commitID \
	--namespace=k8s.io
nerdctl tag $image:$commitID $image:latest --namespace=k8s.io

if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl --namespace=k8s.io push --platform $platforms $image:$commitID
	nerdctl --namespace=k8s.io push --platform $platforms $image:latest
fi
