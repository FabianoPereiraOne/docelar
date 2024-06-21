import { prisma } from "../../../database/prisma-client"

export const fetchHome = async (id: string) => {
  const result = await prisma.home.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      cep: true,
      state: true,
      city: true,
      district: true,
      address: true,
      number: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      collaboratorId: true,
      animals: true
    }
  })

  return result
}
