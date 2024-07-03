import { prisma } from "../../../database/prisma-client"
import { ServicePatchParams } from "../../../types/service"

export const updateService = async ({
  id,
  description,
  animalId,
  status,
  listDoctors,
  listProcedures
}: ServicePatchParams) => {
  const animal = animalId
    ? {
        connect: {
          id: animalId
        }
      }
    : undefined

  const doctors = listDoctors
    ? {
        connect: listDoctors
      }
    : undefined

  const procedures = listProcedures
    ? {
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
      animal: true,
      createdAt: true,
      updatedAt: true,
      doctors: true,
      procedures: true
    }
  })

  return result
}
