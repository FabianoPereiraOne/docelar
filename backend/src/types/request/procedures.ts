export type CustomTypePost = {
  Body: {
    name: string
    description: string
    dosage: string
  }
}

export type CustomTypePatch = {
  Body: {
    name?: string
    description?: string
    dosage?: string
  }
  Querystring: {
    id: number
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
