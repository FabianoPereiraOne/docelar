import { prisma } from "../../../database/prisma-client"

export const fetch = async (id: string) => {
  const result = await prisma.collaborator.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      status: true,
      type: true
    }
  })

  return result
}
