import { env, isProduction } from '@/utils/env';

export function EnvironmentTest() {
  return (
    <div className="fixed bottom-4 right-4 bg-gray-800 text-white p-4 rounded-lg shadow-lg text-sm">
      <h3 className="font-bold mb-2">Environment Info</h3>
      <div className="space-y-1">
        <p>Mode: {isProduction ? 'Production' : 'Development'}</p>
        <p>API URL: {env.apiUrl}</p>
        <p>Site URL: {env.siteUrl}</p>
        <p>CDN URL: {env.cdnUrl}</p>
        {env.analyticsId && <p>Analytics: Enabled</p>}
      </div>
    </div>
  );
} 