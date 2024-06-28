import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchProcedure } from "../../services/prisma/procedures/fetch"
import { CustomTypeGet } from "../../types/request/procedures"
import { statusCode } from "../../utils/statusCode"

export default async function GetProcedures(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/procedures/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.procedures.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
        const data = await fetchProcedure(id)
        const hasProcedure = !!data

        if (!hasProcedure) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the procedure"
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
