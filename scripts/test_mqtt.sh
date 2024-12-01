#!/bin/bash
set -euo pipefail

LOG_DIR="./logs"
MQTT_BROKER="localhost"
PORT=1883
TOPIC="devices/data"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date)] $1" | tee -a "$LOG_DIR/mqtt.log"
}

log "Testing MQTT Broker on $MQTT_BROKER:$PORT"
if ! nc -z "$MQTT_BROKER" "$PORT"; then
    log "Cannot connect to MQTT Broker"
    exit 1
fi

log "Subscribing to MQTT topic $TOPIC"
timeout 30 mosquitto_sub -h "$MQTT_BROKER" -p "$PORT" -t "$TOPIC" -C 5 || {
    log "MQTT subscription failed"
    exit 1
}

log "MQTT test successful"
