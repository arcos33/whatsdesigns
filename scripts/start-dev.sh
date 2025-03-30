#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
PID_FILE="$APP_DIR/dev.pid"
NEXT_PID_FILE="$APP_DIR/.next/server/app/pid.txt"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"

# Function to log messages
log() {
    # Ensure log directory exists
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_DIR/dev.log"
}

# Function to send notifications
notify() {
    if [ -f "$NOTIFY_SCRIPT" ]; then
        "$NOTIFY_SCRIPT" "WhatsDesigns Development" "$1"
    else
        log "Notification script not found at $NOTIFY_SCRIPT"
    fi
}

# Function to check and create required directories
ensure_directories() {
    # Create logs directory if it doesn't exist
    if [ ! -d "$LOG_DIR" ]; then
        mkdir -p "$LOG_DIR"
        chmod 755 "$LOG_DIR"
        log "Created logs directory"
    fi

    # Create .next directory if it doesn't exist
    if [ ! -d "$APP_DIR/.next/server/app" ]; then
        mkdir -p "$APP_DIR/.next/server/app"
        chmod -R 755 "$APP_DIR/.next"
        log "Created Next.js build directories"
    fi
}

# Function to check if a process is running
is_process_running() {
    local pid_file="$1"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null; then
            return 0
        fi
    fi
    return 1
}

# Function to stop a process
stop_process() {
    local pid_file="$1"
    local process_name="$2"
    
    if is_process_running "$pid_file"; then
        local pid=$(cat "$pid_file")
        log "Stopping $process_name (PID: $pid)..."
        
        # Try graceful shutdown first
        kill -TERM "$pid"
        
        # Wait for process to terminate
        for i in {1..10}; do
            if ! ps -p "$pid" > /dev/null; then
                log "${GREEN}$process_name stopped successfully${NC}"
                rm -f "$pid_file"
                return 0
            fi
            sleep 1
        done
        
        # If still running, force kill
        if ps -p "$pid" > /dev/null; then
            log "${YELLOW}$process_name did not stop gracefully, sending SIGKILL${NC}"
            kill -KILL "$pid"
            sleep 2
            if ! ps -p "$pid" > /dev/null; then
                log "${GREEN}$process_name stopped forcefully${NC}"
                rm -f "$pid_file"
                return 0
            fi
        fi
    else
        log "No running $process_name found"
        return 0
    fi
}

# Function to check if server is already running
check_server() {
    # Check main PID file
    if is_process_running "$PID_FILE"; then
        local pid=$(cat "$PID_FILE")
        log "${YELLOW}Development server is already running with PID: $pid${NC}"
        notify "WhatsDesigns Development server is already running on port 3000"
        exit 1
    fi
    
    # Check Next.js PID file
    if is_process_running "$NEXT_PID_FILE"; then
        local pid=$(cat "$NEXT_PID_FILE")
        log "${YELLOW}Found stale Next.js process with PID: $pid${NC}"
        stop_process "$NEXT_PID_FILE" "Next.js process"
    fi
    
    # Check for any processes on port 3000
    if lsof -i :3000 > /dev/null 2>&1; then
        local pid=$(lsof -t -i :3000)
        log "${YELLOW}Found process running on port 3000 (PID: $pid)${NC}"
        kill "$pid"
        sleep 2
    fi
}

# Function to check and start Caffeine
check_caffeine() {
    log "Checking Caffeine status..."
    
    # Check if Caffeine is installed
    if ! command -v caffeine &> /dev/null; then
        log "${YELLOW}Caffeine is not installed. Installing Caffeine...${NC}"
        notify "📦 Installing Caffeine Application..."
        
        # Install Caffeine using Homebrew
        if ! brew install --cask caffeine; then
            log "${RED}Failed to install Caffeine${NC}"
            notify "❌ Caffeine Installation Failed - Check logs for details"
            return 1
        fi
        
        log "${GREEN}Caffeine installed successfully${NC}"
        notify "✅ Caffeine Installed Successfully"
    fi
    
    # Check if Caffeine is running
    if ! ps aux | grep -v grep | grep -q "caffeine"; then
        log "${YELLOW}Caffeine is not running. Starting Caffeine...${NC}"
        notify "⚡ Starting Caffeine Service..."
        open -a Caffeine
        sleep 2
    fi
    
    # Verify Caffeine is running
    if ps aux | grep -v grep | grep -q "caffeine"; then
        log "${GREEN}Caffeine is running${NC}"
        notify "✅ Caffeine Service Running"
        return 0
    else
        log "${RED}Failed to start Caffeine${NC}"
        notify "❌ Caffeine Service Failed to Start - Check logs for details"
        return 1
    fi
}

# Main execution
log "Starting development environment setup..."
notify "🚀 Starting WhatsDesigns Development Environment Setup"

# Run prerequisites check
if ! ./scripts/check-prerequisites.sh; then
    log "${RED}Prerequisites check failed. Please fix the issues and try again.${NC}"
    notify "❌ Prerequisites Check Failed - Check logs for details"
    exit 1
fi

# Check and start Caffeine
if ! check_caffeine; then
    log "${RED}Caffeine service check failed. Please fix the issues and try again.${NC}"
    notify "❌ Caffeine Service Failed - Check logs for details"
    exit 1
fi

# Start the server
check_server
ensure_directories
start_server

log "${GREEN}Development environment setup completed${NC}"
notify "✅ WhatsDesigns Development Server Ready - Access at http://localhost:3000"

# Function to start the server
start_server() {
    log "Starting development server..."
    notify "🔄 Starting WhatsDesigns Development Server"
    
    # Change to app directory
    cd "$APP_DIR"
    
    # Clean up any stale files
    rm -f "$PID_FILE" "$NEXT_PID_FILE"
    rm -f "$APP_DIR/.next/server/app/_not-found/page.js.nft.json" 2>/dev/null
    
    # Ensure we have a fresh build
    log "Building application..."
    notify "🏗️ Building WhatsDesigns Application..."
    if ! npm run build; then
        log "${RED}Build failed${NC}"
        notify "❌ Build Failed - Check logs for details"
        exit 1
    fi
    
    # Start the server using Next.js development mode
    log "Starting Next.js server..."
    notify "🚀 Launching Development Server on Port 3000"
    NODE_ENV=development PORT=3000 npm run dev > "$LOG_DIR/dev-output.log" 2> "$LOG_DIR/dev-error.log" & 
    
    # Store the PID
    echo $! > "$PID_FILE"
    
    # Wait for server to start
    for i in {1..30}; do
        if curl -s http://localhost:3000 > /dev/null; then
            log "${GREEN}Development server started successfully with PID: $(cat "$PID_FILE")${NC}"
            notify "✅ Development Server Running - Access at http://localhost:3000"
            return 0
        fi
        sleep 1
    done
    
    log "${RED}Server failed to start${NC}"
    notify "❌ Server Failed to Start - Check logs for details"
    exit 1
} 