import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteDocument } from "../../services/prisma/documents/delete"
import { fetchDocument } from "../../services/prisma/documents/fetch"
import { CustomTypeDelete } from "../../types/request/documents"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteDocuments(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/documents",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.documents.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const document = await fetchDocument({ id })

        const hasDocument = !!document
        if (!hasDocument) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate document"
          })
        }

        const data = await deleteDocument({ id }).then(async data => {
          await fetch(`/upload?key=${document?.key}`, {
            method: "DELETE"
          })

          return data
        })
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
