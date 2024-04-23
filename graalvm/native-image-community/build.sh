#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

push=1

image=minixxie/graalvm-native-image-community
tag=21.0.2
platforms=linux/amd64,linux/arm64/v8

nerdctl build . \
	--namespace=k8s.io \
	-f Dockerfile \
	--platform $platforms \
	--tag $image:$tag

if [ $push -eq 1 ]; then
	nerdctl login
	nerdctl --namespace=k8s.io push --platform $platforms $image:$tag
fi
