#!/bin/bash
set -euo pipefail

LOG_DIR="./logs"
CLOUDCORE_CONFIG="./kubeedge/cloudcore.yaml"
DEFAULT_PORT=10102

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date)] $1" | tee -a "$LOG_DIR/cloudcore.log"
}

check_port_usage() {
    local port=$1
    if sudo ss -tuln | grep -q ":$port"; then
        log "Port $port is already in use. Attempting to free it."
        local pid
        pid=$(sudo lsof -t -i:"$port" || echo "")
        if [ -n "$pid" ]; then
            log "Killing process $pid using port $port"
            sudo kill -9 "$pid"
        fi
    fi
}

# Validate CloudCore configuration file
if [ ! -f "$CLOUDCORE_CONFIG" ]; then
    log "CloudCore configuration file not found: $CLOUDCORE_CONFIG"
    exit 1
fi

# Ensure that the required directory exists and has proper permissions
if [ ! -d "/var/lib/kubeedge" ]; then
    log "Creating /var/lib/kubeedge directory"
    sudo mkdir -p /var/lib/kubeedge
    sudo chown "$(whoami):$(whoami)" /var/lib/kubeedge
fi

# Check if CloudCore process is running and handle appropriately
if pgrep -f "cloudcore" > /dev/null; then
    log "CloudCore process detected. Stopping it now."
    pkill -f "cloudcore"
    sleep 2  # Give time for cleanup
else
    log "No running CloudCore process detected."
fi

# Check for port conflicts
log "Checking port $DEFAULT_PORT for conflicts"
check_port_usage "$DEFAULT_PORT"

log "Starting CloudCore"
cloudcore --config="$CLOUDCORE_CONFIG" &>> "$LOG_DIR/cloudcore.log" &
if [ $? -eq 0 ]; then
    log "CloudCore started successfully"
else
    log "Failed to start CloudCore. Check logs for details."
fi
