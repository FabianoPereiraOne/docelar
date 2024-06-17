import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchHome } from "../../services/prisma/homes/fetch"
import { CustomTypeGet } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function GetHomes(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/homes/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
        const data = await fetchHome(id)
        const hasHome = !!data

        if (!hasHome) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the home"
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
