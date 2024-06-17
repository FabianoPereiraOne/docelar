export type CustomTypePost = {
  Body: {
    cep: string
    state: string
    city: string
    district: string
    address: string
    number: string
  }
  Querystring: {
    collaboratorId: string
  }
}

export type CustomTypePatch = {
  Body: {
    cep?: string
    state?: string
    city?: string
    district?: string
    address?: string
    number?: string
    status?: boolean
  }
  Querystring: {
    id: string
  }
}
