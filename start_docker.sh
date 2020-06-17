#!/usr/bin/env bash
docker version
docker rmi $(docker images -a -q)
docker system prune
docker build --tag sample:1.0.0 .
docker images
