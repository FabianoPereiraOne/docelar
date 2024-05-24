import { FastifyInstance, FastifyRequest } from "fastify"
import { useGenerateHash } from "../hooks/useGenerateHash"
import { useVerifyCollaboratorBody } from "../hooks/useVerifyCollaboratorBody"
import { authMiddleware } from "../middlewares/auth"
import { create } from "../services/prisma/collaborator/create"
import { CollaboratorParams } from "../types/collaborator"
import { statusCode } from "../utils/statusCode"

export default async function Collaborator(app: FastifyInstance) {
  app.post(
    "/collaborator",
    { preHandler: authMiddleware },
    async (request: FastifyRequest, reply) => {
      const password = request.headers["password"]
      const data: any = request.body
      const notExistsPass = !!!password

      const isNotValidData = useVerifyCollaboratorBody(request)

      if (isNotValidData || notExistsPass)
        return reply
          .status(statusCode.badRequest)
          .send("Insufficient data or data not provided")

      try {
        const collaborator: CollaboratorParams = {
          name: data.name,
          email: data.email,
          phone: data.phone,
          type: data.type,
          password: await useGenerateHash(password as string)
        }

        await create(collaborator).then(result => {
          return reply
            .status(statusCode.create)
            .send("Collaborator created with success")
        })
      } catch (error: any) {
        return reply
          .status(statusCode.serverError)
          .send("Internal Server Error")
      }
    }
  )
}
