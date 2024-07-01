import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchAllProcedures } from "../../services/prisma/procedures/fetchAll"
import { statusCode } from "../../utils/statusCode"

export default async function GetAllProcedures(server: FastifyInstance) {
  server.get(
    "/procedures",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      try {
        const data = await fetchAllProcedures()
        return reply.status(statusCode.success.status).send({
          data
        })
      } catch (error: any) {
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
