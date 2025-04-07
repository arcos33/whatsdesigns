"use client";

import { useSession } from "next-auth/react";
import ProtectedRoute from "@/components/auth/ProtectedRoute";
import Link from "next/link";

export default function Dashboard() {
  const { data: session } = useSession();

  return (
    <ProtectedRoute>
      <div className="min-h-screen bg-gray-50">
        <header className="bg-white shadow">
          <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8 flex justify-between items-center">
            <h1 className="text-3xl font-bold tracking-tight text-gray-900">
              Dashboard
            </h1>
            <div className="flex gap-4 items-center">
              <span className="text-sm text-gray-600">
                Signed in as {session?.user?.name || session?.user?.email}
              </span>
              <Link
                href="/auth/signout"
                className="rounded-md bg-red-600 px-3 py-2 text-sm font-medium text-white hover:bg-red-500"
              >
                Sign Out
              </Link>
            </div>
          </div>
        </header>
        <main>
          <div className="mx-auto max-w-7xl py-6 sm:px-6 lg:px-8">
            <div className="px-4 py-6 sm:px-0">
              <div className="rounded-lg border-4 border-dashed border-gray-200 p-4 min-h-[60vh]">
                <h2 className="text-xl font-semibold mb-4">Welcome to WhatsDesigns!</h2>
                <p className="mb-4">
                  This is your dashboard where you can manage your designs and settings.
                </p>
                
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-8">
                  {/* Dashboard Card 1 */}
                  <div className="bg-white p-6 rounded-lg shadow-md">
                    <h3 className="text-lg font-medium mb-2">My Designs</h3>
                    <p className="text-gray-500 mb-4">View and manage your design projects</p>
                    <span className="text-blue-600 font-medium">0 projects</span>
                  </div>
                  
                  {/* Dashboard Card 2 */}
                  <div className="bg-white p-6 rounded-lg shadow-md">
                    <h3 className="text-lg font-medium mb-2">Create New</h3>
                    <p className="text-gray-500 mb-4">Start a new design project</p>
                    <button className="text-white bg-blue-600 px-4 py-2 rounded-md hover:bg-blue-700">
                      Create Design
                    </button>
                  </div>
                  
                  {/* Dashboard Card 3 */}
                  <div className="bg-white p-6 rounded-lg shadow-md">
                    <h3 className="text-lg font-medium mb-2">Account</h3>
                    <p className="text-gray-500 mb-4">Manage your account settings</p>
                    <Link href="/account" className="text-blue-600 hover:underline">
                      View Settings
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </ProtectedRoute>
  );
} 