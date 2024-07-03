import { prisma } from "../../../database/prisma-client"

export const fetchAllServices = async () => {
  const result = await prisma.service.findMany({
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
