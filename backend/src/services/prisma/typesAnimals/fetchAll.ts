import { prisma } from "../../../database/prisma-client"

export const fetchAllTypesAnimals = async () => {
  const result = await prisma.typeAnimal.findMany({
    select: {
      id: true,
      type: true,
      createdAt: true,
      updatedAt: true,
      animals: {
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
          homeId: true
        }
      }
    }
  })

  return result
}
