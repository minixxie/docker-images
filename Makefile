SHELL := /bin/bash

build:
	git submodule update --init
	cd golang@1.21.0 && ./build.sh && cd -
	cd eclipse-temurin/19.0.1_10-jdk-mvn && ./build.sh && cd -
	cd eclipse-temurin/19.0.1_10-jre && ./build.sh && cd -
	cd eclipse-temurin/21.0.2_13-jdk && ./build.sh && cd -
	cd eclipse-temurin/21.0.2_13-jre && ./build.sh && cd -
	cd graalvm/native-image-community && ./build.sh && cd -
	cd static-healthcheck && ./build.sh && cd -
	cd xxl-job-admin/2.3.1 && ./build.sh && cd -
	cd privateGPT && ./build.sh && cd -
	cd ragflow && ./build.sh && cd -
	cd omniparse && ./build.sh && cd -
	cd nutlope-ollamacoder && ./build.sh && cd -
	cd minixxie-ollamacoder && ./build.sh && cd -
	cd vm && ./build.sh && cd -
	cd bolt.diy && ./build.sh && cd -
	cd kokoro-tts && ./build.sh && cd -
