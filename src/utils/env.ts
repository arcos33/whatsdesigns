export const isProduction = process.env.NODE_ENV === 'production';
export const isDevelopment = process.env.NODE_ENV === 'development';

export const env = {
  apiUrl: process.env.NEXT_PUBLIC_API_URL,
  siteUrl: process.env.NEXT_PUBLIC_SITE_URL,
  analyticsId: process.env.NEXT_PUBLIC_ANALYTICS_ID,
  cdnUrl: process.env.NEXT_PUBLIC_CDN_URL,
  environment: process.env.NEXT_PUBLIC_ENV || 'production',
} as const;

// Validate required environment variables
const requiredEnvVars = ['NEXT_PUBLIC_API_URL', 'NEXT_PUBLIC_SITE_URL'] as const;
for (const envVar of requiredEnvVars) {
  if (!process.env[envVar]) {
    throw new Error(`Missing required environment variable: ${envVar}`);
  }
} 