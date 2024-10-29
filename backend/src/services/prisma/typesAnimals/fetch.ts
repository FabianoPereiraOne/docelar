import { prisma } from "../../../database/prisma-client"

export const fetchTypeAnimal = async (typeAnimalId: number) => {
  const id = Number(typeAnimalId)

  const result = await prisma.typeAnimal.findFirst({
    where: {
      id
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
