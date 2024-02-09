#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

cd TIME-SEA-chatgpt
commitID=$(git rev-parse HEAD)
platforms=linux/amd64,linux/arm64/v8
platforms=linux/amd64

image=minixxie/time-sea-chatgpt-web
cd Web/
nerdctl build . \
	-f ../../Dockerfile.web \
	--platform $platforms \
	--tag $image:$commitID
nerdctl tag $image:$commitID $image:latest
nerdctl login
nerdctl push --platform $platforms $image:$commitID
nerdctl push --platform $platforms $image:latest
