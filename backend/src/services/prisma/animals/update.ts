import { prisma } from "../../../database/prisma-client"
import { updateAnimalParams } from "../../../types/animal"

export const updateAnimal = async ({
  id,
  castrated,
  dateExit,
  description,
  homeId,
  name,
  race,
  sex,
  status,
  typeAnimalId
}: updateAnimalParams) => {
  const home = homeId
    ? {
        connect: {
          id: homeId
        }
      }
    : undefined

  const typeAnimal = typeAnimalId
    ? {
        connect: {
          id: typeAnimalId
        }
      }
    : undefined

  const result = await prisma.animal.update({
    data: {
      castrated,
      dateExit,
      description,
      name,
      race,
      sex,
      status,
      home,
      typeAnimal
    },
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      description: true,
      sex: true,
      castrated: true,
      race: true,
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
      services: true,
      documents: true
    }
  })

  return result
}
