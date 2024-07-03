import { prisma } from "../../../database/prisma-client"
import { ServicePostParams } from "../../../types/service"

export const createService = async ({
  description,
  animalId,
  listDoctors,
  listProcedures
}: ServicePostParams) => {
  const result = await prisma.service.create({
    data: {
      description,
      animal: {
        connect: {
          id: animalId
        }
      },
      doctors: {
        connect: listDoctors
      },
      procedures: {
        connect: listProcedures
      }
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
