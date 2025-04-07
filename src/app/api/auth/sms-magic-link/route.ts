import { NextRequest, NextResponse } from "next/server";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { connectToDatabase } from "@/utils/mongodb";

// Define Twilio client - will be properly initialized when credentials are available
let twilioClient: any = null;

// This should come from environment variables
const JWT_SECRET = process.env.NEXTAUTH_SECRET as string;
const APP_URL = process.env.NEXTAUTH_URL as string;

// Initialize Twilio client if credentials exist
if (
  process.env.TWILIO_ACCOUNT_SID &&
  process.env.TWILIO_AUTH_TOKEN &&
  process.env.TWILIO_PHONE_NUMBER
) {
  try {
    const twilio = require("twilio");
    twilioClient = twilio(
      process.env.TWILIO_ACCOUNT_SID,
      process.env.TWILIO_AUTH_TOKEN
    );
  } catch (error) {
    console.error("Failed to initialize Twilio client:", error);
  }
}

// Validate phone number input
const phoneSchema = z.object({
  phone: z.string().min(10).max(15),
});

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    
    // Validate phone number
    const result = phoneSchema.safeParse(body);
    if (!result.success) {
      return NextResponse.json(
        { error: "Invalid phone number format" },
        { status: 400 }
      );
    }
    
    const { phone } = result.data;
    
    // Rate limiting - check if we've sent an SMS recently
    const { db } = await connectToDatabase();
    const recentAttempt = await db.collection("sms_attempts").findOne({
      phone,
      createdAt: { $gt: new Date(Date.now() - 5 * 60 * 1000) } // 5 minutes
    });
    
    if (recentAttempt) {
      const timeLeft = Math.ceil((recentAttempt.createdAt.getTime() + 5 * 60 * 1000 - Date.now()) / 1000 / 60);
      return NextResponse.json(
        { error: `Please wait ${timeLeft} minutes before requesting another code` },
        { status: 429 }
      );
    }
    
    // Create JWT token valid for 15 minutes
    const token = jwt.sign(
      { phone },
      JWT_SECRET,
      { expiresIn: '15m' }
    );
    
    // Build the magic link
    const magicLink = `${APP_URL}/auth/verify-sms?token=${token}`;
    
    // In development, just return the magic link for testing
    if (process.env.NODE_ENV === 'development' || !twilioClient) {
      console.log('DEVELOPMENT MODE: Magic Link:', magicLink);
      
      // Store attempt
      await db.collection("sms_attempts").insertOne({
        phone,
        createdAt: new Date(),
        token,
        used: false
      });
      
      return NextResponse.json({
        message: "Magic link generated (development mode)",
        magicLink, // Only include this in development
      });
    }
    
    // In production, send SMS via Twilio
    const message = await twilioClient.messages.create({
      body: `Your WhatsDesigns login link (valid for 15 min): ${magicLink}`,
      from: process.env.TWILIO_PHONE_NUMBER,
      to: phone
    });
    
    // Store attempt
    await db.collection("sms_attempts").insertOne({
      phone,
      createdAt: new Date(),
      messageId: message.sid,
      token, // Store token to verify later
      used: false
    });
    
    return NextResponse.json({
      message: "Magic link sent via SMS",
    });
    
  } catch (error) {
    console.error("SMS magic link error:", error);
    return NextResponse.json(
      { error: "Failed to send magic link" },
      { status: 500 }
    );
  }
} 