import { Role } from "@prisma/client"

export type Collaborator = {
  id: string
  name: string
  email: string
  phone: string
  type: string
  statusAccount: Boolean
  createdAt?: Date
  updatedAt?: Date
}

export type CollaboratorParams = {
  id?: string
  name: string
  email: string
  phone: string
  password: string
  type?: Role
  statusAccount?: boolean
}

export type CollaboratorParamsUpdate = {
  id: string
  name?: string
  email?: string
  phone?: string
  password?: string
  type?: Role
  statusAccount?: boolean
}
