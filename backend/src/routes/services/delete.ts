import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteService } from "../../services/prisma/services/delete"
import { fetchService } from "../../services/prisma/services/fetch"
import { CustomTypeDelete } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteServices(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/services",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const service = await fetchService(id)
        const hasService = !!service
        if (!hasService) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the service"
          })
        }

        const data = await deleteService(id)
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
