export const patchProperties = {
  body: {
    type: "object",
    properties: {
      id: { type: "number" },
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
  }
}
