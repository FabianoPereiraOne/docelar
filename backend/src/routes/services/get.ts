import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchService } from "../../services/prisma/services/fetch"
import { CustomTypeGet } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function GetServices(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/services/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
        const data = await fetchService(id)
        const hasService = !!data

        if (!hasService) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the service"
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
