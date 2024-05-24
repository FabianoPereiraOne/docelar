import { Role } from "@prisma/client"

export type Collaborator = {
  id: string
  name: string
  email: string
  phone: string
  type: string
  status: Boolean
  createdAt?: Date
  updatedAt?: Date
}

export type CollaboratorParams = {
  name: string
  email: string
  phone: string
  password: string
  type?: Role
}
