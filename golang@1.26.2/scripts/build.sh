#!/bin/bash

set -e

if [ "$1" != "" ]; then
	cmds="./cmd/$1"
else
	cmds=`ls -d ./cmd/*`
fi

for cmd in $cmds
do
	cmdName=$(basename "$cmd")
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -buildvcs=false -o ./bin/$cmdName $cmd
done
