#!/bin/bash
set -e

echo "Checking Weather application"

for i in {1..12}; do

  if curl -fsS http://localhost/ > /dev/null; then
    echo "Weather application is healthy"
    exit 0
  fi

  sleep 5

done

echo "Application health check failed"

docker logs weather-container

exit 1