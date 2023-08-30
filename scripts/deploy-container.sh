#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
OUTPUT_IMAGE_NAME="${OUTPUT_IMAGE_NAME:-'image:latest'}"
DOCKERFILE="${DOCKERFILE:-'.'}"
REGISTRY_USER="${REGISTRY_USER:-'user'}"
REGISTRY_DOMAIN="${REGISTRY_DOMAIN:-'ghcr.io'}"
REGISTRY_TOKEN="${REGISTRY_TOKEN:-'token'}"

_CONTAINERS_USERNS_CONFIGURED=""

podman system migrate

REGISTRY_USER=$(echo "${REGISTRY_USER}" | tr '[:upper:]' '[:lower:]')
REGISTRY_DOMAIN=$(echo "${REGISTRY_DOMAIN}" | tr '[:upper:]' '[:lower:]')
OUTPUT_IMAGE_NAME=$(echo "${OUTPUT_IMAGE_NAME}" | tr '[:upper:]' '[:lower:]')
echo "${REGISTRY_TOKEN}" | podman login "${REGISTRY_DOMAIN}" -u "${REGISTRY_USER}" --password-stdin

cd "${DOCKERFILE}"

podman build -t "${REGISTRY_USER}"/"${OUTPUT_IMAGE_NAME}" .

podman tag "${REGISTRY_USER}"/"${OUTPUT_IMAGE_NAME}" "$REGISTRY_DOMAIN"/"$REGISTRY_USER"/"${OUTPUT_IMAGE_NAME}"

podman push "$REGISTRY_DOMAIN"/"$REGISTRY_USER"/"${OUTPUT_IMAGE_NAME}"
