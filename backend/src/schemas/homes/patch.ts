export const patchProperties = {
  body: {
    type: "object",
    properties: {
      cep: {
        type: "string"
      },
      state: {
        type: "string"
      },
      city: {
        type: "string"
      },
      district: {
        type: "string"
      },
      address: {
        type: "string"
      },
      number: {
        type: "string"
      },
      status: {
        type: "boolean"
      }
    }
  },
  querystring: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "string" }
    }
  }
}
