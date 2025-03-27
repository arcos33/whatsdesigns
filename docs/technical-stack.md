# Technical Stack Documentation

## Overview

This document outlines all the technologies, tools, and services used in the WhatsDesigns project.

## Core Technologies

### Frontend
- **Framework**: Next.js 15.2.4
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: React Hooks
- **Form Handling**: React Hook Form
- **Validation**: Zod

### Backend
- **Runtime**: Node.js v20.19.0
- **Framework**: Next.js API Routes
- **Database**: MongoDB
- **ORM**: Prisma
- **Authentication**: NextAuth.js

### AI & Processing
- **Text Enhancement**: OpenAI GPT API
- **Image Processing**: Sharp
- **Image Storage**: AWS S3/Cloudinary

## Development Environment

### Local Development
- **Node Version Manager**: NVM v0.39.7
- **Package Manager**: npm v10.8.2
- **Shell**: zsh
- **DNS Management**: DNSDuck
- **Code Editor**: VS Code
- **Version Control**: Git

### Development Tools
- **Linting**: ESLint
- **Code Formatting**: Prettier
- **Testing**: Jest
- **Type Checking**: TypeScript
- **API Testing**: Postman/Insomnia

### CI/CD
- **Version Control**: GitHub
- **Continuous Integration**: GitHub Actions
- **Deployment**: Vercel
- **Monitoring**: Sentry

## Infrastructure

### DNS & Networking
- **Domain**: whatsdesigns.com
- **Local DNS**: DNSDuck
- **Production DNS**: Cloudflare
- **SSL/TLS**: Let's Encrypt
  - Certificate Path: /etc/letsencrypt/live/whatsdesigns.com/
  - Auto-renewal: Certbot
- **CDN**: Cloudflare
- **Reverse Proxy**: Nginx
  - HTTP to HTTPS redirection
  - Modern SSL configuration
  - WebSocket support
  - HTTP/2 enabled

### Server Configuration
- **Production Port**: 3002
- **Process Management**: macOS LaunchAgent
- **SSL Configuration**:
  - Protocols: TLSv1.2, TLSv1.3
  - HSTS enabled
  - OCSP Stapling enabled
  - Session cache: 50MB
  - Session timeout: 1 day
- **Nginx Configuration**:
  - Location: /usr/local/etc/nginx/servers/whatsdesigns.conf
  - Proxy settings for Next.js
  - Security headers
  - Real IP forwarding

### Storage
- **File Storage**: AWS S3/Cloudinary
- **Database**: MongoDB Atlas
- **Caching**: Redis

### Email & Communication
- **Email Service**: SendGrid
- **Notifications**: Web Push API

## Security

### Authentication & Authorization
- **Auth Provider**: NextAuth.js
- **Password Hashing**: bcrypt
- **Session Management**: JWT
- **OAuth Providers**: Google, GitHub, Facebook

### Security Tools
- **CSRF Protection**: Next.js built-in
- **XSS Prevention**: React built-in
- **Rate Limiting**: Express-rate-limit
- **Input Validation**: Zod
- **SSL/TLS**: Let's Encrypt with automatic renewal

## Monitoring & Analytics

### Performance Monitoring
- **Application Monitoring**: Sentry
- **Server Monitoring**: Vercel Analytics
- **Error Tracking**: Sentry
- **Performance Metrics**: Web Vitals

### Analytics
- **User Analytics**: Google Analytics
- **Error Tracking**: Sentry
- **Usage Statistics**: Custom implementation

## Development Workflow

### Code Quality
- **Linting**: ESLint
- **Formatting**: Prettier
- **Type Checking**: TypeScript
- **Testing**: Jest

### Version Control
- **Repository**: GitHub
- **Branch Strategy**: Git Flow
- **Code Review**: GitHub Pull Requests
- **Documentation**: Markdown

### Deployment
- **Hosting**: Vercel
- **Database**: MongoDB Atlas
- **File Storage**: AWS S3/Cloudinary
- **CDN**: Cloudflare
- **Production Server**:
  - Port: 3002
  - Process Management: macOS LaunchAgent
  - Auto-restart: Enabled
  - Logging: File-based (output.log, error.log)
  - Notifications: macOS native notifications
  - Environment: Production-specific (.env.production)
  - SSL: Let's Encrypt certificates
  - Reverse Proxy: Nginx

## Dependencies

### Core Dependencies
```json
{
  "dependencies": {
    "next": "15.2.4",
    "react": "19.0.0",
    "typescript": "latest",
    "tailwindcss": "latest",
    "next-auth": "latest",
    "prisma": "latest",
    "openai": "latest",
    "sharp": "latest"
  }
}
```

### Development Dependencies
```json
{
  "devDependencies": {
    "@types/node": "latest",
    "@types/react": "latest",
    "eslint": "latest",
    "prettier": "latest",
    "jest": "latest",
    "@testing-library/react": "latest"
  }
}
```

## Environment Variables

### Required Environment Variables
```env
# Domain Configuration
NEXT_PUBLIC_SITE_URL=https://www.whatsdesigns.com
NEXT_PUBLIC_API_URL=https://www.whatsdesigns.com/api
NEXT_PUBLIC_CDN_URL=https://cdn.whatsdesigns.com

# SSL Configuration
SSL_CERT_PATH=/etc/letsencrypt/live/whatsdesigns.com/fullchain.pem
SSL_KEY_PATH=/etc/letsencrypt/live/whatsdesigns.com/privkey.pem

# Authentication
NEXTAUTH_URL=https://www.whatsdesigns.com
NEXTAUTH_SECRET=

# Database
DATABASE_URL=

# Storage
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
AWS_BUCKET_NAME=

# AI
OPENAI_API_KEY=

# Email
SENDGRID_API_KEY=
```

## Version Requirements

### Node.js
- Version: v20.19.0 (LTS: Iron)
- Package Manager: npm v10.8.2

### Browser Support
- Chrome (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)
- Edge (latest 2 versions)

## Local Development Setup

### Prerequisites
1. Node.js v20.19.0
2. MongoDB
3. DNSDuck for local DNS
4. Git
5. Nginx

### Installation Steps
1. Clone repository
2. Install dependencies
3. Set up environment variables
4. Configure SSL certificates
5. Configure Nginx
6. Start development server

See [Setup Guide](./setup-guide.md) for detailed installation instructions.

## Server Management

### Process Management
- **launchd**: macOS service management
  - Automatic server startup
  - Process monitoring
  - Failure recovery
  - Log management

### Server Scripts
- **start-prod.sh**: Production server startup
  - Environment setup
  - Directory validation
  - Error handling
  - Logging configuration
- **shutdown-prod.sh**: Graceful server shutdown
  - Process termination
  - Resource cleanup
  - State preservation
- **restart-prod.sh**: Server restart
  - Graceful shutdown
  - System reboot handling
  - Auto-login configuration

### Logging System
- **Directory Tracking**: Monitor file system operations
- **Error Logging**: Capture and store errors
- **Output Logging**: Server output capture
- **Structured Logging**: Timestamp and context information

### Configuration Management
- **Environment Variables**: 
  - Development and production configs
  - Secure credential storage
  - Runtime configuration
- **LaunchAgent Configurations**:
  - Process management
  - Environment setup
  - Log routing
  - Working directory management

## Infrastructure

### Local Development
- **Node.js**: v20.19.0 (LTS: Iron)
- **npm**: v10.8.2
- **nvm**: Node version management
- **Port**: 3000

### Production Environment
- **Node.js**: v20.19.0 (LTS: Iron)
- **Port**: 3002
- **Process Management**: launchd
- **Monitoring**: Log-based tracking

### Domain Configuration
- **SSL**: Let's Encrypt
- **Reverse Proxy**: Nginx
- **Domain**: whatsdesigns.com

## Security

### SSL/TLS
- **Certificate Provider**: Let's Encrypt
- **Protocol**: TLS 1.2, 1.3
- **Renewal**: Automated (planned)

### Access Control
- **Process Permissions**: Least privilege
- **File Permissions**: 755 for directories, 644 for files
- **Environment Isolation**: Development/Production separation

## Monitoring & Analytics

### Logging
- **Server Logs**:
  - Error tracking
  - Output capture
  - Directory operations
- **Access Logs**: Nginx request logging
- **Process Logs**: launchd service logs

### Performance Monitoring
- **Server Status**: launchd process monitoring
- **Resource Usage**: System metrics
- **Error Tracking**: Centralized error logs

## Development Workflow

### Version Control
- **Git**: Source code management
- **GitHub**: Repository hosting (planned)

### Environment Management
- **nvm**: Node.js version control
- **.env files**: Environment configuration
- **config/**: Centralized configuration

### Build Process
- **Development**: `npm run dev`
- **Production**: `npm run build:prod`
- **Start**: `npm run start:prod`

## Dependencies

### Production
- react: ^19.0.0
- react-dom: ^19.0.0
- next: 15.2.4

### Development
- typescript: ^5
- @types/node: ^20
- @types/react: ^19
- @types/react-dom: ^19
- @tailwindcss/postcss: ^4

## Environment Variables

### Production
- NODE_ENV=production
- PORT=3002 (default)
- Additional variables in config/.env.production

### Development
- NODE_ENV=development
- PORT=3000
- Additional variables in config/.env.development 