export type CustomTypePost = {
  Body: {
    type: string
  }
}

export type CustomTypePatch = {
  Body: {
    type?: string
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
