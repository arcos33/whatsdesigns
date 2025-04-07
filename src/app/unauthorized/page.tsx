import Link from "next/link";

export default function Unauthorized() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div className="w-full max-w-md text-center space-y-8">
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
            d="M12 15v2m0 0v2m0-2h2m-2 0H9m3-4V9m1.5-2.25a2.25 2.25 0 1 1-4.5 0 2.25 2.25 0 0 1 4.5 0zM12 6.5c5.523 0 10 4.477 10 10S17.523 26.5 12 26.5 2 22.023 2 16.5s4.477-10 10-10z"
          />
        </svg>

        <h2 className="mt-6 text-center text-3xl font-bold tracking-tight text-gray-900">
          Unauthorized Access
        </h2>
        
        <div className="mt-4 text-center text-gray-600">
          You do not have permission to access this resource.
        </div>
        
        <div className="mt-8 space-y-4">
          <Link
            href="/"
            className="inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
          >
            Return to Home
          </Link>
          
          <div>
            <Link
              href="/auth/signout"
              className="text-blue-600 hover:text-blue-500 text-sm"
            >
              Sign out and try a different account
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
} 