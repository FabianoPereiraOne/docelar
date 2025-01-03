import { prisma } from "../../../database/prisma-client"

export const fetchService = async (id: string) => {
  const result = await prisma.service.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      description: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      animal: true,
      doctors: true,
      procedures: true,
      documents: true
    }
  })

  return result
}
