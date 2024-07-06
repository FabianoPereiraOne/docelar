import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteProcedure } from "../../services/prisma/procedures/delete"
import { fetchProcedure } from "../../services/prisma/procedures/fetch"
import { CustomTypeDelete } from "../../types/request/procedures"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteProcedures(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/procedures",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.procedures.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const procedure = await fetchProcedure(id)

        const hasProcedure = !!procedure
        if (!hasProcedure) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the procedure"
          })
        }

        const data = await deleteProcedure(id)
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
