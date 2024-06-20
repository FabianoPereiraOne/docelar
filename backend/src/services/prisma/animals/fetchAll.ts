import { prisma } from "../../../database/prisma-client"

export const fetchAllAnimals = async () => {
  const result = await prisma.animal.findMany({
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
