#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

nerdctl build --platform linux/amd64,linux/arm64/v8 --tag minixxie/xxl-job-admin:2.3.1 .
nerdctl login
nerdctl push --platform linux/amd64,linux/arm64/v8 minixxie/xxl-job-admin:2.3.1
