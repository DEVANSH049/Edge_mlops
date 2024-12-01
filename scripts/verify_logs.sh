#!/bin/bash

echo "Verifying logs..."

if [ -f "../logs/cloudcore.log" ]; then
    echo "CloudCore Logs:"
    tail -n 10 ../logs/cloudcore.log
else
    echo "CloudCore log not found."
fi

if [ -f "../logs/edgecore.log" ]; then
    echo "EdgeCore Logs:"
    tail -n 10 ../logs/edgecore.log
else
    echo "EdgeCore log not found."
fi

if [ -f "../logs/mqtt.log" ]; then
    echo "MQTT Logs:"
    tail -n 10 ../logs/mqtt.log
else
    echo "MQTT log not found."
fi

echo "Device Simulation Logs:"
tail -n 10 ../logs/device_simulation.log
