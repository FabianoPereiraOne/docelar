import { Role } from "@prisma/client"

export type CustomTypePost = {
  Body: {
    name: string
    email: string
    phone: string
    type?: Role
  }
  Headers: {
    password: string
  }
}

export type CustomTypePatch = {
  Body: {
    name?: string
    phone?: string
    type?: Role
    statusAccount?: boolean
  }

  Headers: {
    password?: string
  }

  Querystring: {
    id: string
  }
}
