# API Documentation

## Overview

This document outlines all API endpoints available in the WhatsDesigns application. All endpoints are prefixed with `/api/v1`.

## Authentication

### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "string",
  "password": "string",
  "name": "string"
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "email": "string",
    "name": "string"
  }
}
```

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "token": "string",
    "user": {
      "id": "string",
      "email": "string",
      "name": "string"
    }
  }
}
```

### Logout
```http
POST /api/auth/logout
Authorization: Bearer <token>
```

**Response**
```json
{
  "success": true
}
```

## Projects

### List Projects
```http
GET /api/projects
Authorization: Bearer <token>
Query Parameters:
  - page: number (default: 1)
  - limit: number (default: 10)
  - status: string (optional)
```

**Response**
```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": "string",
        "name": "string",
        "description": "string",
        "status": "string",
        "createdAt": "string"
      }
    ],
    "pagination": {
      "total": number,
      "page": number,
      "limit": number,
      "pages": number
    }
  }
}
```

### Create Project
```http
POST /api/projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "description": "string",
  "settings": {
    "isPublic": boolean,
    "allowComments": boolean
  }
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "name": "string",
    "description": "string",
    "status": "string",
    "createdAt": "string"
  }
}
```

### Get Project
```http
GET /api/projects/:id
Authorization: Bearer <token>
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "name": "string",
    "description": "string",
    "status": "string",
    "createdAt": "string",
    "designs": [
      {
        "id": "string",
        "title": "string",
        "imageUrl": "string",
        "status": "string"
      }
    ]
  }
}
```

## Designs

### Create Design
```http
POST /api/designs
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "projectId": "string",
  "title": "string",
  "description": "string",
  "image": File,
  "text": "string"
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "title": "string",
    "imageUrl": "string",
    "status": "string",
    "createdAt": "string"
  }
}
```

### Enhance Text
```http
POST /api/designs/:id/enhance
Authorization: Bearer <token>
Content-Type: application/json

{
  "text": "string",
  "options": {
    "style": "string",
    "tone": "string",
    "length": "string"
  }
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "enhancedText": "string",
    "processingTime": number
  }
}
```

### Get Design
```http
GET /api/designs/:id
Authorization: Bearer <token>
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "title": "string",
    "description": "string",
    "imageUrl": "string",
    "originalText": "string",
    "enhancedText": "string",
    "status": "string",
    "createdAt": "string",
    "comments": [
      {
        "id": "string",
        "content": "string",
        "userId": "string",
        "createdAt": "string"
      }
    ]
  }
}
```

## Comments

### Add Comment
```http
POST /api/designs/:id/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "content": "string",
  "parentId": "string" // optional
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "content": "string",
    "userId": "string",
    "createdAt": "string"
  }
}
```

### Like Comment
```http
POST /api/comments/:id/like
Authorization: Bearer <token>
```

**Response**
```json
{
  "success": true,
  "data": {
    "likes": number
  }
}
```

## User Profile

### Get Profile
```http
GET /api/user/profile
Authorization: Bearer <token>
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "email": "string",
    "name": "string",
    "image": "string",
    "settings": {
      "theme": "string",
      "notifications": boolean,
      "language": "string"
    }
  }
}
```

### Update Profile
```http
PUT /api/user/profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "string",
  "settings": {
    "theme": "string",
    "notifications": boolean,
    "language": "string"
  }
}
```

**Response**
```json
{
  "success": true,
  "data": {
    "id": "string",
    "name": "string",
    "settings": {
      "theme": "string",
      "notifications": boolean,
      "language": "string"
    }
  }
}
```

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "string",
    "details": {
      "field": ["string"]
    }
  }
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token"
  }
}
```

### 403 Forbidden
```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "Insufficient permissions"
  }
}
```

### 404 Not Found
```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Resource not found"
  }
}
```

### 429 Too Many Requests
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests",
    "retryAfter": number
  }
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "error": {
    "code": "INTERNAL_ERROR",
    "message": "An unexpected error occurred"
  }
}
```

## Rate Limiting

- Authentication endpoints: 5 requests per minute
- API endpoints: 100 requests per minute
- File uploads: 10 requests per minute

## Versioning

- Current version: v1
- Version specified in URL: `/api/v1/...`
- Version header: `X-API-Version: 1`

## Webhooks

### Available Events
- `design.created`
- `design.enhanced`
- `comment.created`
- `project.created`
- `project.updated`

### Webhook Payload
```json
{
  "event": "string",
  "timestamp": "string",
  "data": {
    // Event-specific data
  }
}
``` 