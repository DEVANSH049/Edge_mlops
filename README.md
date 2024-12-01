# Edge-MLOps Project

## Overview
This project simulates IoT devices and uses KubeEdge for edge-cloud interaction. It includes MQTT for message handling and integrates edgecore and cloudcore for edge computing.

## Prerequisites
1. WSL with Ubuntu or a similar Linux environment.
2. Docker and Python 3.9+ installed.
3. KubeEdge installed using the provided script.
4. MQTT broker (e.g., Mosquitto).

## Steps to Run
1. **Install KubeEdge**:
   ```bash
   bash ./scripts/install_kubeedge.sh
