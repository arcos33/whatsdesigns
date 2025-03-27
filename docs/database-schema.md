# Database Schema Documentation

## Overview

This document outlines the database schema for WhatsDesigns, including all collections, relationships, and indexes.

## Collections

### Users Collection
```typescript
interface User {
  id: string;              // MongoDB ObjectId
  email: string;           // Unique, indexed
  password: string;        // Hashed
  name: string;
  image?: string;         // Profile image URL
  role: UserRole;         // Enum: 'USER' | 'ADMIN'
  verified: boolean;
  createdAt: Date;
  updatedAt: Date;
  lastLogin: Date;
  oauthProviders: {
    provider: string;     // 'google' | 'github' | 'facebook'
    providerId: string;
  }[];
  resetToken?: string;
  resetTokenExpiry?: Date;
  settings: {
    theme: 'light' | 'dark';
    notifications: boolean;
    language: string;
  };
}
```

### Projects Collection
```typescript
interface Project {
  id: string;             // MongoDB ObjectId
  userId: string;         // Reference to User
  name: string;
  description?: string;
  createdAt: Date;
  updatedAt: Date;
  status: ProjectStatus;  // Enum: 'DRAFT' | 'ACTIVE' | 'ARCHIVED'
  settings: {
    isPublic: boolean;
    allowComments: boolean;
  };
  collaborators: {
    userId: string;       // Reference to User
    role: 'VIEWER' | 'EDITOR' | 'OWNER';
  }[];
}
```

### Designs Collection
```typescript
interface Design {
  id: string;             // MongoDB ObjectId
  projectId: string;      // Reference to Project
  userId: string;         // Reference to User
  title: string;
  description?: string;
  imageUrl: string;       // S3/Cloudinary URL
  originalText: string;
  enhancedText: string;
  status: DesignStatus;   // Enum: 'DRAFT' | 'PROCESSING' | 'COMPLETED'
  createdAt: Date;
  updatedAt: Date;
  metadata: {
    imageSize: number;
    imageType: string;
    processingTime?: number;
  };
  tags: string[];
  versions: {
    text: string;
    timestamp: Date;
    changes: string;
  }[];
}
```

### Comments Collection
```typescript
interface Comment {
  id: string;             // MongoDB ObjectId
  designId: string;       // Reference to Design
  userId: string;         // Reference to User
  content: string;
  createdAt: Date;
  updatedAt: Date;
  parentId?: string;      // Reference to Comment (for replies)
  likes: string[];        // Array of User IDs
}
```

### Usage Collection
```typescript
interface Usage {
  id: string;             // MongoDB ObjectId
  userId: string;         // Reference to User
  date: Date;             // Indexed
  type: UsageType;        // Enum: 'IMAGE_UPLOAD' | 'TEXT_ENHANCEMENT'
  count: number;
  metadata: {
    imageSize?: number;
    processingTime?: number;
    success: boolean;
  };
}
```

## Indexes

### Users Collection
```typescript
{
  email: 1,              // Unique
  createdAt: -1,         // Descending
  lastLogin: -1          // Descending
}
```

### Projects Collection
```typescript
{
  userId: 1,             // Ascending
  createdAt: -1,         // Descending
  status: 1              // Ascending
}
```

### Designs Collection
```typescript
{
  projectId: 1,          // Ascending
  userId: 1,             // Ascending
  createdAt: -1,         // Descending
  status: 1,             // Ascending
  tags: 1                // Ascending
}
```

### Comments Collection
```typescript
{
  designId: 1,           // Ascending
  createdAt: -1,         // Descending
  parentId: 1            // Ascending
}
```

### Usage Collection
```typescript
{
  userId: 1,             // Ascending
  date: -1,              // Descending
  type: 1                // Ascending
}
```

## Relationships

### One-to-Many Relationships
- User → Projects
- User → Designs
- User → Comments
- Project → Designs
- Design → Comments

### Many-to-Many Relationships
- Projects ↔ Users (through collaborators)

## Data Validation

### Required Fields
- Users: email, password, name
- Projects: name, userId
- Designs: title, projectId, userId, imageUrl
- Comments: content, designId, userId
- Usage: userId, date, type, count

### Field Constraints
- Email: Must be unique and valid format
- Password: Minimum 8 characters, hashed
- Image URLs: Must be valid S3/Cloudinary URLs
- Dates: Must be valid ISO dates
- Counts: Must be non-negative integers

## Data Migration

### Version Control
- Schema version tracking
- Migration scripts
- Rollback procedures

### Backup Strategy
- Daily backups
- Point-in-time recovery
- Backup verification

## Performance Considerations

### Indexing Strategy
- Compound indexes for common queries
- Text indexes for search
- Geospatial indexes if needed

### Query Optimization
- Projection usage
- Index coverage
- Query patterns

## Security

### Data Access Control
- User-based access control
- Role-based permissions
- API-level security

### Data Encryption
- At-rest encryption
- In-transit encryption
- Key management 