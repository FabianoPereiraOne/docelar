import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteTypeAnimal } from "../../services/prisma/typesAnimals/delete"
import { fetchTypeAnimal } from "../../services/prisma/typesAnimals/fetch"
import { CustomTypeDelete } from "../../types/request/typesAnimals"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteTypesAnimals(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/types-animals",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.typesAnimals.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const typeAnimal = await fetchTypeAnimal(id)

        const hasTypeAnimal = !!typeAnimal
        if (!hasTypeAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the type of animal"
          })
        }

        const data = await deleteTypeAnimal(id)
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
