import { DoneFuncWithErrOrRes, FastifyReply, FastifyRequest } from "fastify"
import { useVerifyTokenAuth } from "../hooks/useVerifyTokenAuth"
import { statusCode } from "../utils/statusCode"

export const authMiddleware = async (
  request: FastifyRequest,
  reply: FastifyReply,
  done: DoneFuncWithErrOrRes
) => {
  const token = request.headers.authorization
  const hasToken = !!token

  if (!hasToken)
    reply.status(statusCode.unAuthorized).send("Token was not provided")

  try {
    const collaborator = await useVerifyTokenAuth(token!)
    const isValidToken = !!collaborator

    if (!isValidToken)
      reply.status(statusCode.unAuthorized).send("This token is not valid")

    if (isValidToken && collaborator.type != "ADMIN")
      reply
        .status(statusCode.unAuthorized)
        .send("Collaborator not authorized for this operation")
  } catch (error) {
    reply.status(statusCode.serverError).send(error)
  }

  done()
}
