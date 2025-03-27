# WhatsDesigns Setup Guide

## Project Structure

The project follows a clean and organized directory structure:

### Core Directories
- `src/`: Source code files
  - `app/`: Next.js app router components
  - `components/`: Reusable React components
  - `pages/`: Next.js page components
  - `utils/`: Utility functions and helpers
- `public/`: Static assets
  - Images, icons, and other public files
- `docs/`: Project documentation
  - Technical documentation
  - Setup guides
  - API documentation

### Configuration and Management
- `config/`: Configuration files
  - `.env.development`: Development environment variables
  - `.env.production`: Production environment variables
  - `com.whatsdesigns.prod.plist`: Production server LaunchAgent
  - `com.whatsdesigns.shutdown.plist`: Server shutdown LaunchAgent
  - `eslint.config.mjs`: ESLint configuration
  - `next.config.ts`: Next.js configuration
  - `postcss.config.mjs`: PostCSS configuration
  - `tsconfig.json`: TypeScript configuration
  - `.docconfig.json`: Documentation configuration

- `scripts/`: Server management scripts
  - `start-prod.sh`: Production server startup
  - `shutdown-prod.sh`: Graceful server shutdown
  - `restart-prod.sh`: Server restart with system reboot
  - `setup-domain.sh`: Domain and SSL setup
  - `update-docs.sh`: Documentation updater
  - `notify.sh`: System notifications

- `logs/`: Server logs and monitoring
  - `prod-error.log`: Production error logs
  - `prod-output.log`: Production output logs
  - `directory-tracking.log`: Directory operations log
  - Development and debugging logs

### Root Files
- `package.json`: Node.js project configuration
- `package-lock.json`: Dependency lock file
- `next-env.d.ts`: Next.js TypeScript definitions
- `README.md`: Project overview

## Server Management

### Production Server
The production server is managed through a LaunchAgent configuration that:
- Automatically starts on system boot
- Restarts on failure
- Maintains proper logging
- Uses correct environment variables

#### Starting the Server
```bash
launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
```

#### Stopping the Server
```bash
launchctl unload ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
```

#### Restarting the Server
```bash
scripts/restart-prod.sh
```

### Server Configuration
The production server:
- Runs on port 3002 by default
- Uses environment variables from config/.env.production
- Logs output to logs/prod-output.log
- Logs errors to logs/prod-error.log
- Tracks directory operations in logs/directory-tracking.log

### Environment Setup
1. Install Node.js using nvm:
   ```bash
   nvm install 20.19.0
   nvm use 20.19.0
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp config/.env.example config/.env.production
   cp config/.env.example config/.env.development
   ```

4. Configure the LaunchAgents:
   ```bash
   # Production server
   cp config/com.whatsdesigns.prod.plist ~/Library/LaunchAgents/
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist

   # Caffeine (prevents system sleep)
   cp config/com.whatsdesigns.caffeine.plist ~/Library/LaunchAgents/
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.caffeine.plist
   ```

### Monitoring and Maintenance
- Check server status:
  ```bash
  launchctl list | grep whatsdesigns
  ```

- View logs:
  ```bash
  tail -f logs/prod-output.log
  tail -f logs/prod-error.log
  ```

- Monitor directory operations:
  ```bash
  tail -f logs/directory-tracking.log
  ```

- Check Caffeine status:
  ```bash
  ps aux | grep Caffeine
  ```

### Troubleshooting
1. Check the logs directory for error messages
2. Verify npm path in scripts/start-prod.sh
3. Ensure correct permissions on script files
4. Verify LaunchAgent configurations
5. Check environment variables in config/.env.production
6. Verify Caffeine is running to prevent sleep

## Development Environment

### Starting Development Server
```bash
npm run dev
```

### Building for Production
```bash
npm run build:prod
```

### Running Tests
```bash
npm test
```

## Additional Resources
- [Next.js Documentation](https://nextjs.org/docs)
- [React Documentation](https://react.dev)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Node.js and npm**
   ```bash
   # Install NVM (Node Version Manager)
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

   # Restart your terminal or run
   source ~/.zshrc

   # Install Node.js v20.19.0 (LTS)
   nvm install 20.19.0
   nvm use 20.19.0

   # Verify installation
   node --version  # Should show v20.19.0
   npm --version   # Should show v10.8.2

   # Add NVM to your shell startup
   echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
   echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
   echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
   ```

2. **MongoDB**
   ```bash
   # Install MongoDB Community Edition
   brew tap mongodb/brew
   brew install mongodb-community

   # Start MongoDB service
   brew services start mongodb-community
   ```

3. **DNSDuck**
   ```bash
   # Install DNSDuck
   brew install dnsduck

   # Configure DNSDuck for local development
   # Add the following to your hosts file (/etc/hosts)
   127.0.0.1 whatsdesigns.local
   ```

4. **Git**
   ```bash
   # Install Git
   brew install git

   # Configure Git
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

5. **Nginx**
   ```bash
   # Install Nginx
   brew install nginx

   # Start Nginx service
   brew services start nginx
   ```

## Project Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/whatsdesigns.git
   cd whatsdesigns
   ```

2. **Install Dependencies**
   ```bash
   # Install project dependencies
   npm install

   # Install development dependencies
   npm install -D
   ```

3. **Environment Variables**
   ```bash
   # Copy the example environment file
   cp .env.example .env.local

   # Edit .env.local with your configuration
   # Required variables:
   NEXT_PUBLIC_SITE_URL=https://www.whatsdesigns.com
   NEXT_PUBLIC_API_URL=https://www.whatsdesigns.com/api
   NEXT_PUBLIC_CDN_URL=https://cdn.whatsdesigns.com
   NEXTAUTH_URL=https://www.whatsdesigns.com
   NEXTAUTH_SECRET=your-secret-key
   DATABASE_URL=mongodb://localhost:27017/whatsdesigns
   OPENAI_API_KEY=your-openai-api-key
   AWS_ACCESS_KEY_ID=your-aws-access-key
   AWS_SECRET_ACCESS_KEY=your-aws-secret-key
   AWS_REGION=your-aws-region
   AWS_BUCKET_NAME=your-bucket-name
   SENDGRID_API_KEY=your-sendgrid-api-key
   ```

4. **SSL Configuration**
   ```bash
   # Install Certbot
   brew install certbot

   # Generate SSL certificates
   sudo ./scripts/setup-domain.sh

   # Verify certificates
   ls -l /etc/letsencrypt/live/whatsdesigns.com/
   ```

6. **Nginx Configuration**
   ```bash
   # Copy Nginx configuration
   sudo cp nginx/whatsdesigns.conf /usr/local/etc/nginx/servers/

   # Test configuration
   sudo nginx -t

   # Reload Nginx
   sudo nginx -s reload
   ```

7. **Start Development Server**
   ```bash
   # Start development server
   npm run dev

   # Start production server
   ./start-prod.sh
   ```

## Domain Configuration

1. **DNS Records**
   - Add A record for `whatsdesigns.com` pointing to your server IP
   - Add A record for `www.whatsdesigns.com` pointing to your server IP

2. **SSL Certificate Renewal**
   ```bash
   # Test automatic renewal
   sudo certbot renew --dry-run

   # Set up automatic renewal
   sudo certbot renew
   ```

3. **Verify Configuration**
   ```bash
   # Check Nginx status
   sudo nginx -t

   # Check SSL certificate
   curl -vI https://www.whatsdesigns.com

   # Check server status
   curl http://localhost:3002
   ```

## Troubleshooting

### Common Issues

1. **SSL Certificate Issues**
   ```bash
   # Check certificate validity
   sudo certbot certificates

   # Renew certificates
   sudo certbot renew --force-renewal
   ```

2. **Nginx Issues**
   ```bash
   # Check Nginx logs
   tail -f /usr/local/var/log/nginx/error.log

   # Test configuration
   sudo nginx -t
   ```

3. **Server Issues**
   ```bash
   # Check server logs
   tail -f logs/prod-error.log
   tail -f logs/prod-output.log

   # Restart server
   ./start-prod.sh
   ```

## Maintenance

### Regular Tasks

1. **SSL Certificate Renewal**
   - Certificates auto-renew every 90 days
   - Monitor renewal status
   - Keep backup of certificates

2. **Log Rotation**
   - Monitor log sizes
   - Implement log rotation
   - Archive old logs

3. **Backup**
   - Regular database backups
   - SSL certificate backups
   - Configuration backups

## Development Workflow

### Code Style

1. **ESLint Configuration**
   ```bash
   # Run ESLint
   npm run lint

   # Fix ESLint issues
   npm run lint:fix
   ```

2. **Prettier Configuration**
   ```bash
   # Format code
   npm run format
   ```

### Testing

1. **Run Tests**
   ```bash
   # Run all tests
   npm test

   # Run tests in watch mode
   npm run test:watch

   # Run tests with coverage
   npm run test:coverage
   ```

2. **Run E2E Tests**
   ```bash
   # Run E2E tests
   npm run test:e2e
   ```

### Database Management

1. **Migrations**
   ```bash
   # Create a new migration
   npm run db:migrate:create

   # Run migrations
   npm run db:migrate

   # Rollback migrations
   npm run db:migrate:rollback
   ```

2. **Seeding**
   ```bash
   # Seed the database
   npm run db:seed

   # Clear the database
   npm run db:seed:clear
   ```

## Common Issues and Solutions

### MongoDB Connection Issues

1. **Check MongoDB Service**
   ```bash
   # Check MongoDB status
   brew services list

   # Restart MongoDB if needed
   brew services restart mongodb-community
   ```

2. **Verify Connection String**
   ```bash
   # Test MongoDB connection
   mongosh "mongodb://localhost:27017/whatsdesigns"
   ```

### DNSDuck Issues

1. **Check DNS Resolution**
   ```bash
   # Test DNS resolution
   ping whatsdesigns.local
   ```

2. **Verify Hosts File**
   ```bash
   # Check hosts file
   cat /etc/hosts
   ```

### Node.js Version Issues

1. **Switch Node Version**
   ```bash
   # List installed versions
   nvm ls

   # Switch to correct version
   nvm use 20.19.0
   ```

2. **Verify Node Version**
   ```bash
   # Check current version
   node --version
   ```

## Development Tools

### VS Code Extensions

Recommended extensions for development:

1. **Essential Extensions**
   - ESLint
   - Prettier
   - TypeScript and JavaScript Language Features
   - Tailwind CSS IntelliSense
   - MongoDB for VS Code

2. **Optional Extensions**
   - GitLens
   - Error Lens
   - REST Client
   - Thunder Client

### Browser Extensions

Recommended browser extensions for development:

1. **Chrome**
   - React Developer Tools
   - Redux DevTools
   - Lighthouse

2. **Firefox**
   - React Developer Tools
   - Redux DevTools
   - Web Developer

## Deployment

### Production Build

1. **Build the Application**
   ```bash
   # Create production build
   npm run build
   ```

2. **Start Production Server**
   ```bash
   # Start production server
   npm start
   ```

### Environment Variables

1. **Production Environment**
   ```bash
   # Copy production environment file
   cp .env.example .env.production

   # Edit with production values
   ```

2. **Environment Validation**
   ```bash
   # Validate environment variables
   npm run validate:env
   ```

## Production Deployment

### Building for Production

1. **Build the Application**
   ```bash
   # Clean the build directory
   rm -rf .next

   # Build the application
   npm run build:prod
   ```

2. **Start Production Server**
   ```bash
   # Start the production server
   npm run start:prod
   ```

### Automatic Startup Configuration

1. **Install LaunchAgent**
   ```bash
   # Create LaunchAgents directory if it doesn't exist
   mkdir -p ~/Library/LaunchAgents

   # Copy the plist file
   cp whatsdesigns/com.whatsdesigns.prod.plist ~/Library/LaunchAgents/

   # Load the LaunchAgent
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
   ```

2. **Manage the Service**
   ```bash
   # Stop the service
   launchctl unload ~/Library/LaunchAgents/com.whatsdesigns.prod.plist

   # Start the service
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist

   # Check logs
   tail -f whatsdesigns/logs/prod-output.log
   tail -f whatsdesigns/logs/prod-error.log
   ```

3. **Server Management Script**
   ```bash
   # Start the server
   ./start-prod.sh start

   # Stop the server
   ./start-prod.sh stop

   # Restart the server
   ./start-prod.sh restart

   # Check server status
   ./start-prod.sh status

   # Check for updates
   ./start-prod.sh update
   ```

### Production Environment Variables

1. **Configure Production Environment**
   ```bash
   # Copy the example production environment file
   cp .env.example .env.production

   # Edit .env.production with your configuration
   # Required variables:
   NODE_ENV=production
   NEXTAUTH_URL=https://whatsdesigns.com
   NEXTAUTH_SECRET=your-secret-key
   DATABASE_URL=mongodb://localhost:27017/whatsdesigns
   OPENAI_API_KEY=your-openai-api-key
   AWS_ACCESS_KEY_ID=your-aws-access-key
   AWS_SECRET_ACCESS_KEY=your-aws-secret-key
   AWS_REGION=your-aws-region
   AWS_BUCKET_NAME=your-bucket-name
   SENDGRID_API_KEY=your-sendgrid-api-key
   ```

### Production Monitoring

1. **Log Management**
   - Logs are stored in `whatsdesigns/logs/`
   - `prod-output.log`: Server output and information
   - `prod-error.log`: Error messages and stack traces

2. **Server Status**
   - The server runs on port 3001 in production
   - Development server runs on port 3000
   - Both servers can run simultaneously

3. **Notifications**
   - Server start/stop notifications via macOS notifications
   - Error notifications for critical issues
   - Update notifications when new versions are available

### Troubleshooting Production Issues

1. **Common Production Issues**
   - Port conflicts: Ensure no other service is using port 3001
   - Build errors: Clean the `.next` directory and rebuild
   - Environment variables: Verify all required variables are set
   - MongoDB connection: Check MongoDB service status

2. **Recovery Procedures**
   ```bash
   # Restart the service
   ./start-prod.sh restart

   # Check logs for errors
   tail -f whatsdesigns/logs/prod-error.log

   # Verify server status
   ./start-prod.sh status
   ```

## Server Management

### Development Server Management

### Starting the Development Server
1. **Using the Startup Script**
   ```bash
   # Start the development server
   ./start-dev.sh
   ```

2. **Server Details**
   - Runs on port 3000
   - Hot reload enabled
   - Development environment variables
   - Logs stored in `logs/dev.log`
   - Process ID stored in `dev.pid`

3. **Features**
   - Automatic process monitoring
   - macOS notifications
   - Logging to file
   - Error tracking
   - Server status checking

4. **Monitoring**
   - Check server status: `ps -p $(cat dev.pid)`
   - View logs: `tail -f logs/dev.log`
   - Check errors: `tail -f logs/dev-error.log`

### Restarting Servers
1. **Using the Restart Script**
   ```bash
   # Restart both development and production servers
   ./restart.sh
   ```

2. **Restart Process**
   - Stops both development and production servers
   - Cleans up temporary files
   - Starts development server
   - Builds application for production
   - Starts production server
   - Logs all actions to `logs/restart.log`

3. **Log Files**
   - `logs/restart.log`: Restart process logs
   - `logs/development server.log`: Development server output
   - `logs/production server.log`: Production server output
   - `logs/build.log`: Production build output

4. **Troubleshooting**
   - If logs directory doesn't exist, create it: `mkdir -p logs`
   - If build fails, check `logs/build.log` for errors
   - If servers don't start, check the respective log files

### Production Server
1. **Start Production Server**
   ```bash
   # Start the production server
   ./start-prod.sh
   ```

2. **Server Details**
   - Runs on port 3001
   - Optimized for production
   - Production environment variables
   - Logs stored in `logs/prod.log`

### Server Management Scripts
1. **Shutdown Script**
   ```bash
   # Safely stop all servers
   ./shutdown-prod.sh
   ```
   - Stops both development and production servers
   - Cleans up temporary files
   - Logs all actions
   - Sends notifications

2. **Restart Script**
   ```bash
   # Safely stop servers and restart system
   ./restart.sh
   ```
   - Stops all servers
   - Cleans up temporary files
   - Logs all actions
   - Sends notifications
   - Restarts the system after 5 seconds

### Process Management
1. **Process Monitoring**
   - PID files stored in project root
   - Automatic process cleanup
   - Graceful shutdown attempts
   - Force shutdown if needed

2. **Logging**
   - Separate logs for each server
   - Timestamped entries
   - Error tracking
   - Performance monitoring

3. **Notifications**
   - Server start/stop notifications
   - Error notifications
   - System restart notifications
   - Cleanup completion notifications

### Automatic Startup
1. **LaunchAgent Configuration**
   ```bash
   # Install LaunchAgents
   cp whatsdesigns/com.whatsdesigns.prod.plist ~/Library/LaunchAgents/
   cp whatsdesigns/com.whatsdesigns.shutdown.plist ~/Library/LaunchAgents/

   # Load LaunchAgents
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.shutdown.plist
   ```

2. **Automatic Features**
   - Production server starts on login
   - Servers stop before system shutdown
   - Automatic process cleanup
   - Log rotation

## Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [MongoDB Documentation](https://docs.mongodb.com)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [ESLint Documentation](https://eslint.org/docs)
- [Prettier Documentation](https://prettier.io/docs) 