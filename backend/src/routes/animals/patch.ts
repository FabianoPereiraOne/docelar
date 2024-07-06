import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchAnimal } from "../../services/prisma/animals/fetch"
import { updateAnimal } from "../../services/prisma/animals/update"
import { fetchHome } from "../../services/prisma/homes/fetch"
import { fetchTypeAnimal } from "../../services/prisma/typesAnimals/fetch"
import { CustomTypePatch } from "../../types/request/animals"
import { statusCode } from "../../utils/statusCode"

export default async function PatchAnimals(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/animals",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.animals.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id } = request.query
      const {
        name,
        description,
        castrated,
        dateExit,
        homeId,
        linkPhoto,
        race,
        sex,
        status,
        typeAnimalId
      } = request.body

      try {
        const hasHome = homeId != undefined ? !!(await fetchHome(homeId)) : true
        if (!hasHome) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the home"
          })
        }

        const hasTypeAnimal =
          typeAnimalId != undefined
            ? !!(await fetchTypeAnimal(typeAnimalId))
            : true
        if (!hasTypeAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the type of animal"
          })
        }

        const hasAnimal = await fetchAnimal(id)
        if (!hasAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the animal"
          })
        }

        const animal = {
          id,
          homeId,
          name,
          description,
          castrated,
          race,
          sex,
          typeAnimalId,
          dateExit,
          linkPhoto,
          status
        }
        const data = await updateAnimal(animal)
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
