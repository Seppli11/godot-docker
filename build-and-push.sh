#!/bin/bash

sudo docker builder build --build-arg GODOT_VERSION="$1" -t "ghcr.io/seppli11/godot:$1" . || exit 1
sudo docker push "ghcr.io/seppli11/godot:$1" || exit 1
exit 0