#!/bin/bash

docker buildx create --name mybuilder --driver-opt 'image=moby/buildkit:v0.12.1-rootless' --bootstrap --use
