"use client";

import { useSearchParams } from "next/navigation";
import PhoneSignIn from "@/components/auth/PhoneSignIn";

export function ErrorMessage() {
  const searchParams = useSearchParams();
  const error = searchParams?.get('error');
  
  if (!error) return null;
  
  return (
    <div className="p-2 mb-4 text-sm text-red-800 rounded-lg bg-red-50">
      {error === 'OAuthAccountNotLinked' && (
        <p>An account with this phone number already exists.</p>
      )}
      {error !== 'OAuthAccountNotLinked' && (
        <p>An error occurred during sign in. Please try again.</p>
      )}
    </div>
  );
}

export function SignInForm() {
  return (
    <>
      <ErrorMessage />
      <PhoneSignIn />
    </>
  );
} 