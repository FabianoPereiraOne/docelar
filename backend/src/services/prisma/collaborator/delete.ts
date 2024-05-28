import { prisma } from "../../../database/prisma-client"

export const deleteCollaborator = async (id: string) => {
  return await prisma.collaborator.delete({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      statusAccount: true,
      type: true,
      createdAt: true
    }
  })
}
