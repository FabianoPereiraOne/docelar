export type Collaborator = {
  id: string
  name: string
  email: string
  phone: string
  type: Enumerator
  status: Boolean
  createdAt?: Date
  updatedAt?: Date
}

export type CollaboratorBody = {
  name: string
  email: string
  phone: string
}
