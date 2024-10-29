export const patchProperties = {
  body: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "number" },
      type: {
        type: "string",
        pattern: "\\S"
      }
    }
  }
}
