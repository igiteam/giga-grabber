#!/bin/bash
# Helper script to run giga-grabber Docker image

# Get the image name - use environment variable or default
IMAGE="${GIGA_GRABBER_IMAGE:-ghcr.io/igiteam/giga-grabber/giga-grabber:latest}"

# Check if image exists locally, if not pull it
if ! docker image inspect "$IMAGE" &> /dev/null; then
    echo "📥 Pulling Docker image..."
    docker pull "$IMAGE"
fi

# Run the container with current directory mounted for input/output
docker run --rm -v "$(pwd):/data" -w /data "$IMAGE" "$@"
