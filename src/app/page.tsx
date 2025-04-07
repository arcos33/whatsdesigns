"use client";

import Link from "next/link";
import { env } from "@/utils/env";
import EnvironmentTest from '@/components/EnvironmentTest';
import { useSession } from "next-auth/react";

export default function Home() {
  // Force dark theme styling for consistency across environments
  const darkTheme = true;
  const { data: session, status } = useSession();
  const isAuthenticated = status === "authenticated";
  
  return (
    <div className="min-h-screen bg-gray-900 text-white">
      {/* Environment Indicator */}
      <div className={`fixed top-0 ${env.environment === 'production' ? 'right-0' : 'left-0'} px-4 py-2 text-sm font-semibold rounded-bl-lg ${
        env.environment === 'production' 
          ? 'bg-green-500 text-white' 
          : 'bg-yellow-500 text-black'
      }`}>
        {env.environment.toUpperCase()}
      </div>

      {/* Navigation */}
      <header className="absolute top-0 left-0 right-0 z-10">
        <nav className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16 items-center">
            <div className="flex-shrink-0">
              <Link href="/" className="text-xl font-bold">WhatsDesigns</Link>
            </div>
            <div className="flex items-center space-x-4">
              {isAuthenticated ? (
                <>
                  <Link 
                    href="/dashboard" 
                    className="text-gray-300 hover:text-white transition-colors"
                  >
                    Dashboard
                  </Link>
                  <Link
                    href="/auth/signout"
                    className="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 transition-colors"
                  >
                    Sign Out
                  </Link>
                </>
              ) : (
                <>
                  <Link
                    href="/auth/signin"
                    className="text-gray-300 hover:text-white transition-colors"
                  >
                    Sign In
                  </Link>
                  <Link
                    href="/auth/signup"
                    className="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 transition-colors"
                  >
                    Sign Up
                  </Link>
                </>
              )}
            </div>
          </div>
        </nav>
      </header>

      {/* Hero Section */}
      <section className="relative h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <h1 className="text-4xl sm:text-6xl font-bold text-white mb-6">
            Transform Your Images with AI
          </h1>
          <p className="text-xl sm:text-2xl text-gray-300 mb-8 max-w-3xl mx-auto">
            Upload your images, enhance your text, and create stunning designs with the power of artificial intelligence.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href={isAuthenticated ? "/dashboard" : "/auth/signin"}
              className="inline-flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 transition-colors"
            >
              {isAuthenticated ? "Go to Dashboard" : "Get Started"}
            </Link>
            <Link
              href="/gallery"
              className="inline-flex items-center justify-center px-8 py-3 border border-gray-600 text-base font-medium rounded-md text-gray-200 bg-gray-800 hover:bg-gray-700 transition-colors"
            >
              View Gallery
            </Link>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-gray-800">
        <div className="max-w-7xl mx-auto">
          <h2 className="text-3xl font-bold text-center text-white mb-12">
            Key Features
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="p-6 bg-gray-700 rounded-lg shadow-sm">
              <div className="w-12 h-12 bg-blue-900 rounded-lg flex items-center justify-center mb-4">
                <svg className="w-6 h-6 text-blue-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
              </div>
              <h3 className="text-xl font-semibold text-white mb-2">Image Upload</h3>
              <p className="text-gray-300">Upload your images and let our AI enhance them to perfection.</p>
            </div>
            <div className="p-6 bg-gray-700 rounded-lg shadow-sm">
              <div className="w-12 h-12 bg-blue-900 rounded-lg flex items-center justify-center mb-4">
                <svg className="w-6 h-6 text-blue-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                </svg>
              </div>
              <h3 className="text-xl font-semibold text-white mb-2">Text Enhancement</h3>
              <p className="text-gray-300">Improve your text with AI-powered suggestions and refinements.</p>
            </div>
            <div className="p-6 bg-gray-700 rounded-lg shadow-sm">
              <div className="w-12 h-12 bg-blue-900 rounded-lg flex items-center justify-center mb-4">
                <svg className="w-6 h-6 text-blue-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 5a1 1 0 011-1h14a1 1 0 011 1v2a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM4 13a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H5a1 1 0 01-1-1v-6zM16 13a1 1 0 011-1h2a1 1 0 011 1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-6z" />
                </svg>
              </div>
              <h3 className="text-xl font-semibold text-white mb-2">Design Templates</h3>
              <p className="text-gray-300">Choose from a variety of professional design templates.</p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <h2 className="text-3xl font-bold text-white mb-8">
            Ready to Create Amazing Designs?
          </h2>
          <p className="text-xl text-gray-300 mb-8 max-w-2xl mx-auto">
            Join thousands of users who are already creating stunning designs with WhatsDesigns.
          </p>
          <Link
            href={isAuthenticated ? "/dashboard" : "/auth/signup"}
            className="inline-flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 transition-colors"
          >
            {isAuthenticated ? "Go to Dashboard" : "Sign Up Now"}
          </Link>
        </div>
      </section>

      {/* Environment Test Component */}
      <EnvironmentTest />
    </div>
  );
}
