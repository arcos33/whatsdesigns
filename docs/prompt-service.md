# WhatsDesigns Prompt Service

## Overview
The Prompt Service is a standalone microservice that will integrate ChatGPT and other large language models into WhatsDesigns. This service will handle all AI-related functionality, including content generation, design suggestions, and conversational features.

## Implementation Plan

### Phase 1: Setup and Configuration
- Create basic service structure using Node.js/Express
- Set up OpenAI API integration
- Implement authentication and security measures
- Create basic prompt templates

### Phase 2: Core Functionality
- Implement prompt engineering for design-specific use cases
- Add caching layer for improved performance
- Create fallback mechanisms for API outages
- Implement rate limiting and usage tracking

### Phase 3: Advanced Features
- Add fine-tuning capabilities for specific design styles
- Implement multi-modal AI features (text + image)
- Add analytics for prompt effectiveness
- Implement user feedback loop for improved results

## Technical Specifications

### Service Architecture
- **Runtime**: Node.js
- **Framework**: Express.js
- **Port**: 3001
- **Authentication**: JWT tokens shared with main application
- **Communication**: REST API with WebSocket support for streaming

### API Endpoints (Planned)

```
POST /api/prompt/generate
POST /api/prompt/complete
POST /api/prompt/chat
GET /api/prompt/templates
POST /api/prompt/feedback
GET /api/prompt/status
```

### Prompt Templates
The service will include predefined templates for common design-related tasks:
- Logo creation suggestions
- Color palette generation
- Typography recommendations
- Design brief analysis
- Content suggestions for different sections

### Environment Variables
The service requires several environment variables to be set in the `.env.prompt` file:

```
PORT=3001
NODE_ENV=production
OPENAI_API_KEY=your_key_here
OPENAI_ORGANIZATION=your_org_id_here
DEFAULT_MODEL=gpt-4o
FALLBACK_MODEL=gpt-3.5-turbo
MAX_TOKENS=4096
TEMPERATURE=0.7
NEXTAUTH_SECRET=shared_with_main_app
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3002,https://whatsdesigns.com
RATE_LIMIT_REQUESTS=60
RATE_LIMIT_WINDOW_MS=60000
LOG_LEVEL=info
ENABLE_REQUEST_LOGGING=true
MONGODB_URI=your_mongodb_uri_here
```

## Integration with Main Application
The prompt service will be called from the main WhatsDesigns application through API requests. The main app will:
1. Authenticate with the prompt service
2. Send requests with specific prompt templates and user inputs
3. Receive and process the AI-generated responses
4. Display results to the user with appropriate UI

## Deployment
The service will be deployed as a LaunchAgent on macOS with the identifier `com.whatsdesigns.prompt`, similar to the main application services.

## Monitoring and Maintenance
- Logs will be stored in `/Users/jediOne/dev/whatsdesigns/logs/prompt.log`
- Process ID will be tracked in `/Users/jediOne/dev/whatsdesigns/prompt.pid`
- Service status can be checked using the existing `./scripts/check-status.sh` script

## Future Considerations
- Integration with multiple AI providers for redundancy
- Adding support for image generation (DALL-E, Midjourney API, etc.)
- Building a custom fine-tuned model for design-specific tasks
- Implementing a feedback system to continuously improve prompt engineering 