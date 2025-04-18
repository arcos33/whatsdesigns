export const env = {
  isDevelopment: process.env.NODE_ENV === 'development',
  isProduction: process.env.NODE_ENV === 'production',
  apiUrl: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api',
  siteUrl: process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000',
  analyticsId: process.env.NEXT_PUBLIC_ANALYTICS_ID,
  cdnUrl: process.env.NEXT_PUBLIC_CDN_URL || 'http://localhost:3000',
  environment: process.env.NEXT_PUBLIC_ENV || process.env.NODE_ENV || 'development',
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/whatsdesigns',
  openaiApiKey: process.env.OPENAI_API_KEY,
  nextAuthUrl: process.env.NEXTAUTH_URL || 'http://localhost:3000',
  nextAuthSecret: process.env.NEXTAUTH_SECRET || 'dev-secret-key-replace-in-production',
} as const;

// Commented out strict validation to allow for defaults
// Validate required environment variables
// const requiredEnvVars = [
//   'NEXT_PUBLIC_API_URL',
//   'NEXT_PUBLIC_SITE_URL',
//   'MONGODB_URI',
//   'NEXTAUTH_SECRET',
// ] as const;

// for (const envVar of requiredEnvVars) {
//   if (!process.env[envVar]) {
//     throw new Error(`Missing required environment variable: ${envVar}`);
//   }
// } 