import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { deleteAnimal } from "../../services/prisma/animals/delete"
import { fetchAnimal } from "../../services/prisma/animals/fetch"
import { CustomTypeDelete } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function DeleteAnimals(server: FastifyInstance) {
  server.delete<CustomTypeDelete>(
    "/animals",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.delete
    },
    async (request: FastifyRequest<CustomTypeDelete>, reply: FastifyReply) => {
      const { id } = request.query

      try {
        const animal = await fetchAnimal(id)
        const hasAnimal = !!animal
        if (!hasAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the animal"
          })
        }

        const data = await deleteAnimal(id)
        return reply.status(statusCode.success.status).send({
          data
        })
      } catch (error) {
        console.log(error)
        return reply.status(statusCode.serverError.status).send({
          error: statusCode.serverError.error,
          description:
            "Something unexpected happened during processing on the server"
        })
      }
    }
  )
}
