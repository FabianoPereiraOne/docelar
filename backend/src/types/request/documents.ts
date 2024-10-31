export type CustomTypePost = {
  Body: {
    animalId?: any
    serviceId?: any
    file: any
  }
}

export type CustomTypePatch = {
  Body: {
    id: any
    animalId?: any
    serviceId?: any
    file?: any
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
