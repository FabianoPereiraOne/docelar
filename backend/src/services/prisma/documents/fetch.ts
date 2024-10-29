import { prisma } from "../../../database/prisma-client"

export const fetchDocument = async ({ id }: { id: number }) => {
  const result = await prisma.document.findFirst({
    where: {
      id
    }
  })

  return result
}
