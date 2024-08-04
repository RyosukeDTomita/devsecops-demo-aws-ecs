#!/bin/bash
##########################################################################
# Name: run_local.sh
#
# Usage: Dockerfile build test. This scripts only used local computer.
#
# Author: Ryosuke Tomita
# Date: 2024/08/01
##########################################################################
# -----composeを使わない場合-----
# docker build -t react-app:latest . --build-arg BUILD_ENV=production
# docker run -p 80:8080 react-app:latest # -p localport:containerport

# -----composeを使う-----
# buildxを使わない場合の引数の設定方法
#docker compose build --build-arg BUILD_ENV=development
# .env.developmentでbuildxでbuild
docker buildx bake --set react-app.args.BUILD_ENV=development
# .env.productionでbuildxでbuild
# docker buildx bake --set react-app.args.BUILD_ENV=production
# 起動
docker compose up

# open your browser and go to `localhost:80`.
