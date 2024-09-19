import { configDotenv } from "dotenv"
import { FastifyReply } from "fastify"
import jwt from "jsonwebtoken"
import { PayloadType } from "../types/payload"
import { statusCode } from "./statusCode"

configDotenv()
const secret = process.env.NEXT_PUBLIC_SECRET_KEY ?? ""

export async function verify(authorization: string, reply: FastifyReply) {
  try {
    const decoded = jwt.verify(authorization, secret)
    return decoded
  } catch (error: any) {
    if (error?.name === "TokenExpiredError") {
      return reply.status(statusCode.tokenExpired.status).send({
        error: statusCode.tokenExpired.error,
        description: "The token has expired. Please refresh your token"
      })
    }

    return reply.status(statusCode.serverError.status).send({
      error: statusCode.serverError.error,
      description:
        "Something unexpected happened during processing on the server"
    })
  }
}

export async function sign(payload: PayloadType) {
  return jwt.sign(payload, secret, { algorithm: "HS256", expiresIn: "1m" })
}
