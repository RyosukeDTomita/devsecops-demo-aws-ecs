#!/bin/bash
##########################################################################
# Name: docker_test.sh
#
# Usage: Dockerfile build test. This scripts only used local computer.
#
# Author: Ryosuke Tomita
# Date: 2023/12/06
##########################################################################
#docker rmi react-app:latest -f
docker build -t react-app:latest . --no-cache
docker run --rm -p 8080:80 react-app:latest # -p containerport:localport

# open your browser and go to `localhost:80`.
