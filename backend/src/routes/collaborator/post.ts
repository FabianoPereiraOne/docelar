import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useGenerateHash } from "../../hooks/useGenerateHash"
import { useVerifyCollaboratorBody } from "../../hooks/useVerifyCollaboratorBody"
import { operationMiddleware } from "../../middlewares/operation"
import { create } from "../../services/prisma/collaborator/create"
import { CollaboratorParams } from "../../types/collaborator"
import { statusCode } from "../../utils/statusCode"

export default async function PostCollaborator(server: FastifyInstance) {
  server.post(
    "/collaborator",
    { preHandler: operationMiddleware },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const password = request.headers["password"]
      const { name, email, phone, type }: any = request.body
      const notExistsPass = !!!password

      const isNotValidData = useVerifyCollaboratorBody(request)

      if (isNotValidData || notExistsPass)
        return reply.status(statusCode.badRequest.status).send({
          statusCode: statusCode.badRequest.status,
          error: statusCode.badRequest.error,
          message: "Insufficient data or data not provided"
        })

      try {
        const collaborator: CollaboratorParams = {
          name,
          email,
          phone,
          type,
          password: await useGenerateHash(password as string)
        }

        await create(collaborator).then(result => {
          return reply.status(statusCode.create.status).send({
            statusCode: statusCode.create.status,
            success: statusCode.create.success,
            message: "Collaborator created with success",
            data: result
          })
        })
      } catch (error: any) {
        return reply.send(error)
      }
    }
  )
}
