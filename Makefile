SHELL := /bin/bash

build:
	cd eclipse-temurin/19.0.1_10-jdk-mvn && ./build.sh && cd -
	cd eclipse-temurin/19.0.1_10-jre && ./build.sh && cd -
	cd static-healthcheck && ./build.sh && cd -
	cd xxl-job-admin/2.3.1 && ./build.sh && cd -
	cd privateGPT && ./build.sh && cd -
