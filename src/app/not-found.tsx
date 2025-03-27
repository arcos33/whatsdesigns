import Link from 'next/link'

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-white dark:bg-gray-900">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-4">404 - Page Not Found</h1>
        <p className="text-gray-600 dark:text-gray-300 mb-8">The page you&apos;re looking for doesn&apos;t exist.</p>
        <Link
          href="/"
          className="inline-flex items-center justify-center px-6 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 transition-colors"
        >
          Go Home
        </Link>
      </div>
    </div>
  )
} 