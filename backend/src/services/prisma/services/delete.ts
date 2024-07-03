import { prisma } from "../../../database/prisma-client"

export const deleteService = async (id: string) => {
  const result = await prisma.service.delete({
    where: {
      id
    },
    select: {
      id: true,
      description: true,
      status: true,
      animal: true,
      createdAt: true,
      updatedAt: true,
      doctors: true,
      procedures: true
    }
  })

  return result
}
