#!/bin/bash

set -e

scriptPath=$(cd $(dirname "$0") && pwd)

commitID=a79e02c36dedb0b981e6cfbcd16b4010cb3a909d  # from minixxie's fork
platforms=linux/amd64,linux/arm64/v8

nerdctl build . \
	-f Dockerfile --platform $platforms \
	--tag minixxie/privategpt:$commitID \
	--build-arg GIT_COMMIT_ID=$commitID \
	--namespace=k8s.io
nerdctl tag minixxie/privategpt:$commitID minixxie/privategpt:latest --namespace=k8s.io
nerdctl login
nerdctl push --platform $platforms minixxie/privategpt:$commitID --namespace=k8s.io
nerdctl push --platform $platforms minixxie/privategpt:latest --namespace=k8s.io
