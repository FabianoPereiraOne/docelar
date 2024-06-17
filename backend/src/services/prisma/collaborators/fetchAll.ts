import { prisma } from "../../../database/prisma-client"

export const fetchAllCollaborators = async () => {
  const result = await prisma.collaborator.findMany({
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

  return result
}
