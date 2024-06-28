export const patchProperties = {
  body: {
    type: "object",
    properties: {
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
      id: { type: "number" }
    }
  }
}
