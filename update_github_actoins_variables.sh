#!/bin/bash
for environment in "development" "staging" "production";
do
  echo $environment
  gh variable set --env $environment --env-file .env.$environment
  gh variable list --env $environment
done
