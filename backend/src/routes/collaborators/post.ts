import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useGenerateHash } from "../../hooks/useGenerateHash"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { createCollaborator } from "../../services/prisma/collaborator/create"
import { CustomTypePost } from "../../types/request/collaborators"
import { statusCode } from "../../utils/statusCode"

export default async function PostCollaborators(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/collaborators",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.collaborators.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { password } = request.headers
      const { name, email, phone, type } = request.body

      try {
        const pass = await useGenerateHash(password as string)
        const collaborator = { name, email, phone, type, password: pass }

        const data = await createCollaborator(collaborator)
        return reply.status(statusCode.create.status).send({
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
