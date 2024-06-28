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
        type: "string",
        pattern: "\\S"
      },
      phone: {
        type: "string",
        pattern: "\\S"
      },
      statusAccount: {
        type: "boolean"
      },
      type: {
        type: "string",
        pattern: "\\S"
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
