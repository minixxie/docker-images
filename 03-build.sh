#!/bin/bash

docker login

cd eclipse-temurin/19.0.1_10-jdk-mvn && \
	docker buildx build --push --platform linux/amd64,linux/arm64/v8 --tag minixxie/eclipse-temurin:19.0.1_10-jdk-mvn . \
	&& cd -
