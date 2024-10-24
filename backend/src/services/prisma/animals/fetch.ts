import { prisma } from "../../../database/prisma-client"

export const fetchAnimal = async (id: string) => {
  const result = await prisma.animal.findFirst({
    where: {
      id
    },
    select: {
      id: true,
      name: true,
      description: true,
      sex: true,
      castrated: true,
      race: true,
      dateExit: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      home: {
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
          collaboratorId: true
        }
      },
      typeAnimal: {
        select: {
          id: true,
          type: true
        }
      },
      services: true
    }
  })

  return result
}
