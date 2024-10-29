export type CustomTypePost = {
  Body: {
    key: string
    animalId?: string
    serviceId?: string
  }
}

export type CustomTypePatch = {
  Body: {
    id: number
    key?: string
    animalId?: string
    serviceId?: string
  }
}

export type CustomTypeGet = {
  Params: {
    id: number
  }
}

export type CustomTypeDelete = {
  Querystring: {
    id: number
  }
}
