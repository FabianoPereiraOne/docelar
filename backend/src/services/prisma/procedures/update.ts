import { prisma } from "../../../database/prisma-client"
import { ProcedurePatchParams } from "../../../types/procedure"

export const updateProcedure = async ({
  id,
  name,
  description,
  dosage
}: ProcedurePatchParams) => {
  const result = await prisma.procedure.update({
    data: {
      name,
      description,
      dosage
    },
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
