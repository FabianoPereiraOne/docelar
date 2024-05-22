import jwt from "jsonwebtoken"
import { PayloadType } from "../types/payload"

//Ver modo de carregar .env
const secret = ""

export async function verify(token: string) {
  return jwt.verify(token, secret)
}

export async function sign(payload: PayloadType) {
  return jwt.sign(payload, secret)
}
