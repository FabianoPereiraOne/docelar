import { prisma } from "../../../database/prisma-client"
import { CollaboratorParams } from "../../../types/collaborator"

export const update = async ({
  id,
  name = "",
  email = "",
  password = "",
  phone = "",
  status = true,
  type = "USER"
}: CollaboratorParams) => {
  return await prisma.collaborator.update({
    where: {
      id
    },
    data: {
      name,
      email,
      password,
      phone,
      status,
      type
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      status: true,
      type: true,
      updatedAt: true
    }
  })
}
