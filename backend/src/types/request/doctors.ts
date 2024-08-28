export type CustomTypePost = {
  Body: {
    name: string
    crmv: string
    expertise: string
    phone: string
    socialReason: string
    openHours: string
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
    name?: string
    crmv?: string
    expertise?: string
    phone?: string
    socialReason?: string
    openHours?: string
    cep?: string
    state?: string
    city?: string
    district?: string
    address?: string
    number?: string
    status?: boolean
  }
}
