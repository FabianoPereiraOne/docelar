import { prisma } from "../../../database/prisma-client"

export const fetchCollaborator = async (id: string) => {
  return await prisma.collaborator.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      type: true,
      statusAccount: true,
      createdAt: true,
      updatedAt: true,
      homes: true
    }
  })
}
