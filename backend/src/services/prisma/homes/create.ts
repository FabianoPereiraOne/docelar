import { prisma } from "../../../database/prisma-client"
import { createHomeParams } from "../../../types/home"

export const createHome = async ({
  address,
  cep,
  city,
  collaboratorId,
  number,
  district,
  state
}: createHomeParams) => {
  const result = await prisma.home.create({
    data: {
      address,
      cep,
      city,
      district,
      number,
      state,
      collaborator: {
        connect: {
          id: collaboratorId
        }
      }
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
