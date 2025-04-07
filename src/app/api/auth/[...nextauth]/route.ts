import NextAuth from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import jwt from "jsonwebtoken";
import { connectToDatabase } from "@/utils/mongodb";
import { ObjectId } from "mongodb";

// Add type for the user
interface User {
  _id: ObjectId;
  phone: string;
  name?: string;
  email?: string;
  createdAt: Date;
  updatedAt: Date;
}

// NextAuth handler
const handler = NextAuth({
  pages: {
    signIn: "/auth/signin",
    error: "/auth/error",
    signOut: "/auth/signout",
  },
  session: {
    strategy: "jwt",
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },
  providers: [
    CredentialsProvider({
      id: "sms-magic-link",
      name: "SMS Magic Link",
      credentials: {
        token: { label: "Token", type: "text" },
      },
      async authorize(credentials) {
        try {
          if (!credentials?.token) {
            throw new Error("No token provided");
          }

          // Verify the JWT token
          const secret = process.env.NEXTAUTH_SECRET;
          if (!secret) {
            throw new Error("NEXTAUTH_SECRET is not configured");
          }

          // Decode and verify the token
          const decoded = jwt.verify(credentials.token, secret) as { phone: string };
          
          if (!decoded.phone) {
            throw new Error("Invalid token");
          }

          // Check if token has been used already
          const { db } = await connectToDatabase();
          const tokenRecord = await db.collection("sms_attempts").findOne({
            token: credentials.token,
          });

          if (!tokenRecord) {
            throw new Error("Token not found");
          }

          if (tokenRecord.used) {
            throw new Error("Token already used");
          }

          // Mark token as used
          await db.collection("sms_attempts").updateOne(
            { token: credentials.token },
            { $set: { used: true, usedAt: new Date() } }
          );

          // Check if user exists, create if not
          let user = await db.collection("users").findOne({
            phone: decoded.phone,
          }) as User | null;

          if (!user) {
            // Create new user
            const result = await db.collection("users").insertOne({
              _id: new ObjectId(),
              phone: decoded.phone,
              createdAt: new Date(),
              updatedAt: new Date(),
            });
            
            user = await db.collection("users").findOne({ _id: result.insertedId }) as User | null;
            
            if (!user) {
              throw new Error("Failed to create user");
            }
          }

          // Return user for JWT creation
          return {
            id: user._id.toString(),
            phone: user.phone,
            name: user.name || null,
            email: user.email || null,
          };
        } catch (error: any) {
          console.error("SMS authentication error:", error);
          return null;
        }
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      // Initial sign in
      if (user) {
        token.phone = user.phone;
        token.userId = user.id;
      }
      return token;
    },
    async session({ session, token }) {
      if (token && session.user) {
        session.user.id = token.userId as string;
        session.user.phone = token.phone as string;
      }
      return session;
    },
  },
});

export { handler as GET, handler as POST }; 