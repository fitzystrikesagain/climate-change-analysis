#!/bin/bash

# Download climate data
echo "Downloading CSV files from NOAA server..."
mkdir "$RAW_DATA_DIR"
wget -m ftp://ftp.ncdc.noaa.gov:21/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_*.csv.gz

# Unzip files into raw data dir
echo "Unzipping files into $RAW_DATA_DIR"
ZIPPED_FILES="./ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_*.csv.gz"
for f in $ZIPPED_FILES
do
  STEM=$(basename "${f}" .gz)
  gunzip -c "${f}" > "$RAW_DATA_DIR/${STEM}"
done

# Clean up old files
echo "NOAA storm event data downloaded!"
echo "Cleaning up..."
rm -rfv ./ftp.ncdc.noaa.gov

# Create table
bin/pinot-admin.sh AddTable \
  -tableConfigFile "$TABLE_CONFIG_PATH" \
  -schemaFile "$TABLE_SCHEMA_PATH" -exec

# Ingest data
echo "Launching Pinot data ingestion job from raw storm event files..."
bin/pinot-admin.sh LaunchDataIngestionJob \
  -jobSpecFile "$JOB_SPEC_PATH"
