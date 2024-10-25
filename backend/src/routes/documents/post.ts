import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { createDocument } from "../../services/prisma/documents/create"
import { CustomTypePost } from "../../types/request/documents"
import { statusCode } from "../../utils/statusCode"

export default async function PostDocuments(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/documents",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.documents.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { key, animalId, serviceId } = request.body

      try {
        if (!key || key?.length <= 0) {
          return reply.status(statusCode.badRequest.status).send({
            error: statusCode.badRequest.error,
            description: "Key document is required."
          })
        }

        const data = await createDocument({ key, animalId, serviceId })
        return reply.status(statusCode.create.status).send({
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
