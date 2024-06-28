export const patchProperties = {
  body: {
    type: "object",
    properties: {
      name: {
        type: "string",
        pattern: "\\S"
      },
      description: {
        type: "string",
        pattern: "\\S"
      },
      dosage: {
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
