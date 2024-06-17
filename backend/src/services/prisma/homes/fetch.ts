import { prisma } from "../../../database/prisma-client"

export const fetchHome = async (id: string) => {
  const result = await prisma.home.findFirst({
    where: {
      id
    }
  })

  return result
}
