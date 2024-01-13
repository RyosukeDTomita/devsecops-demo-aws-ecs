#!/bin/bash
##########################################################################
# Name: docker_test.sh
#
# Usage: Dockerfile build test. This scripts only used local computer.
#
# Author: Ryosuke Tomita
# Date: 2023/12/06
##########################################################################
docker rmi react-app:latest -f
#docker build -t react-app:latest . --no-cache
#docker run -p 80:8080 react-app:latest # -p localport:containerport
docker compose up

# open your browser and go to `localhost:80`.
