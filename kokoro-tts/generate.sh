#!/bin/bash

nerdctl --namespace=k8s.io run --rm -it -v "$PWD":/out -w /out minixxie/kokoro-tts:0.0.1 "$@"
