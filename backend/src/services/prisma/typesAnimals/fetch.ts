import { prisma } from "../../../database/prisma-client"

export const fetchTypeAnimal = async (typeAnimalId: number) => {
  const id = Number(typeAnimalId)

  const result = await prisma.typeAnimal.findFirst({
    where: {
      id
    }
  })

  return result
}
