import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteCollaborator } from "../../services/prisma/collaborator/delete"
import { fetchCollaborator } from "../../services/prisma/collaborator/fetch"
import { CustomTypeDelete } from "../../types/request/collaborators"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteCollaborators(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/collaborators",
    { preHandler: OperationMiddleware, schema: Schemas.collaborators.delete },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      const collaborator = await fetchCollaborator(id)
      const hasCollaborator = !!collaborator

      if (!hasCollaborator)
        return reply.status(statusCode.notFound.status).send({
          error: statusCode.notFound.error,
          description: "We were unable to locate the collaborator"
        })

      const hasHomeLinked = collaborator?.homes && collaborator.homes.length > 0

      if (hasHomeLinked) {
        return reply.status(statusCode.conflict.status).send({
          error: statusCode.conflict.error,
          description: "Unable to delete collaborator with linked homes"
        })
      }

      try {
        const data = await deleteCollaborator(id)
        return reply.status(statusCode.success.status).send({
          data
        })
      } catch (error) {
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
