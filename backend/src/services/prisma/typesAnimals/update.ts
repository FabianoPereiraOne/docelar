import { prisma } from "../../../database/prisma-client"
import { updateTypeAnimalParams } from "../../../types/typeAnimal"

export const updateTypeAnimal = async ({
  id,
  type
}: updateTypeAnimalParams) => {
  const result = await prisma.typeAnimal.update({
    data: {
      type
    },
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
