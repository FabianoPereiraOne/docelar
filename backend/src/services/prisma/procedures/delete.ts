import { prisma } from "../../../database/prisma-client"

export const deleteProcedure = async (id: number) => {
  const result = await prisma.procedure.delete({
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
