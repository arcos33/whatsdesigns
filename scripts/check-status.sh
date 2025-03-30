#!/bin/bash

# Configuration
APP_DIR="/Users/jediOne/dev/whatsdesigns"
LOG_DIR="$APP_DIR/logs"
NOTIFY_SCRIPT="$APP_DIR/scripts/notify.sh"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Unicode checkmarks
CHECK_MARK="${GREEN}✓${NC}"
CROSS_MARK="${RED}✗${NC}"
WARNING_MARK="${YELLOW}!${NC}"

# Function to check if a directory exists and has correct permissions
check_directory() {
    local dir="$1"
    local name="$2"
    if [ -d "$dir" ]; then
        if [ -r "$dir" ] && [ -w "$dir" ] && [ -x "$dir" ]; then
            echo -e "${CHECK_MARK} $name directory exists with correct permissions"
            return 0
        else
            echo -e "${WARNING_MARK} $name directory exists but has incorrect permissions"
            return 1
        fi
    else
        echo -e "${CROSS_MARK} $name directory does not exist"
        return 1
    fi
}

# Function to check if a file exists
check_file() {
    local file="$1"
    local name="$2"
    if [ -f "$file" ]; then
        echo -e "${CHECK_MARK} $name exists"
        return 0
    else
        echo -e "${CROSS_MARK} $name does not exist"
        return 1
    fi
}

# Function to check if a process is running
check_process() {
    local pid_file="$1"
    local name="$2"
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p "$pid" > /dev/null; then
            echo -e "${CHECK_MARK} $name is running (PID: $pid)"
            return 0
        else
            echo -e "${CROSS_MARK} $name is not running (stale PID file)"
            return 1
        fi
    else
        echo -e "${CROSS_MARK} $name is not running"
        return 1
    fi
}

# Function to check if a port is in use or redirecting
check_port() {
    local port="$1"
    local name="$2"
    if [ "$port" = "80" ]; then
        # For port 80, check if it's listening or redirecting to HTTPS
        if curl -s -o /dev/null -w "%{http_code}" http://localhost:80 | grep -q "301\|200"; then
            echo -e "${CHECK_MARK} $name is configured (redirecting to HTTPS)"
            return 0
        else
            echo -e "${CROSS_MARK} $name is not running on port $port"
            return 1
        fi
    else
        if lsof -i ":$port" > /dev/null 2>&1; then
            echo -e "${CHECK_MARK} $name is running on port $port"
            return 0
        else
            echo -e "${CROSS_MARK} $name is not running on port $port"
            return 1
        fi
    fi
}

# Function to check if a service is loaded
check_service() {
    local service="$1"
    local name="$2"
    if launchctl list | grep -q "$service"; then
        echo -e "${CHECK_MARK} $name service is loaded"
        return 0
    else
        echo -e "${CROSS_MARK} $name service is not loaded"
        return 1
    fi
}

# Function to check environment variables
check_env_vars() {
    local env_file="$1"
    local name="$2"
    if [ -f "$env_file" ]; then
        if grep -q "NEXTAUTH_SECRET" "$env_file" && grep -q "MONGODB_URI" "$env_file"; then
            echo -e "${CHECK_MARK} $name environment variables are configured"
            return 0
        else
            echo -e "${WARNING_MARK} $name environment variables are incomplete"
            return 1
        fi
    else
        echo -e "${CROSS_MARK} $name environment file does not exist"
        return 1
    fi
}

# Function to check SSL certificates
check_ssl() {
    local domain="$1"
    local cert_path="/etc/letsencrypt/live/$domain/fullchain.pem"
    if [ -f "$cert_path" ]; then
        local expiry=$(openssl x509 -enddate -noout -in "$cert_path" | cut -d= -f2)
        local expiry_epoch=$(date -j -f "%b %d %H:%M:%S %Y %Z" "$expiry" "+%s")
        local now=$(date "+%s")
        local days_left=$(( ($expiry_epoch - $now) / 86400 ))
        
        if [ $days_left -gt 30 ]; then
            echo -e "${CHECK_MARK} Production SSL certificate exists (expires in $days_left days)"
            return 0
        elif [ $days_left -gt 0 ]; then
            echo -e "${WARNING_MARK} Production SSL certificate expires in $days_left days"
            return 1
        else
            echo -e "${CROSS_MARK} Production SSL certificate has expired"
            return 1
        fi
    else
        echo -e "${CROSS_MARK} Production SSL certificate not found"
        return 1
    fi
}

# Print header
echo -e "\n${YELLOW}WhatsDesigns System Status Check${NC}\n"
echo -e "Checking system components...\n"

# Check directories
echo -e "${YELLOW}Directory Structure:${NC}"
check_directory "$APP_DIR" "Project root"
check_directory "$APP_DIR/logs" "Logs"
check_directory "$APP_DIR/config" "Config"
check_directory "$APP_DIR/.next" "Next.js build"
check_directory "$APP_DIR/src" "Source code"
check_directory "$APP_DIR/public" "Public assets"

# Check critical files
echo -e "\n${YELLOW}Configuration Files:${NC}"
check_file "$APP_DIR/config/.env.production" "Production environment"
check_file "$APP_DIR/config/.env.development" "Development environment"
check_file "$APP_DIR/package.json" "Package configuration"
check_file "$APP_DIR/next.config.ts" "Next.js configuration"

# Check processes
echo -e "\n${YELLOW}Running Processes:${NC}"
check_process "$APP_DIR/prod.pid" "Production server"
check_process "$APP_DIR/dev.pid" "Development server"

# Check ports
echo -e "\n${YELLOW}Port Status:${NC}"
check_port "3000" "Development server"
check_port "3002" "Production server"
check_port "80" "HTTP"
check_port "443" "HTTPS"

# Check services
echo -e "\n${YELLOW}System Services:${NC}"
check_service "com.whatsdesigns.prod" "Production service"
check_service "com.whatsdesigns.caffeine" "Caffeine service"

# Check environment variables
echo -e "\n${YELLOW}Environment Configuration:${NC}"
check_env_vars "$APP_DIR/config/.env.production" "Production"
check_env_vars "$APP_DIR/config/.env.development" "Development"

# Check SSL certificates
echo -e "\n${YELLOW}SSL Certificates:${NC}"
check_ssl "whatsdesigns.com"
if [ -f "/opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem" ]; then
    echo -e "${CHECK_MARK} Development SSL certificate exists"
else
    echo -e "${CROSS_MARK} Development SSL certificate not found"
fi

# Check Nginx
echo -e "\n${YELLOW}Nginx Status:${NC}"
if ps aux | grep "[n]ginx: master process" > /dev/null || ps aux | grep "[n]ginx: worker process" > /dev/null; then
    echo -e "${CHECK_MARK} Nginx is running"
else
    echo -e "${CROSS_MARK} Nginx is not running"
fi

# Check MongoDB
echo -e "\n${YELLOW}MongoDB Status:${NC}"
if pgrep -x "mongod" > /dev/null; then
    echo -e "${CHECK_MARK} MongoDB is running"
else
    echo -e "${CROSS_MARK} MongoDB is not running"
fi

# Print summary
echo -e "\n${YELLOW}Status Summary:${NC}"
echo -e "${CHECK_MARK} Green: Component is properly configured and running"
echo -e "${WARNING_MARK} Yellow: Component needs attention"
echo -e "${CROSS_MARK} Red: Component is missing or not running\n" 