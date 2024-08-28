export type CustomTypePost = {
  Body: {
    collaboratorId: string
    cep: string
    state: string
    city: string
    district: string
    address: string
    number: string
  }
}

export type CustomTypePatch = {
  Body: {
    id: string
    cep?: string
    state?: string
    city?: string
    district?: string
    address?: string
    number?: string
    status?: boolean
  }
}
