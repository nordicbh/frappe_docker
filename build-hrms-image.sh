#!/bin/bash

# Build and push custom ERPNext + HRMS image to Docker Hub

# Configuration - Update these with your Docker Hub username
DOCKER_HUB_USERNAME="nordicdevs"
IMAGE_NAME="nordic-erpnext-hrms"
IMAGE_TAG="v15"

# Full image name
FULL_IMAGE_NAME="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "Building custom ERPNext + HRMS image..."

# Base64 encode the apps.json file
# macOS base64 doesn't support -w flag, use -i for input file
export APPS_JSON_BASE64=$(base64 -i apps.json)

# Build the image using the layered Containerfile (faster build)
docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=${FULL_IMAGE_NAME} \
  --file=images/layered/Containerfile .

if [ $? -eq 0 ]; then
    echo "Build successful!"
    
    echo "Logging in to Docker Hub..."
    docker login
    
    if [ $? -eq 0 ]; then
        echo "Pushing image to Docker Hub..."
        docker push ${FULL_IMAGE_NAME}
        
        if [ $? -eq 0 ]; then
            echo "Successfully pushed ${FULL_IMAGE_NAME} to Docker Hub!"
            echo ""
            echo "To use this image, update your .env file with:"
            echo "CUSTOM_IMAGE=${DOCKER_HUB_USERNAME}/${IMAGE_NAME}"
            echo "CUSTOM_TAG=${IMAGE_TAG}"
            echo "PULL_POLICY=always"
        else
            echo "Failed to push image to Docker Hub"
            exit 1
        fi
    else
        echo "Docker login failed"
        exit 1
    fi
else
    echo "Build failed!"
    exit 1
fi