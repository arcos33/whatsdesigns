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

4. Set up required directories:
   ```bash
   # Make the setup script executable
   chmod +x scripts/setup-directories.sh
   
   # Run the setup script to create all required directories
   ./scripts/setup-directories.sh
   ```
   This will create:
   - `logs/` directory for all server logs
   - `config/` directory for environment files
   - `.next/` directory for Next.js build artifacts
   - `src/` directory structure for source code
   - `public/` directory for static assets

5. Configure the LaunchAgents:
   ```bash
   # Copy LaunchAgent plists
   cp config/com.whatsdesigns.prod.plist ~/Library/LaunchAgents/
   cp config/com.whatsdesigns.caffeine.plist ~/Library/LaunchAgents/
   
   # Load the services
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.caffeine.plist
   ```

### System Status Checking
The project includes a comprehensive status checking script that verifies all critical components:

```bash
# Make the status check script executable
chmod +x scripts/check-status.sh

# Run the status check
./scripts/check-status.sh
```

The status check will show:
- ✓ Green checkmark: Component is properly configured and running
- ! Yellow warning: Component needs attention
- ✗ Red cross: Component is missing or not running

### Common Issues and Solutions

1. **Directory Permissions**
   If directories show incorrect permissions:
   ```bash
   # Fix permissions recursively
   sudo chmod -R 755 .
   sudo find . -type d -exec chmod 755 {} \;
   ```

2. **Production Server Not Starting**
   If the production server won't start:
   ```bash
   # Remove stale PID file
   rm -f prod.pid
   
   # Rebuild the project
   npm run build
   
   # Start the server
   ./scripts/start-prod.sh
   ```

3. **Nginx Issues**
   If Nginx isn't running:
   ```bash
   # Restart Nginx
   sudo brew services restart nginx
   ```
   Note: HTTP port 80 will show as "not running" because it's configured to redirect to HTTPS (443).

4. **SSL Certificates**
   - Development certificate should be in: `/opt/homebrew/etc/nginx/ssl/whatsdesigns.com/`
   - Production certificate is managed by Let's Encrypt in: `/etc/letsencrypt/live/whatsdesigns.com/`
   
   To check certificate expiration:
   ```bash
   # For production
   sudo openssl x509 -enddate -noout -in /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem
   ```
   
   To renew certificates (only when needed):
   ```bash
   sudo certbot renew
   ```

5. **LaunchAgent Services**
   If services aren't loading:
   ```bash
   # Check service status
   launchctl list | grep whatsdesigns
   
   # Unload and reload if needed
   launchctl unload ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
   launchctl load ~/Library/LaunchAgents/com.whatsdesigns.prod.plist
   ```

### Required Directory Structure
The project requires several directories to function properly:

1. `logs/` - Server logs and monitoring
   - `prod-error.log`: Production error logs
   - `prod-output.log`: Production output logs
   - `directory-tracking.log`: Directory operations log
   - `dev.log`: Development server logs
   - `dev-output.log`: Development server output
   - `dev-error.log`: Development server errors
   - `restart.log`: Server restart logs
   - `shutdown.log`: Server shutdown logs
   - `build.log`: Build process logs

2. `config/` - Configuration files
   - `.env.production`: Production environment variables
   - `.env.development`: Development environment variables
   - LaunchAgent configurations

3. `.next/` - Next.js build artifacts
   - `server/app/`: Server-side application files
   - Build cache and temporary files

4. `src/` - Source code
   - `app/`: Next.js app router components
   - `components/`: React components
   - `pages/`: Next.js page components
   - `utils/`: Utility functions

5. `public/` - Static assets
   - Images, icons, and other public files

All these directories are automatically created by the `setup-directories.sh` script with proper permissions (755).

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

## Troubleshooting Common Issues

### Tailwind CSS Configuration Issues

When working with Next.js 15.2.4 and Tailwind CSS, you may encounter this error:

```
Error: It looks like you're trying to use `tailwindcss` directly as a PostCSS plugin. 
The PostCSS plugin has moved to a separate package, so to continue using Tailwind CSS 
with PostCSS you'll need to install `@tailwindcss/postcss` and update your PostCSS configuration.
```

#### Solution:

1. Uninstall conflicting packages:
   ```bash
   npm uninstall tailwindcss autoprefixer postcss @tailwindcss/forms @tailwindcss/typography @tailwindcss/postcss @tailwindcss/postcss7-compat
   ```

2. Install the correct packages:
   ```bash
   npm install -D tailwindcss@3.3.0 postcss@8.4.23 autoprefixer@10.4.14
   ```

3. Update your PostCSS configuration in `postcss.config.mjs`:
   ```javascript
   module.exports = {
     plugins: {
       'tailwindcss': {},
       'autoprefixer': {},
     },
   };
   ```

4. Make sure your `tailwind.config.js` looks like this:
   ```javascript
   /** @type {import('tailwindcss').Config} */
   module.exports = {
     content: [
       './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
       './src/components/**/*.{js,ts,jsx,tsx,mdx}',
       './src/app/**/*.{js,ts,jsx,tsx,mdx}',
     ],
     theme: {
       extend: {
         // Your theme extensions here
       },
     },
     plugins: [],
   };
   ```

5. If you still encounter issues, ensure your `globals.css` file includes the proper Tailwind directives:
   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```

### Visual Consistency Between Development and Production

If you notice visual differences between development and production environments (like different theme/styling), it could be due to:

1. Different CSS processing:
   - Development uses JIT (Just-In-Time) compilation
   - Production uses a pre-built, optimized CSS bundle

2. Environment-specific rendering:
   - Components that render differently based on NODE_ENV
   - Conditional styling based on environment variables

#### Solution:

To ensure visual consistency:

1. Avoid using environment variables for conditional styling in components
2. For theme consistency, use explicit classes rather than conditional dark mode:
   ```jsx
   {/* Instead of this: */}
   <div className="bg-white dark:bg-gray-900">

   {/* Use this for consistent appearance: */}
   <div className="bg-gray-900 text-white">
   ```

3. Rebuild the production version after any styling changes:
   ```bash
   npm run build:prod
   ```

4. Restart both development and production servers to ensure they use the latest code:
   ```bash
   # Kill running servers
   kill $(lsof -t -i:3000)
   kill $(lsof -t -i:3002)
   
   # Start development server
   npm run dev
   
   # Start production server
   npm run start:prod
   ```

### Environment Module Import Errors

You might encounter errors related to importing from the environment utility:

```
Type error: Module '"./env"' has no exported member 'isDevelopment'.
```

#### Solution:

1. Make sure `src/utils/env.ts` exports all necessary values:
   ```typescript
   export const env = {
     environment: process.env.NODE_ENV || 'development',
     isDevelopment: process.env.NODE_ENV === 'development',
     isProduction: process.env.NODE_ENV === 'production',
     apiUrl: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api',
     siteUrl: process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000',
     mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/whatsdesigns',
     nextAuthSecret: process.env.NEXTAUTH_SECRET || 'your-development-secret',
   };
   ```

2. Update imports in other files to use the `env` object:
   ```typescript
   // Instead of
   import { isDevelopment } from '@/utils/env';
   
   // Use this
   import { env } from '@/utils/env';
   // Then use env.isDevelopment
   ```

3. Ensure your environment configuration files exist and have the required variables:
   - `.env.development` - Development environment variables
   - `.env.production` - Production environment variables
   - `.env` - Fallback environment variables

### Next.js Build Issues

If you encounter issues during the build process:

#### Solution:

1. Check for TypeScript errors:
   ```bash
   npm run type-check
   ```

2. Clear Next.js cache:
   ```bash
   rm -rf .next
   ```

3. Update Next.js dependencies:
   ```bash
   npm update next react react-dom
   ```

4. Rebuild the application:
   ```bash
   npm run build:prod
   ```

### Git Best Practices

To maintain code consistency across environments:

1. Always commit and push changes after significant updates:
   ```bash
   git add .
   git commit -m "Meaningful commit message"
   git push
   ```

2. Pull latest changes before starting development:
   ```bash
   git pull
   ```

3. Rebuild after pulling changes:
   ```bash
   npm install  # If dependencies changed
   npm run build:prod
   ```

4. Update documentation when making significant changes

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

## Quick Start After Cloning

If you've just cloned the repository, follow these steps to get the project up and running quickly:

### 1. Install Dependencies

```bash
# Ensure you're using the correct Node.js version
nvm use 20.19.0

# Install dependencies
npm install
```

### 2. Set Up Environment Variables

```bash
# Create development environment file
cp .env.example .env
# or if .env.example doesn't exist, create .env with the following content:

# Application URLs
NEXT_PUBLIC_API_URL=http://localhost:3000/api
NEXT_PUBLIC_SITE_URL=http://localhost:3000

# Authentication
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-secret-key

# OpenAI Configuration
OPENAI_API_KEY=your-openai-api-key

# MongoDB Configuration
MONGODB_URI=mongodb://localhost:27017/whatsdesigns

# Environment
NODE_ENV=development
```

### 3. Fix Tailwind CSS Configuration

Next.js 15.2.4 requires specific Tailwind CSS setup:

```bash
# Remove any conflicting packages
npm uninstall tailwindcss autoprefixer postcss @tailwindcss/postcss @tailwindcss/postcss7-compat

# Install correct packages
npm install -D @tailwindcss/postcss autoprefixer postcss
npm install -D @tailwindcss/forms @tailwindcss/typography
```

Update your PostCSS configuration in `postcss.config.js`:

```javascript
module.exports = {
  plugins: {
    '@tailwindcss/postcss': {},
    autoprefixer: {},
  },
};
```

### 4. Ensure MongoDB is Running

```bash
# Start MongoDB if not already running
brew services start mongodb-community

# Verify MongoDB connection
mongosh --eval "db.runCommand({ping: 1})"
```

### 5. Start Development Server

```bash
# Start the development server
npm run dev

# If port 3000 is in use, find and kill the process
lsof -i :3000
kill <PID>
```

The development server should now be running at http://localhost:3000.

### 6. Building for Production

```bash
# Build the production version
npm run build:prod

# Start the production server
npm run start:prod
```

The production server will be available at http://localhost:3002.

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

## System Recovery and Troubleshooting

### Display Issues
If you encounter a black screen after system boot (while system is still running):
1. Verify system is running:
   - Try SSH access
   - Check if services are responding
2. Try software fixes first:
   ```bash
   # Reset display sleep settings
   sudo pmset -a displaysleep 0
   sudo pmset -a sleep 0
   
   # Reset WindowServer
   sudo killall WindowServer
   ```
3. If software fixes fail, perform hardware reset:
   - Shut down the system completely
   - Press and hold Power button for 10 seconds
   - Wait 30 seconds
   - Press and hold these keys together for 20 seconds:
     * Command (⌘)
     * Option (Alt)
     * P
     * R
   - Release the keys
   - Press Power button normally to start

### Auto-login Configuration
When configuring auto-login:
1. Always test in a controlled environment
2. Ensure SSH access is configured as backup
3. Have hardware reset steps ready
4. Back up all code before testing
5. Document all configuration changes

### Backup Procedures
1. Git Repository:
   ```bash
   # Initialize Git
   git init
   
   # Add remote
   git remote add origin your-repo-url
   
   # Stage and commit
   git add .
   git commit -m "Your message"
   
   # Push to remote
   git push -u origin main
   ```
2. SSH Key Setup:
   ```bash
   # Generate SSH key
   ssh-keygen -t ed25519 -C "your-key-name"
   
   # Display public key
   cat ~/.ssh/id_ed25519.pub
   ```
3. Add SSH key to GitHub:
   - Go to GitHub Settings
   - SSH and GPG keys
   - New SSH key
   - Paste public key

### Emergency Recovery
Always maintain:
1. SSH access configuration
2. Backup admin account
3. Hardware reset instructions
4. Current backups
5. System logs
6. Recovery documentation

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:
- Port management
- SSL certificate handling
- Domain configuration
- Environment separation

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*;
   }
   ```

4. Create Site Configuration:
   ```bash
   sudo nano /opt/homebrew/etc/nginx/servers/whatsdesigns.conf
   ```
   Add:
   ```nginx
   # Production Server
   server {
       listen 80;
       server_name whatsdesigns.com www.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name whatsdesigns.com www.whatsdesigns.com;

       ssl_certificate /etc/letsencrypt/live/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/whatsdesigns.com/privkey.pem;

       # Security headers
       add_header Strict-Transport-Security "max-age=31536000" always;
       add_header X-Frame-Options SAMEORIGIN;
       add_header X-Content-Type-Options nosniff;

       location / {
           proxy_pass http://localhost:3002;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }

   # Development Server (Optional)
   server {
       listen 80;
       server_name dev.whatsdesigns.com;
       return 301 https://$server_name$request_uri;
   }

   server {
       listen 443 ssl;
       http2 on;
       server_name dev.whatsdesigns.com;

       ssl_certificate /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem;
       ssl_certificate_key /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### SSL Certificate Setup

#### Production Certificates (Let's Encrypt)
1. Stop Nginx:
   ```bash
   sudo nginx -s stop
   ```

2. Obtain Certificate:
   ```bash
   sudo certbot certonly --standalone -d whatsdesigns.com -d www.whatsdesigns.com
   ```

3. Set Up Auto-Renewal:
   ```bash
   # Create renewal hooks
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh

   # Add to crontab
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

#### Development Certificates (Self-signed)
1. Generate Certificate:
   ```bash
   sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/privkey.pem \
     -out /opt/homebrew/etc/nginx/ssl/whatsdesigns.com/fullchain.pem \
     -subj "/CN=dev.whatsdesigns.com"
   ```

### Managing the Environment

1. Start/Stop Services:
   ```bash
   # Start Nginx
   sudo nginx

   # Stop Nginx
   sudo nginx -s stop

   # Reload configuration
   sudo nginx -s reload
   ```

2. View Logs:
   ```bash
   # Access logs
   tail -f /opt/homebrew/var/log/nginx/access.log

   # Error logs
   tail -f /opt/homebrew/var/log/nginx/error.log
   ```

3. Test Configuration:
   ```bash
   sudo nginx -t
   ```

### Environment-Specific Ports

- Production:
  - Next.js: 3002
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

- Development:
  - Next.js: 3000
  - HTTP: 80 → HTTPS redirect
  - HTTPS: 443

### Security Considerations

1. SSL Certificate Management:
   ```bash
   # Check certificate status
   certbot certificates

   # Monitor expiration
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. Regular Updates:
   ```bash
   # Update all components
   brew update && brew upgrade
   ```

3. Access Control:
   - Production and development environments share the same machine
   - Use different ports for each environment
   - Keep development environment local-only
   - Use proper environment variables

### Troubleshooting

1. Certificate Issues:
   ```bash
   # Test SSL
   curl -vI https://whatsdesigns.com
   curl -vI https://dev.whatsdesigns.com
   ```

2. Port Conflicts:
   ```bash
   # Check port usage
   sudo lsof -i :80
   sudo lsof -i :443
   sudo lsof -i :3000
   sudo lsof -i :3002
   ```

3. Common Issues:
   - Port forwarding not working: Check router configuration
   - SSL certificate errors: Verify paths and permissions
   - 502 Bad Gateway: Check if Next.js is running on correct port
   - Connection refused: Check Nginx status and port availability

### Notes
- Keep production and development databases separate
- Use environment variables to manage different configurations
- Regular backups are crucial as both environments share the same machine
- Monitor system resources as both environments run simultaneously
- Consider containerization for better environment isolation in the future

### SSL Certificate Auto-Renewal Setup

1. **Configure Certbot Auto-Renewal**
   ```bash
   # Create renewal hooks directory
   sudo mkdir -p /etc/letsencrypt/renewal-hooks/{pre,post}

   # Create pre-renewal hook to stop Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx -s stop
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/pre/stop-nginx.sh

   # Create post-renewal hook to start Nginx
   sudo tee /etc/letsencrypt/renewal-hooks/post/start-nginx.sh << 'EOF'
   #!/bin/sh
   sudo nginx
   EOF
   sudo chmod +x /etc/letsencrypt/renewal-hooks/post/start-nginx.sh
   ```

2. **Set Up Crontab for Auto-Renewal**
   ```bash
   # Add to crontab to run at midnight on the first day of each month
   (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/certbot renew --quiet") | crontab -
   ```

3. **Test Auto-Renewal**
   ```bash
   # Test the renewal process without making changes
   sudo certbot renew --dry-run
   ```

4. **Monitor Certificate Status**
   ```bash
   # Check certificate expiration dates
   echo | openssl s_client -servername whatsdesigns.com \
     -connect whatsdesigns.com:443 2>/dev/null | \
     openssl x509 -noout -dates

   # View all certificates managed by Certbot
   sudo certbot certificates
   ```

5. **Backup SSL Certificates**
   ```bash
   # Create backup directory
   sudo mkdir -p /etc/letsencrypt/backup

   # Backup certificates (run before renewal)
   sudo cp -r /etc/letsencrypt/live/whatsdesigns.com /etc/letsencrypt/backup/
   sudo cp -r /etc/letsencrypt/archive/whatsdesigns.com /etc/letsencrypt/backup/
   ```

6. **Troubleshooting Auto-Renewal**
   ```bash
   # Check Certbot logs
   sudo tail -f /var/log/letsencrypt/letsencrypt.log

   # Check renewal configuration
   sudo certbot renew --dry-run --debug

   # Force renewal if needed
   sudo certbot renew --force-renewal
   ```

7. **Security Considerations**
   - Keep backup of SSL certificates
   - Monitor certificate expiration
   - Set up alerts for failed renewals
   - Maintain proper file permissions
   - Regular security audits

8. **Best Practices**
   - Test renewal process monthly
   - Keep Certbot updated
   - Monitor server logs for SSL issues
   - Maintain backup of certificates
   - Document renewal process

## Server Environment Setup

### Combined Production and Development Environment

This project uses a unique setup where both production and development environments run on the same machine. This approach requires special consideration for:

#### Environment Details
- Production Domain: whatsdesigns.com
- Development Domain: dev.whatsdesigns.com (local)
- External IP: 66.219.222.78 (port forwarded)
- Internal IP: 192.168.1.26

### Port Forwarding Configuration

1. Router Setup:
   - Forward port 80 to 192.168.1.26:80
   - Forward port 443 to 192.168.1.26:443
   - Ensure firewall allows these ports

2. Local Network Access:
   ```bash
   # Add to /etc/hosts for local development
   127.0.0.1 dev.whatsdesigns.com
   ```

## Nginx and SSL Configuration

### Prerequisites
- Nginx installed via Homebrew
- Certbot installed for SSL certificate management
- Port forwarding configured (80 and 443)
- Root access for SSL certificate management

### Installation Steps

1. Install Required Software:
   ```bash
   # Install Nginx
   brew install nginx

   # Install Certbot
   brew install certbot
   ```

2. Create Required Directories:
   ```bash
   # Create Nginx configuration directories
   sudo mkdir -p /opt/homebrew/etc/nginx/servers
   sudo mkdir -p /opt/homebrew/etc/nginx/ssl/whatsdesigns.com
   ```

3. Configure Nginx:
   ```bash
   # Main configuration
   sudo nano /opt/homebrew/etc/nginx/nginx.conf
   ```
   Add:
   ```nginx
   worker_processes 1;
   events {
       worker_connections 1024;
   }
   http {
       include mime.types;
       default_type application/octet-stream;
       sendfile on;
       keepalive_timeout 65;
       include servers/*