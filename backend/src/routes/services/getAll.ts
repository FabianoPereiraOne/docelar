import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchAllServices } from "../../services/prisma/services/fetchAll"
import { statusCode } from "../../utils/statusCode"

export default async function GetAllServices(server: FastifyInstance) {
  server.get(
    "/services",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      try {
        const data = await fetchAllServices()
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
