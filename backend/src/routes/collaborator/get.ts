import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { statusCode } from "../../utils/statusCode"

export default async function GetCollaborator(server: FastifyInstance) {
  server.get(
    "/collaborator",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const { id }: any = request.query
      const hasID = !!id

      if (!hasID)
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Collaborator ID was not provided"
        })

      const collaborator = await fetchCollaborator(id)
      const hasCollaborator = !!collaborator

      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the collaborator"
        })

      return reply.status(statusCode.success.status).send({
        data: collaborator
      })
    }
  )
}
