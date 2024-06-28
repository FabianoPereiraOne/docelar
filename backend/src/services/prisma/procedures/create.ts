import { prisma } from "../../../database/prisma-client"
import { ProcedurePostParams } from "../../../types/procedure"

export const createProcedure = async ({
  name,
  description,
  dosage
}: ProcedurePostParams) => {
  const result = await prisma.procedure.create({
    data: {
      name,
      description,
      dosage
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
