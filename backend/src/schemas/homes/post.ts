export const postProperties = {
  body: {
    type: "object",
    required: ["cep", "state", "city", "address", "number"],
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
      address: {
        type: "string",
        pattern: "\\S"
      },
      number: {
        type: "string",
        pattern: "\\S"
      }
    }
  },
  querystring: {
    type: "object",
    required: ["collaboratorId"],
    properties: {
      collaboratorId: { type: "string" }
    }
  }
}
