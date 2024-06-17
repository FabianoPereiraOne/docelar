import { prisma } from "../../../database/prisma-client"

export const fetchCollaboratorByEmail = async (email: string) => {
  const result = await prisma.collaborator.findFirst({
    where: {
      email
    }
  })

  return result
}
