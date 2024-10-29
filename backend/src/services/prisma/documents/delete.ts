import { prisma } from "../../../database/prisma-client"

export const deleteDocument = async ({ id }: { id: number }) => {
  const result = await prisma.document.delete({
    where: {
      id
    }
  })

  return result
}
