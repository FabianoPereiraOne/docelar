import { FastifyInstance, FastifyReply, FastifyRequest } from "fastify"
import { useReturnValidID } from "../../hooks/useReturnValidID"
import { useGetArrayEntity } from "../../hooks/useVerifyEntity"
import { OperationMiddleware } from "../../middlewares/operation"
import { Schemas } from "../../schemas"
import { fetchAnimal } from "../../services/prisma/animals/fetch"
import { fetchDoctor } from "../../services/prisma/doctors/fetch"
import { fetchProcedure } from "../../services/prisma/procedures/fetch"
import { fetchService } from "../../services/prisma/services/fetch"
import { updateService } from "../../services/prisma/services/update"
import { CustomTypePatch } from "../../types/request/services"
import { statusCode } from "../../utils/statusCode"

export default async function PatchServices(server: FastifyInstance) {
  server.patch<CustomTypePatch>(
    "/services",
    {
      preHandler: OperationMiddleware,
      schema: Schemas.services.patch
    },
    async (request: FastifyRequest<CustomTypePatch>, reply: FastifyReply) => {
      const { id } = request.query
      const { description, status, animalId, doctors, procedures } =
        request.body

      try {
        const services = await fetchService(id)
        const hasService = !!services
        if (!hasService) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the service"
          })
        }

        const hasAnimal = animalId ? !!(await fetchAnimal(animalId)) : true
        if (!hasAnimal) {
          return reply.status(statusCode.notFound.status).send({
            error: statusCode.notFound.error,
            description: "We were unable to locate the animal"
          })
        }

        const listDoctors = doctors
          ? await useGetArrayEntity({
              listEntity: doctors,
              functionGet: fetchDoctor
            })
          : []

        const listDoctorsValid = doctors ? useReturnValidID(listDoctors) : []
        const hasDoctors = doctors ? listDoctorsValid.length > 0 : true

        if (!hasDoctors) {
          return reply.status(statusCode.conflict.status).send({
            error: statusCode.conflict.error,
            description: "Invalid doctor(s)"
          })
        }

        const listProcedures = procedures
          ? await useGetArrayEntity({
              listEntity: procedures,
              functionGet: fetchProcedure
            })
          : []

        const listProceduresValid = procedures
          ? useReturnValidID(listProcedures)
          : []
        const hasProcedures = procedures ? listProceduresValid.length > 0 : true

        if (!hasProcedures) {
          return reply.status(statusCode.conflict.status).send({
            error: statusCode.conflict.error,
            description: "Invalid procedure(s)"
          })
        }

        const service = {
          id,
          description,
          animalId,
          listDoctors: listDoctorsValid,
          listProcedures: listProceduresValid,
          listDoctorsOld: services.doctors.map(doctor => doctor.id),
          listProceduresOld: services.procedures.map(procedure => procedure.id),
          status
        }

        const data = await updateService(service)
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
