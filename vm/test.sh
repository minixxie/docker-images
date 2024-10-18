#!/bin/bash

commands="
python3 --version
pip --version
pip3 --version

node --version
npm --version
yarn --version
grpc_tools_node_protoc --version

go version
buf --version
protoc --version

flutter --version
dart --version

make --version
git version
curl --version
"

while IFS= read -r cmd; do
    if [[ -n "$cmd" ]]; then
	echo "# $cmd"
        eval "$cmd"
    fi
done <<< "$commands"
