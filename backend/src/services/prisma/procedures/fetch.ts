import { prisma } from "../../../database/prisma-client"

export const fetchProcedure = async (id: number) => {
  const result = await prisma.procedure.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      description: true,
      dosage: true,
      createdAt: true,
      updatedAt: true,
      services: true
    }
  })

  return result
}
