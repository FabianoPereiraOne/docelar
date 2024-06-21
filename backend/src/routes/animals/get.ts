import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchAnimal } from "../../services/prisma/animals/fetch"
import { CustomTypeGet } from "../../types/request/general"
import { statusCode } from "../../utils/statusCode"

export default async function GetAnimals(server: FastifyInstance) {
  server.get<CustomTypeGet>(
    "/animals/:id",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.general.get
    },
    async (request: FastifyRequest<CustomTypeGet>, reply: FastifyReply) => {
      const { id } = request.params

      try {
        const data = await fetchAnimal(id)
        const hasAnimal = !!data

        if (!hasAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the animal"
          })
        }

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
