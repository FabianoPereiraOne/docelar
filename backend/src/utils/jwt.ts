import { configDotenv } from "dotenv"
import jwt from "jsonwebtoken"
import { PayloadType } from "../types/payload"

configDotenv()
const secret = process.env.NEXT_PUBLIC_SECRET_KEY ?? ""

export async function verify(authorization: string) {
  return jwt.verify(authorization, secret)
}

export async function sign(payload: PayloadType) {
  return jwt.sign(payload, secret, { algorithm: "HS256", expiresIn: "1h" })
}
