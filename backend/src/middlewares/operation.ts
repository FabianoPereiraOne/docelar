import { FastifyReply, FastifyRequest } from "fastify"
import { useVerifyToken } from "../hooks/useVerifyToken"
import { statusCode } from "../utils/statusCode"

export const OperationMiddleware = async (
  request: FastifyRequest,
  reply: FastifyReply
) => {
  const token = request.headers.authorization
  const hasToken = !!token
  const method = request.method

  if (!hasToken) {
    return reply.status(statusCode.forbidden.status).send({
      error: statusCode.forbidden.error,
      description: "Token was not provided"
    })
  }

  try {
    const collaborator = await useVerifyToken(token!)
    const isValidToken = !!collaborator

    if (!isValidToken) {
      return reply.status(statusCode.unprocessableEntity.status).send({
        error: statusCode.unprocessableEntity.error,
        description: "This token is not valid"
      })
    }

    if (
      (method != "GET" && collaborator!.type != "ADMIN") ||
      collaborator!.statusAccount != true
    ) {
      return reply.status(statusCode.unAuthorized.status).send({
        error: statusCode.unAuthorized.error,
        description: "Collaborator not authorized for this operation"
      })
    }
  } catch (error: any) {
    return reply.status(statusCode.serverError.status).send({
      error: statusCode.serverError.error,
      description:
        "Something unexpected happened during processing on the server"
    })
  }
}
