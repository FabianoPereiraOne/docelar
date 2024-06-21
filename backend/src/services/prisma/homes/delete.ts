import { prisma } from "../../../database/prisma-client"

export const deleteHome = async (id: string) => {
  const result = await prisma.home.delete({
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
