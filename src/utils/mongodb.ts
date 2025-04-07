import { MongoClient, Db } from "mongodb";

let cachedClient: MongoClient | null = null;
let cachedDb: Db | null = null;

if (!process.env.MONGODB_URI) {
  throw new Error("Please add your MongoDB URI to .env");
}

const uri = process.env.MONGODB_URI;

export async function connectToDatabase() {
  if (cachedClient && cachedDb) {
    return { client: cachedClient, db: cachedDb };
  }

  const client = new MongoClient(uri);
  await client.connect();
  
  const db = client.db("whatsdesigns");
  
  cachedClient = client;
  cachedDb = db;
  
  return { client, db };
} 