export type CustomTypePost = {
  Body: {
    name: string
    description: string
    dosage: string
  }
}

export type CustomTypePatch = {
  Body: {
    id: number
    name?: string
    description?: string
    dosage?: string
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
