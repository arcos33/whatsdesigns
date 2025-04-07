"use client";

import { useState, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import PhoneSignIn from "@/components/auth/PhoneSignIn";
import { Metadata } from 'next';
import Link from 'next/link';

export const metadata: Metadata = {
  title: 'Sign In | WhatsDesigns',
  description: 'Sign in to your WhatsDesigns account',
};

function SignInAuthError() {
  const AuthError = ({ searchParams }: { searchParams: { error: string } }) => {
    if (!searchParams.error) return null;
    
    return (
      <div className="p-2 mb-4 text-sm text-red-800 rounded-lg bg-red-50">
        {searchParams.error === 'OAuthAccountNotLinked' && (
          <p>An account with this email already exists. Please sign in using your existing account.</p>
        )}
        {searchParams.error !== 'OAuthAccountNotLinked' && (
          <p>An error occurred during sign in. Please try again.</p>
        )}
      </div>
    );
  };

  return <AuthError searchParams={{ error: '' }} />;
}

export default function SignInPage() {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Welcome to WhatsDesigns
        </h2>
        <p className="mt-2 text-center text-sm text-gray-600">
          Sign in to access your account
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <Suspense fallback={<div>Loading...</div>}>
          <SignInAuthError />
        </Suspense>
        
        <PhoneSignIn />
        
        <div className="mt-6 text-center text-sm">
          <p className="text-gray-600">
            We'll send a secure link to your phone.
            <br />
            No passwords needed!
          </p>
        </div>
      </div>
    </div>
  );
} 