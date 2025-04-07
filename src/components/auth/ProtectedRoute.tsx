"use client";

import { useSession } from "next-auth/react";
import { useRouter, usePathname } from "next/navigation";
import { useEffect, useState, ReactNode } from "react";

interface ProtectedRouteProps {
  children: ReactNode;
  requiredRole?: string;
}

export default function ProtectedRoute({
  children,
  requiredRole,
}: ProtectedRouteProps) {
  const { data: session, status } = useSession();
  const router = useRouter();
  const pathname = usePathname();
  const [isAuthorized, setIsAuthorized] = useState(false);

  useEffect(() => {
    if (status === "loading") return;

    if (status === "unauthenticated") {
      const callbackUrl = pathname ? encodeURIComponent(pathname) : "";
      router.push(`/auth/signin?callbackUrl=${callbackUrl}`);
      return;
    }

    if (requiredRole && session?.user?.role !== requiredRole) {
      router.push("/unauthorized");
      return;
    }

    setIsAuthorized(true);
  }, [status, session, router, pathname, requiredRole]);

  if (status === "loading" || !isAuthorized) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-blue-500 border-t-transparent" />
      </div>
    );
  }

  return <>{children}</>;
} 