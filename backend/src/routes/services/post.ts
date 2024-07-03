import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useReturnValidID } from "../../hooks/useReturnValidID"
import { useGetArrayEntity } from "../../hooks/useVerifyEntity"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchAnimal } from "../../services/prisma/animals/fetch"
import { fetchDoctor } from "../../services/prisma/doctors/fetch"
import { fetchProcedure } from "../../services/prisma/procedures/fetch"
import { createService } from "../../services/prisma/services/create"
import { CustomTypePost } from "../../types/request/services"
import { statusCode } from "../../utils/statusCode"

export default async function PostServices(server: FastifyInstance) {
  server.post<CustomTypePost>(
    "/services",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.services.post
    },
    async (request: FastifyRequest<CustomTypePost>, reply: FastifyReply) => {
      const { animalId } = request.query
      const { description, doctors, procedures } = request.body

      try {
        const hasAnimal = !!(await fetchAnimal(animalId))
        if (!hasAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the animal"
          })
        }

        const listDoctors = await useGetArrayEntity({
          listEntity: doctors,
          functionGet: fetchDoctor
        })

        const listDoctorsValid = useReturnValidID(listDoctors)
        const hasDoctors = listDoctorsValid.length > 0

        if (!hasDoctors) {
          return reply.status(statusCode.conflict.status).send({
            error: statusCode.conflict.error,
            description: "Invalid doctor(s)"
          })
        }

        const listProcedures = await useGetArrayEntity({
          listEntity: procedures,
          functionGet: fetchProcedure
        })

        const listProceduresValid = useReturnValidID(listProcedures)
        const hasProcedures = listProceduresValid.length > 0

        if (!hasProcedures) {
          return reply.status(statusCode.conflict.status).send({
            error: statusCode.conflict.error,
            description: "Invalid procedure(s)"
          })
        }

        const service = {
          description,
          animalId,
          listDoctors: listDoctorsValid,
          listProcedures: listProceduresValid
        }
        const data = await createService(service)

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
