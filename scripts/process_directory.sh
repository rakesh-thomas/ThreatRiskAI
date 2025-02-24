#!/bin/bash

# Set default log level
LOG_LEVEL="INFO"

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $LOG_LEVEL - $1"
}

# Function to process a single file
process_file() {
  local file="$1"
  local data_type="$2"
  local platform="$3"

  log "Processing file: $file (Data Type: $data_type, Platform: $platform)"

  # Execute main.py with the specified arguments
  python main.py "$file" "$data_type" "$platform" --verbose 2>&1 | while read -r line; do
    log "  $line"
  done

  # Check the exit code of the python script
  if [ $? -eq 0 ]; then
    log "Successfully processed file: $file"
  else
    log "Failed to process file: $file"
  fi
}

# Check if the correct number of arguments is provided
if [ $# -ne 3 ]; then
  log "Usage: $0 <directory> <data_type> <platform>"
  exit 1
fi

# Set the directory, data_type, and platform from the command line arguments
directory="$1"
data_type="$2"
platform="$3"

# Check if the directory exists
if [ ! -d "$directory" ]; then
  log "Error: Directory '$directory' not found."
  exit 1
fi

# Find all files in the directory and its subdirectories
find "$directory" -type f -name "*.json" | while read -r file; do
  process_file "$file" "$data_type" "$platform"
done

log "Finished processing all files."

exit 0
