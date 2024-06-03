import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { operationMiddleware } from "../../middlewares/operation"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { statusCode } from "../../utils/statusCode"

export default async function GetCollaborator(server: FastifyInstance) {
  server.get(
    "/collaborator",
    {
      preHandler: operationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const { id }: any = request.query
      const hasID = !!id

      if (!hasID)
        return reply.status(statusCode.badRequest.status).send({
          statusCode: statusCode.badRequest.status,
          error: statusCode.badRequest.error,
          message: "Employee ID was not provided"
        })

      const collaborator = await fetchCollaborator(id)
      const hasCollaborator = !!collaborator

      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          statusCode: statusCode.notFound.status,
          error: statusCode.notFound.error,
          message: "We were unable to locate the employee"
        })

      return reply.status(statusCode.success.status).send({
        statusCode: statusCode.success.status,
        success: statusCode.success.success,
        data: collaborator
      })
    }
  )
}
