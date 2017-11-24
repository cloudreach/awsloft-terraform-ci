#!/bin/bash

base_url="http://$(aws ssm get-parameters --name $SSM_VAL --query Parameters[0].Value --output text)"
siteList=(
  '/'
  '/wp-content/themes/twentyseventeen/assets/images/header.jpg'
  '/wp-content/themes/twentyseventeen/style.css'
  '/wp-includes/js/jquery/jquery.js'
)


for var in "${siteList[@]}"
do
  status_code=$(curl -L --write-out %{http_code} --silent --output /dev/null ${base_url}${var} )
  if [[ "$status_code" -ne 200 ]] ; then
    echo "[ERROR] ${base_url}${var} : $status_code"
    exit 1
  else
    echo "[SUCCESS] ${base_url}${var} : $status_code"
  fi
done
