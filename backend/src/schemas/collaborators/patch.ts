export const patchProperties = {
  headers: {
    type: "object",
    properties: {
      password: { type: "string" }
    }
  },
  body: {
    type: "object",
    properties: {
      name: {
        type: "string"
      },
      phone: {
        type: "string"
      },
      statusAccount: {
        type: "boolean"
      },
      type: {
        type: "string"
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
