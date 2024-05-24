import { prisma } from "../../database/prisma-client"

export const fetchCollaboratorByID = async (id: string) => {
  const result = await prisma.collaborator.findFirst({
    where: {
      id
    }
  })

  return result
}
