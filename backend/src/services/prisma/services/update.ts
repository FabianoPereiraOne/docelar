import { prisma } from "../../../database/prisma-client"
import { ServicePatchParams } from "../../../types/service"

export const updateService = async ({
  id,
  description,
  animalId,
  status,
  listDoctors,
  listProcedures,
  listDoctorsOld,
  listProceduresOld
}: ServicePatchParams) => {
  const animal = animalId
    ? {
        connect: {
          id: animalId
        }
      }
    : undefined

  const doctors =
    listDoctors.length > 0
      ? {
          disconnect: listDoctorsOld.map(doctorID => ({
            id: doctorID
          })),
          connect: listDoctors
        }
      : undefined

  const procedures =
    listProcedures.length > 0
      ? {
          disconnect: listProceduresOld.map(procedureID => ({
            id: procedureID
          })),
          connect: listProcedures
        }
      : undefined

  const result = await prisma.service.update({
    where: {
      id
    },
    data: {
      description,
      status,
      animal,
      doctors,
      procedures
    },
    select: {
      id: true,
      description: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      animal: true,
      doctors: true,
      procedures: true,
      documents: true
    }
  })

  return result
}
