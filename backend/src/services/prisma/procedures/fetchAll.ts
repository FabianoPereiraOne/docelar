import { prisma } from "../../../database/prisma-client"

export const fetchAllProcedures = async () => {
  const result = await prisma.procedure.findMany({
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
