import { prisma } from "../../../database/prisma-client"

export const fetch = async (id: string) => {
  return await prisma.collaborator.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      status: true,
      type: true,
      createdAt: true,
      Home: true
    }
  })
}
