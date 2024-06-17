export const postProperties = {
  body: {
    type: "object",
    required: ["cep", "state", "city", "address", "number"],
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
      address: {
        type: "string"
      },
      number: {
        type: "string"
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
