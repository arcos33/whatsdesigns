'use client';

import { useEffect, useState, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import { signIn } from 'next-auth/react';

const VerifySmsContent = () => {
  const [verifying, setVerifying] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams?.get('token');

  useEffect(() => {
    const verifyToken = async () => {
      if (!token) {
        setError('No verification token provided');
        setVerifying(false);
        return;
      }

      try {
        // Sign in with the SMS magic link provider
        const result = await signIn('sms-magic-link', {
          token,
          redirect: false,
        });

        if (result?.error) {
          setError(result.error);
          setVerifying(false);
        } else {
          // Authentication successful, redirect to dashboard or home
          router.push('/dashboard');
        }
      } catch (err: any) {
        console.error('Verification error:', err);
        setError('Failed to verify magic link');
        setVerifying(false);
      }
    };

    verifyToken();
  }, [token, router]);

  return (
    <div className="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow-md">
      <div className="text-center">
        <h2 className="mt-6 text-3xl font-extrabold text-gray-900">
          {verifying ? 'Verifying your login...' : error ? 'Verification Failed' : 'Success!'}
        </h2>
        
        {verifying && (
          <div className="mt-6">
            <div className="flex justify-center">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            </div>
            <p className="mt-4 text-sm text-gray-600">
              Please wait while we verify your secure login link...
            </p>
          </div>
        )}
        
        {error && (
          <div className="mt-6">
            <div className="p-4 bg-red-50 border border-red-200 rounded-md">
              <p className="text-sm text-red-700">
                {error === 'CredentialsSignin' 
                  ? 'This login link is invalid or has expired.' 
                  : error}
              </p>
              <p className="mt-2 text-xs text-gray-600">
                Magic links are valid for 15 minutes after being sent.
              </p>
            </div>
            <button
              onClick={() => router.push('/auth/signin')}
              className="mt-4 w-full inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              Request New Login Link
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default function VerifySms() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 px-4 py-12 sm:px-6 lg:px-8">
      <Suspense fallback={
        <div className="text-center">
          <div className="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-blue-600 border-r-transparent"></div>
          <p className="mt-4">Loading verification page...</p>
        </div>
      }>
        <VerifySmsContent />
      </Suspense>
    </div>
  );
} 