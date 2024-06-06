import { prisma } from "../../../database/prisma-client"
import { CollaboratorParamsUpdate } from "../../../types/collaborator"

export const updateCollaborator = async ({
  id,
  name,
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
      type: true,
      statusAccount: true,
      updatedAt: true
    }
  })
}
