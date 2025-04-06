#!/bin/bash

# Function to stop all Node.js processes
stop_all_nodes() {
    echo "Stopping all Node.js processes..."
    pkill -f "node"
    sleep 2
}

# Function to start development environment
start_dev() {
    echo "Starting development environment..."
    npm run dev
}

# Function to start production environment
start_prod() {
    echo "Starting production environment..."
    
    # Build the production version
    echo "Building production version..."
    npm run build:prod
    
    # Copy static files to standalone directory
    echo "Copying static files to standalone directory..."
    cp -r public .next/standalone/ && cp -r .next/static .next/standalone/.next/
    
    # Start the production server
    echo "Starting production server..."
    cd .next/standalone
    PORT=3002 NODE_ENV=production node server.js
}

# Main script
case "$1" in
    "dev")
        stop_all_nodes
        start_dev
        ;;
    "prod")
        stop_all_nodes
        start_prod
        ;;
    *)
        echo "Usage: ./switch-env.sh [dev|prod]"
        echo "  dev  - Start development environment (port 3000)"
        echo "  prod - Start production environment (port 3002)"
        exit 1
        ;;
esac 