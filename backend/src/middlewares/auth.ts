import { DoneFuncWithErrOrRes, FastifyReply, FastifyRequest } from "fastify"
import { useVerifyTokenAuth } from "../hooks/useVerifyTokenAuth"
import { statusCode } from "../utils/statusCode"

export const authMiddleware = async (
  request: FastifyRequest,
  reply: FastifyReply,
  done: DoneFuncWithErrOrRes
) => {
  const token = request.headers.authorization

  if (!!!token)
    reply.status(statusCode.unAuthorized).send("Token was not provided.")

  const isAuthorized = await useVerifyTokenAuth(token!)

  if (!!!isAuthorized)
    reply.status(statusCode.unAuthorized).send("Token is not valid.")

  done()
}
