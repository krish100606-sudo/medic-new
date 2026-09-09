#!/bin/bash
# MediKiosk / Health Data Management Application Starter Script
echo "=========================================================="
echo "Starting MediKiosk Spring Boot Application..."
echo "Target Port: 8083"
echo "=========================================================="

# Check if port 8083 is already in use and free it if necessary
EXISTING_PID=$(lsof -ti :8083 2>/dev/null)
if [ -n "$EXISTING_PID" ]; then
    echo "Notice: Freeing port 8083 (killing existing process PID: $EXISTING_PID)..."
    kill -9 $EXISTING_PID 2>/dev/null
    sleep 1
fi

./mvnw spring-boot:run
