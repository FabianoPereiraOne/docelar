import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useGenerateHash } from "../../hooks/useGenerateHash"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchCollaborator } from "../../services/prisma/collaborators/fetch"
import { updateCollaborator } from "../../services/prisma/collaborators/update"
import { CustomTypePatch } from "../../types/request/collaborators"
import { statusCode } from "../../utils/statusCode"

export default async function PatchCollaborators(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/collaborators",
    { preHandler: OperationMiddleware, schema: Schemas.collaborators.patch },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id } = request.query
      const { name, phone, statusAccount, type } = request.body
      const { password } = request.headers

      try {
        const hasCollaborator = !!(await fetchCollaborator(id))

        if (!hasCollaborator) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the collaborator"
          })
        }

        const pass =
          password != undefined ? await useGenerateHash(password) : undefined
        const collaborator = {
          id,
          name,
          phone,
          type,
          statusAccount,
          password: pass
        }

        const data = await updateCollaborator(collaborator)
        return reply.status(statusCode.success.status).send({
          data
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
