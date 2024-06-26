import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchTypeAnimal } from "../../services/prisma/typesAnimals/fetch"
import { updateTypeAnimal } from "../../services/prisma/typesAnimals/update"
import { CustomTypePatch } from "../../types/request/typesAnimals"
import { statusCode } from "../../utils/statusCode"

export default async function PatchTypesAnimals(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/types-animals",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.typesAnimals.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id } = request.query
      const { type } = request.body

      try {
        const hasTypeAnimal = await fetchTypeAnimal(id)
        if (!hasTypeAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the type of animal"
          })
        }

        const typeAnimal = { id: Number(id), type }

        const data = await updateTypeAnimal(typeAnimal)
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
