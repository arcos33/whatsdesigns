import { Suspense } from "react";
import { Metadata } from "next";
import { SignInForm } from "./client";

export const metadata: Metadata = {
  title: "Sign In | WhatsDesigns",
  description: "Sign in to your WhatsDesigns account"
};

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
          <SignInForm />
        </Suspense>
        
        <div className="mt-6 text-center text-sm">
          <p className="text-gray-600">
            We&apos;ll send a secure link to your phone.
            <br />
            No passwords needed!
          </p>
        </div>
      </div>
    </div>
  );
} 