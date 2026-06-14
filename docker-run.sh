#!/bin/bash
docker run --rm -v "$(pwd):/data" -w /data ghcr.io/igiteam/giga-grabber/giga-grabber:latest "$@"
