import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { createTypeAnimal } from "../../services/prisma/typesAnimals/create"
import { CustomTypePost } from "../../types/request/typesAnimals"
import { statusCode } from "../../utils/statusCode"

export default async function PostTypesAnimals(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/types-animals",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.typesAnimals.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { type } = request.body

      try {
        const data = await createTypeAnimal(type)
        return reply.status(statusCode.create.status).send({
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
