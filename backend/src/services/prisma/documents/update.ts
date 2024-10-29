import { prisma } from "../../../database/prisma-client"
import { DocumentPatchParams } from "../../../types/document"

export const updateDocument = async ({
  id,
  animalId,
  key,
  serviceId
}: DocumentPatchParams) => {
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

  const result = await prisma.document.update({
    where: {
      id
    },
    data: {
      key,
      animal,
      service
    }
  })

  return result
}
