import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchDocument } from "../../services/prisma/documents/fetch"
import { CustomTypeGet } from "../../types/request/documents"
import { statusCode } from "../../utils/statusCode"

export default async function GetDocuments(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/documents/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.documents.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
        const data = await fetchDocument({ id })
        const hasDocument = !!data

        if (!hasDocument) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate document"
          })
        }

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
