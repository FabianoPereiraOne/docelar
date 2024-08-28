export type CustomTypePost = {
  Body: {
    type: string
  }
}

export type CustomTypePatch = {
  Body: {
    id: number
    type?: string
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
