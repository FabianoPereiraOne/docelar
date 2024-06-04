import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useGenerateHash } from "../../hooks/useGenerateHash"
import { useVerifyCollaboratorBody } from "../../hooks/useVerifyCollaboratorBody"
import { OperationMiddleware } from "../../middlewares/operation"
import { createCollaborator } from "../../services/prisma/collaborator/create"
import { CollaboratorParams } from "../../types/collaborator"
import { statusCode } from "../../utils/statusCode"

export default async function PostCollaborator(server: FastifyInstance) {
  server.post(
    "/collaborator",
    { preHandler: OperationMiddleware },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const password = request.headers["password"]
      const { name, email, phone, type }: any = request.body
      const notExistsPass = !!!password

      const isNotValidData = useVerifyCollaboratorBody(request)

      if (isNotValidData || notExistsPass)
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Insufficient data or data not provided"
        })

      try {
        const collaborator: CollaboratorParams = {
          name,
          email,
          phone,
          type,
          password: await useGenerateHash(password as string)
        }

        await createCollaborator(collaborator).then(result => {
          return reply.status(statusCode.create.status).send({
            data: result
          })
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
