import { prisma } from "../../../database/prisma-client"
import { DoctorParams } from "../../../types/doctor"

export const createDoctor = async ({
  name,
  crmv,
  expertise,
  phone,
  socialReason,
  cep,
  state,
  city,
  district,
  address,
  number,
  openHours
}: DoctorParams) => {
  const result = await prisma.doctor.create({
    data: {
      name,
      crmv,
      expertise,
      phone,
      socialReason,
      cep,
      state,
      city,
      district,
      address,
      number,
      openHours
    },
    select: {
      id: true,
      name: true,
      crmv: true,
      expertise: true,
      phone: true,
      socialReason: true,
      cep: true,
      state: true,
      city: true,
      district: true,
      address: true,
      number: true,
      openHours: true,
      status: true,
      createdAt: true,
      updatedAt: true,
      services: true
    }
  })

  return result
}
