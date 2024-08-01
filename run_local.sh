#!/bin/bash
##########################################################################
# Name: run_local.sh
#
# Usage: Dockerfile build test. This scripts only used local computer.
#
# Author: Ryosuke Tomita
# Date: 2024/08/01
##########################################################################
#docker rmi react-app:latest -f
#docker build -t react-app:latest . --no-cache
#docker run -p 80:8080 react-app:latest # -p localport:containerport

# .env.developmentでbuildxでbuild
docker buildx bake --set react-app.args.BUILD_ENV=development
# .env.productionでbuildxでbuild
# docker buildx bake --set react-app.args.BUILD_ENV=production

docker compose up

# open your browser and go to `localhost:80`.
