import { prisma } from "../../../database/prisma-client"

export const deleteTypeAnimal = async (id: number) => {
  const result = await prisma.typeAnimal.delete({
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
