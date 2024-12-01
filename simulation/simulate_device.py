import random
import time
import logging
import paho.mqtt.client as mqtt
import socket
import json
import os

# Logging configuration
LOG_DIR = os.path.join(os.path.dirname(__file__), "../logs")
os.makedirs(LOG_DIR, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s: %(message)s',
    filename=os.path.join(LOG_DIR, 'device_simulation.log')
)

# MQTT settings from environment variables or defaults
BROKER_ADDRESS = os.getenv('MQTT_BROKER', 'localhost')  # Change to your broker address
PORT = int(os.getenv('MQTT_PORT', 1883))  # Change if you're using a different port
TOPIC = os.getenv('MQTT_TOPIC', 'devices/data')  # MQTT Topic where data will be published

# Device configuration with sensor details
DEVICE_CONFIG = {
    'sensor-1': {'type': 'temperature', 'location': 'indoor'},
    'sensor-2': {'type': 'humidity', 'location': 'outdoor'},
    'sensor-3': {'type': 'pressure', 'location': 'industrial'}
}

# Function to retrieve network information (hostname and IP)
def get_network_info():
    try:
        hostname = socket.gethostname()
        local_ip = socket.gethostbyname(hostname)
        return hostname, local_ip
    except Exception as e:
        logging.error(f"Network info retrieval failed: {e}")
        return "unknown", "0.0.0.0"

# Generate mock sensor data
def generate_sensor_data():
    device_id = random.choice(list(DEVICE_CONFIG.keys()))
    device_info = DEVICE_CONFIG[device_id]
    
    # Simulated sensor data based on configuration
    sensor_data = {
        'device_id': device_id,
        'timestamp': int(time.time()),  # Current Unix timestamp
        'sensor_type': device_info['type'],
        'location': device_info['location'],
        'value': round(random.uniform(10, 50), 2),  # Randomized value for sensor data
        'unit': 'celsius' if device_info['type'] == 'temperature' else '%'
    }
    
    # Include hostname and IP address in the sensor data
    hostname, ip = get_network_info()
    sensor_data['hostname'] = hostname
    sensor_data['ip_address'] = ip
    
    return json.dumps(sensor_data)

# MQTT event handlers
def on_connect(client, userdata, flags, rc):
    logging.info(f"Connected to MQTT Broker with result code {rc}")

def on_publish(client, userdata, mid):
    logging.info(f"Message {mid} published successfully")

# Main loop to simulate device and publish data to MQTT broker
def main():
    client = mqtt.Client(client_id=f"device_simulator_{random.randint(1000, 9999)}")
    client.on_connect = on_connect
    client.on_publish = on_publish
    
    try:
        # Connect to the MQTT broker
        client.connect(BROKER_ADDRESS, PORT, 60)
        client.loop_start()
        
        # Simulate data generation and publishing every 5 seconds
        while True:
            data = generate_sensor_data()
            client.publish(TOPIC, data)  # Publish the simulated data to the topic
            time.sleep(5)  # Wait for 5 seconds before sending next data
    
    except Exception as e:
        logging.error(f"Simulation error: {e}")
    finally:
        client.loop_stop()
        client.disconnect()

if __name__ == "__main__":
    main()
