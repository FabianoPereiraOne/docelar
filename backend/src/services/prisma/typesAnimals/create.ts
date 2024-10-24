import { prisma } from "../../../database/prisma-client"

export const createTypeAnimal = async (type: string) => {
  const result = await prisma.typeAnimal.create({
    data: {
      type
    },
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
