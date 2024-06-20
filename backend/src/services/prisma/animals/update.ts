import { prisma } from "../../../database/prisma-client"
import { updateAnimalParams } from "../../../types/animal"

export const updateAnimal = async ({
  id,
  castrated,
  dateExit,
  description,
  homeId,
  linkPhoto,
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
      linkPhoto,
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
      linkPhoto: true,
      dateExit: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      homeId: true,
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
