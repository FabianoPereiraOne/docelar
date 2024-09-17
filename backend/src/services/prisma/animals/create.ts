import { prisma } from "../../../database/prisma-client"
import { createAnimalParams } from "../../../types/animal"

export const createAnimal = async ({
  name,
  castrated,
  dateExit,
  description,
  homeId,
  linkPhoto,
  race,
  sex,
  typeAnimalId
}: createAnimalParams) => {
  const id = Number(typeAnimalId)

  const result = await prisma.animal.create({
    data: {
      name,
      description,
      castrated,
      dateExit,
      linkPhoto,
      race,
      sex,
      home: {
        connect: {
          id: homeId
        }
      },
      typeAnimal: {
        connect: {
          id
        }
      }
    },
    select: {
      id: true,
      name: true,
      description: true,
      sex: true,
      castrated: true,
      race: true,
      linkPhoto: true,
      dateExit: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      home: {
        select: {
          id: true,
          cep: true,
          state: true,
          city: true,
          district: true,
          address: true,
          number: true,
          status: true,
          createdAt: true,
          updatedAt: true,
          collaboratorId: true
        }
      },
      typeAnimal: {
        select: {
          id: true,
          type: true
        }
      },
      services: true
    }
  })
  return result
}
