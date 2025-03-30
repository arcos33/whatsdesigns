/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Production domain configuration
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=31536000; includeSubDomains'
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin'
          }
        ],
      },
    ]
  },

  // Domain configuration
  async rewrites() {
    return {
      beforeFiles: [
        // Handle www subdomain
        {
          source: '/:path*',
          has: [
            {
              type: 'host',
              value: 'www.whatsdesigns.com',
            },
          ],
          destination: '/:path*',
        },
        // Handle apex domain
        {
          source: '/:path*',
          has: [
            {
              type: 'host',
              value: 'whatsdesigns.com',
            },
          ],
          destination: '/:path*',
        },
      ],
    }
  },

  // Environment specific settings
  env: {
    NEXT_PUBLIC_DOMAIN: process.env.NODE_ENV === 'production' 
      ? 'whatsdesigns.com' 
      : 'localhost:3000',
  },

  // Production optimizations
  poweredByHeader: false,
  compress: true,
  productionBrowserSourceMaps: false,
  
  // Image optimization
  images: {
    domains: ['whatsdesigns.com', 'www.whatsdesigns.com', 'cdn.whatsdesigns.com'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
  },
}

export default nextConfig
