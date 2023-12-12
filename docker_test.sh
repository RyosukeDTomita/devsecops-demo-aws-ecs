#!/bin/bash
docker rmi react-app:latest -f
docker build -t react-app:latest . --no-cache
docker run -p 80:80 react-app:latest # -p containerport:localport
# localhostにアクセスすると見れる。
