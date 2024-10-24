import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchDocument } from "../../services/prisma/documents/fetch"
import { updateDocument } from "../../services/prisma/documents/update"
import { CustomTypePatch } from "../../types/request/documents"
import { statusCode } from "../../utils/statusCode"

export default async function PatchDocuments(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/documents",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.documents.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id, animalId, key, serviceId } = request.body

      if (!id) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Document ID is required."
        })
      }

      try {
        const hasDocument = await fetchDocument({ id })
        if (!hasDocument) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate document"
          })
        }

        const data = await updateDocument({
          id,
          animalId,
          key,
          serviceId
        }).then(async data => {
          if (!key || key?.length <= 0) return data

          await fetch(`/upload?key=${key}`, {
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
