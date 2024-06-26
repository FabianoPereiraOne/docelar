import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchTypeAnimal } from "../../services/prisma/typesAnimals/fetch"
import { CustomTypeGet } from "../../types/request/typesAnimals"
import { statusCode } from "../../utils/statusCode"

export default async function GetTypesAnimals(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/types-animals/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.typesAnimals.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
        const data = await fetchTypeAnimal(id)
        const hasAnimal = !!data

        if (!hasAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the type of animal"
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
