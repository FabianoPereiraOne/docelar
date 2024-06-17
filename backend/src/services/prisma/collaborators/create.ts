import { prisma } from "../../../database/prisma-client"
import { CollaboratorParams } from "../../../types/collaborator"

export const createCollaborator = async ({
  name,
  email,
  password,
  phone,
  type = "USER"
}: CollaboratorParams) => {
  const result = await prisma.collaborator.create({
    data: {
      name,
      email,
      password,
      phone,
      type
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

  return result
}
