export const postProperties = {
  body: {
    type: "object",
    required: ["name", "description", "dosage"],
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
  }
}
