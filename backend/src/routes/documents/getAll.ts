import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchAllDocuments } from "../../services/prisma/documents/fetchAll"
import { statusCode } from "../../utils/statusCode"

export default async function GetAllDocuments(server: FastifyInstance) {
  server.get(
    "/documents",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      try {
        const data = await fetchAllDocuments()
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
