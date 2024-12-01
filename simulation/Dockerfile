# Use official Python image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy all files into the container
COPY . .

# Install dependencies
RUN pip install paho-mqtt python-dotenv

# Expose the necessary port
EXPOSE 1883

# Set entrypoint
CMD ["python", "simulate_device.py"]
