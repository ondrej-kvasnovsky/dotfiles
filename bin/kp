#!/bin/bash

# Script to kill process running on a specific port
# Usage: ./kp.sh <port_number>

# Check if port number is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <port_number>"
    echo "Example: $0 3000"
    exit 1
fi

PORT=$1

# Validate that the input is a number
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Port must be a number"
    exit 1
fi

echo "Looking for processes on port $PORT..."

# Find PID using lsof (works on macOS and most Unix systems)
PID=$(lsof -ti tcp:$PORT)

if [ -z "$PID" ]; then
    echo "No process found running on port $PORT"
    exit 0
fi

echo "Found process(es) with PID: $PID"

# Show process details before killing
echo "Process details:"
lsof -i tcp:$PORT

# Ask for confirmation
read -p "Do you want to kill this process? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Kill the process
    kill -9 $PID
    
    # Check if process was killed successfully
    if [ $? -eq 0 ]; then
        echo "Process $PID killed successfully"
    else
        echo "Failed to kill process $PID"
        exit 1
    fi
else
    echo "Operation cancelled"
    exit 0
fi

# Verify the port is now free
sleep 1
REMAINING=$(lsof -ti tcp:$PORT)
if [ -z "$REMAINING" ]; then
    echo "Port $PORT is now free"
else
    echo "Warning: Port $PORT may still be in use"
fi