import { prisma } from "../../../database/prisma-client"
import { CollaboratorParams } from "../../../types/collaborator"

export const createCollaborator = async ({
  name,
  email,
  password,
  phone,
  type = "ADMIN"
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
      status: true,
      createdAt: true
    }
  })

  return result
}
