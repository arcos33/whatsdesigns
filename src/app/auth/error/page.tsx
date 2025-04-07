"use client";

import { useSearchParams } from "next/navigation";
import Link from "next/link";
import { Suspense } from "react";

const ErrorContent = () => {
  const searchParams = useSearchParams();
  const error = searchParams ? searchParams.get("error") : null;

  const errorMessages: Record<string, string> = {
    default: "An error occurred during authentication",
    AccessDenied: "Access denied: You do not have permission to access this resource",
    Verification: "The verification link has expired or has already been used",
    Configuration: "Server configuration error",
    CredentialsSignin: "Invalid or expired SMS link",
    SessionRequired: "Please sign in to access this page",
  };

  const errorMessage = error ? errorMessages[error] || errorMessages.default : errorMessages.default;

  return (
    <div className="w-full max-w-md text-center">
      <svg 
        xmlns="http://www.w3.org/2000/svg" 
        className="h-16 w-16 mx-auto text-red-500" 
        fill="none" 
        viewBox="0 0 24 24" 
        stroke="currentColor"
      >
        <path 
          strokeLinecap="round" 
          strokeLinejoin="round" 
          strokeWidth={2} 
          d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" 
        />
      </svg>
      
      <h2 className="mt-6 text-center text-3xl font-bold tracking-tight text-gray-900">
        Authentication Error
      </h2>
      
      <div className="mt-4 text-center text-gray-600">
        {errorMessage}
      </div>
      
      <div className="mt-8">
        <Link
          href="/auth/signin"
          className="inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          Return to Sign In
        </Link>
      </div>
    </div>
  );
};

export default function AuthError() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <Suspense fallback={
        <div className="text-center">
          <div className="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-blue-600 border-r-transparent"></div>
          <p className="mt-4">Loading error details...</p>
        </div>
      }>
        <ErrorContent />
      </Suspense>
    </div>
  );
} 