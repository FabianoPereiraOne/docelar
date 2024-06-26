export const patchProperties = {
  body: {
    type: "object",
    properties: {
      type: {
        type: "string"
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
