#!/bin/bash

# Exports .env variables to local environment
export "$(grep -E 'PINOT_APP_NAME' docker/.env)"
export "$(grep -E 'IMPORT_SCRIPT' docker/.env)"

# Imports NOAA storm event data into Apache Pinot
docker exec -ti "$PINOT_APP_NAME" bash -c "sh $IMPORT_SCRIPT"

# Initializes the Superset application and imports datasources and dashboards
docker exec -ti -u root "$SUPERSET_APP_NAME" bash -c "sh ./docker-init.sh"

# Open the browser for Pinot query console and Superset dashboard page
open http://localhost:9000/#/query
open http://localhost:8088

echo "Success! Login to Superset using the credentials admin/admin"
