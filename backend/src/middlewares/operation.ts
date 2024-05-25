import { DoneFuncWithErrOrRes, FastifyReply, FastifyRequest } from "fastify"
import { useVerifyTokenAuth } from "../hooks/useVerifyTokenAuth"
import { statusCode } from "../utils/statusCode"

export const operationMiddleware = async (
  request: FastifyRequest,
  reply: FastifyReply,
  done: DoneFuncWithErrOrRes
) => {
  const token = request.headers.authorization
  const hasToken = !!token

  if (!hasToken)
    return reply.status(statusCode.unAuthorized.status).send({
      statusCode: statusCode.unAuthorized.status,
      error: statusCode.unAuthorized.error,
      message: "Token was not provided"
    })

  try {
    const collaborator = await useVerifyTokenAuth(token!)
    const isValidToken = !!collaborator

    if (!isValidToken)
      return reply.status(statusCode.unAuthorized.status).send({
        statusCode: statusCode.unAuthorized.status,
        error: statusCode.unAuthorized.error,
        message: "This token is not valid"
      })

    if (collaborator!.type != "ADMIN" || collaborator!.status != true)
      return reply.status(statusCode.unAuthorized.status).send({
        statusCode: statusCode.unAuthorized.status,
        error: statusCode.unAuthorized.error,
        message: "Collaborator not authorized for this operation"
      })
  } catch (error: any) {
    return reply.send(error)
  }

  done()
}
