export const patchProperties = {
  body: {
    type: "object",
    properties: {
      cep: {
        type: "string",
        pattern: "\\S"
      },
      state: {
        type: "string",
        pattern: "\\S"
      },
      city: {
        type: "string",
        pattern: "\\S"
      },
      district: {
        type: "string",
        pattern: "\\S"
      },
      address: {
        type: "string",
        pattern: "\\S"
      },
      number: {
        type: "string",
        pattern: "\\S"
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
