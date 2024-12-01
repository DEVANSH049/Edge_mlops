#!/bin/bash
set -euo pipefail

LOG_DIR="./logs"
KUBEEDGE_DIR="./kubeedge"
KUBEEDGE_VERSION="v1.12.1"
DOWNLOAD_URL="https://github.com/kubeedge/kubeedge/releases/download/$KUBEEDGE_VERSION/kubeedge-$KUBEEDGE_VERSION-linux-amd64.tar.gz"

mkdir -p "$LOG_DIR" "$KUBEEDGE_DIR"

log() {
    echo "[$(date)] $1" | tee -a "$LOG_DIR/install_kubeedge.log"
}

log "Downloading KubeEdge $KUBEEDGE_VERSION"
curl -L "$DOWNLOAD_URL" -o "$KUBEEDGE_DIR/kubeedge.tar.gz"

log "Extracting KubeEdge binaries"
tar -xzf "$KUBEEDGE_DIR/kubeedge.tar.gz" -C "$KUBEEDGE_DIR"

log "Setting up KubeEdge components"

# Update paths for cloudcore and edgecore
sudo mv "$KUBEEDGE_DIR/kubeedge-v1.12.1-linux-amd64/cloud/cloudcore/cloudcore" /usr/local/bin/
sudo mv "$KUBEEDGE_DIR/kubeedge-v1.12.1-linux-amd64/edge/edgecore" /usr/local/bin/

log "KubeEdge installation complete"
