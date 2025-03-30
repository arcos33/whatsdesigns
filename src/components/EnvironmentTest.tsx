import { env } from '@/utils/env';

export default function EnvironmentTest() {
  return (
    <div className="p-4 bg-gray-100 rounded-lg">
      <h2 className="text-lg font-semibold mb-2">Environment Information</h2>
      <div className="space-y-1">
        <p><span className="font-medium">Mode:</span> {env.isDevelopment ? 'Development' : 'Production'}</p>
        <p><span className="font-medium">API URL:</span> {env.apiUrl}</p>
        <p><span className="font-medium">Site URL:</span> {env.siteUrl}</p>
        <p><span className="font-medium">Environment:</span> {env.environment}</p>
        {env.analyticsId && (
          <p><span className="font-medium">Analytics ID:</span> {env.analyticsId}</p>
        )}
        {env.cdnUrl && (
          <p><span className="font-medium">CDN URL:</span> {env.cdnUrl}</p>
        )}
      </div>
    </div>
  );
} 