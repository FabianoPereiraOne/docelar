import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useCompareHash } from "../../hooks/useCompareHash"
import { useGenerateToken } from "../../hooks/useGenerateToken"
import { Schemas } from "../../schemas"
import { fetchCollaboratorByEmail } from "../../services/prisma/collaborator/fetchByEmail"
import { CustomTypePost } from "../../types/request/sign"
import { statusCode } from "../../utils/statusCode"

export default async function Sign(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/sign",
    { schema: Schemas.sign.post },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { password } = request.headers
      const { email } = request.body

      try {
        const collaborator = await fetchCollaboratorByEmail(email)
        const hasCollaborator = !!collaborator

        if (!hasCollaborator) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the collaborator"
          })
        }

        const { password: hash, id } = collaborator
        const match = await useCompareHash(password, hash)

        if (!match) {
          return reply.status(statusCode.unAuthorized.status).send({
            error: statusCode.unAuthorized.error,
            description: "The password provided is invalid"
          })
        }

        const authorization = await useGenerateToken(id, email)
        return reply.status(statusCode.success.status).send({
          authorization
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
