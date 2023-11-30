#!/bin/bash

colima delete -p dockerbuild || true
colima start -p dockerbuild \
	--arch aarch64 \
	--runtime docker \
	--cpu 2 \
	--memory 2
