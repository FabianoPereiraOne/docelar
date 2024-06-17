import { prisma } from "../../../database/prisma-client"

export const deleteHome = async (id: string) => {
  const result = await prisma.home.delete({
    where: {
      id
    }
  })

  return result
}
