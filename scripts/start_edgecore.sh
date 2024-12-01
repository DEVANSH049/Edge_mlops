#!/bin/bash
set -euo pipefail

LOG_DIR="./logs"
EDGECORE_CONFIG="./kubeedge/edgecore.yaml"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date)] $1" | tee -a "$LOG_DIR/edgecore.log"
}

# Validate EdgeCore configuration file
if [ ! -f "$EDGECORE_CONFIG" ]; then
    log "EdgeCore configuration file not found: $EDGECORE_CONFIG"
    exit 1
fi

# Stop any running EdgeCore process
if pgrep -f "edgecore" > /dev/null; then
    log "Stopping currently running EdgeCore process"
    pkill -f "edgecore"
fi

log "Starting EdgeCore"
edgecore --config="$EDGECORE_CONFIG" &>> "$LOG_DIR/edgecore.log" &
log "EdgeCore started successfully"
