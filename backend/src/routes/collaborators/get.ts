import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { CustomTypeGet } from "../../types/request/collaborators"
import { statusCode } from "../../utils/statusCode"

export default async function GetCollaborators(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/collaborators/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.collaborators.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
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
      } catch (error: any) {
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
