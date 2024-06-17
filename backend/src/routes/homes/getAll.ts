import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchAllHomes } from "../../services/prisma/homes/fetchAll"
import { statusCode } from "../../utils/statusCode"

export default async function GetAllHomes(server: FastifyInstance) {
  server.get(
    "/homes",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      try {
        const data = await fetchAllHomes()
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
