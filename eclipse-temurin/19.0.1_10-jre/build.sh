#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

nerdctl build -f Dockerfile --platform linux/amd64,linux/arm64/v8 --tag minixxie/eclipse-temurin:19.0.1_10-jre .
nerdctl login
nerdctl push --platform linux/amd64,linux/arm64/v8 minixxie/eclipse-temurin:19.0.1_10-jre
