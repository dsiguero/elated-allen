#!/usr/bin/env bash
set -e

declare region="eu-west-1"
declare aws_account_id="657204627722"
declare ecr_endpoint="${aws_account_id}.dkr.ecr.${region}.amazonaws.com"

declare environment="develop"
declare ecr_registry_name

version=$(jq -r '.version' package.json)

# Use develop as the environment unless it's defined as an argument
if [[ "$#" -eq 1 ]]; then
    environment="$1"
fi

ecr_registry_name="elated-allen-${environment}-core-image-registry"

echo "Environment: ${environment}"

echo
echo "Login against ECR..."
aws ecr get-login-password --region "${region}" | docker login --username AWS --password-stdin "${ecr_endpoint}"

echo
echo "Building docker image..."
docker build -t "${ecr_registry_name}:${version}" .
docker tag "${ecr_registry_name}:${version}" "${ecr_endpoint}/${ecr_registry_name}:${version}"

echo
echo "Pushing image to ECR..."
docker push "${ecr_endpoint}/${ecr_registry_name}:${version}"

exit 0;