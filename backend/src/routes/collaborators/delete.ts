import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteCollaborator } from "../../services/prisma/collaborators/delete"
import { fetchCollaborator } from "../../services/prisma/collaborators/fetch"
import { CustomTypeDelete } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteCollaborators(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/collaborators",
    { preHandler: OperationMiddleware, schema: Schemas.general.delete },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const collaborator = await fetchCollaborator(id)
        const hasCollaborator = !!collaborator

        if (!hasCollaborator) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the collaborator"
          })
        }

        // const dataDelete = { id, statusAccount: false, type: Role.USER }
        // const data = await updateCollaborator(dataDelete)
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
