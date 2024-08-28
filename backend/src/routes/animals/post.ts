import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { createAnimal } from "../../services/prisma/animals/create"
import { fetchHome } from "../../services/prisma/homes/fetch"
import { fetchTypeAnimal } from "../../services/prisma/typesAnimals/fetch"
import { CustomTypePost } from "../../types/request/animals"
import { statusCode } from "../../utils/statusCode"

export default async function PostAnimals(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/animals",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.animals.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const {
        name,
        description,
        castrated,
        race,
        sex,
        typeAnimalId,
        dateExit,
        linkPhoto,
        homeId
      } = request.body

      if (!homeId) {
        return reply.status(statusCode.badRequest.status).send({
          error: statusCode.badRequest.error,
          description: "Home ID is required"
        })
      }

      try {
        const hasHome = !!(await fetchHome(homeId))
        if (!hasHome) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the home"
          })
        }

        const hasTypeAnimal = !!(await fetchTypeAnimal(typeAnimalId))
        if (!hasTypeAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the type of animal"
          })
        }

        const animal = {
          homeId,
          name,
          description,
          castrated,
          race,
          sex,
          typeAnimalId,
          dateExit,
          linkPhoto
        }

        const data = await createAnimal(animal)
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
