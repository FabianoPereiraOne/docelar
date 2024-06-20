import { prisma } from "../../../database/prisma-client"

export const fetchCollaboratorByEmail = async (email: string) => {
  const result = await prisma.collaborator.findFirst({
    where: {
      email
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      type: true,
      password: true,
      statusAccount: true,
      createdAt: true,
      updatedAt: true,
      homes: true
    }
  })

  return result
}
