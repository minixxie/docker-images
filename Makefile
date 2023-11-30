SHELL := /bin/bash

tools:
	brew install colima
	brew install docker
	brew install docker-buildx

builder-vm:
	./00-builder-vm.sh

ssh:
	./01-ssh.sh

builder:
	./02-builder.sh

build:
	./03-build.sh
