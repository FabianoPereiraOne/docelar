import { prisma } from "../../../database/prisma-client"
import { DocumentPostParams } from "../../../types/document"

export const createDocument = async ({
  key,
  animalId,
  serviceId
}: DocumentPostParams) => {
  const animal = animalId
    ? {
        connect: {
          id: animalId
        }
      }
    : undefined

  const service = serviceId
    ? {
        connect: {
          id: serviceId
        }
      }
    : undefined

  const result = await prisma.document.create({
    data: {
      key,
      animal,
      service
    }
  })

  return result
}
