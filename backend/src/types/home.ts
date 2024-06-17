export type createHomeParams = {
  collaboratorId: string | undefined
  cep: string
  address: string
  city: string
  district: string
  number: string
  state: string
}

export type updateHomeParams = {
  id: string
  cep?: string
  address?: string
  city?: string
  district?: string
  number?: string
  state?: string
  status?: boolean
}
