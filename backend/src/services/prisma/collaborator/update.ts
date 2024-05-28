import { prisma } from "../../../database/prisma-client"
import { CollaboratorParamsUpdate } from "../../../types/collaborator"

export const updateCollaborator = async ({
  id,
  name,
  email,
  password,
  phone,
  statusAccount,
  type
}: CollaboratorParamsUpdate) => {
  return await prisma.collaborator.update({
    where: {
      id
    },
    data: {
      name,
      email,
      password,
      phone,
      statusAccount,
      type
    },
    select: {
      id: true,
      name: true,
      email: true,
      phone: true,
      statusAccount: true,
      type: true,
      updatedAt: true
    }
  })
}
