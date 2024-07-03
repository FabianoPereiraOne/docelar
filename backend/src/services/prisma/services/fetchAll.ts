import { prisma } from "../../../database/prisma-client"

export const fetchAllServices = async () => {
  const result = await prisma.service.findMany({
    select: {
      id: true,
      description: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      animal: true,
      doctors: true,
      procedures: true
    }
  })

  return result
}
