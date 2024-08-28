export const patchProperties = {
  body: {
    type: "object",
    properties: {
      id: { type: "number" },
      type: {
        type: "string",
        pattern: "\\S"
      }
    }
  }
}
