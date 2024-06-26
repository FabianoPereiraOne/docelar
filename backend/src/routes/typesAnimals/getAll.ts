import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { fetchAllTypesAnimals } from "../../services/prisma/typesAnimals/fetchAll"
import { statusCode } from "../../utils/statusCode"

export default async function GetAllTypesAnimals(server: FastifyInstance) {
  server.get(
    "/types-animals",
    {
      preHandler: OperationMiddleware
    },
    async (request: FastifyRequest, reply: FastifyReply) => {
      try {
        const data = await fetchAllTypesAnimals()
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
