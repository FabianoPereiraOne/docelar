export const postProperties = {
  headers: {
    type: "object",
    required: ["password"],
    properties: {
      password: { type: "string" }
    }
  },
  body: {
    type: "object",
    required: ["name", "email", "phone"],
    properties: {
      name: {
        type: "string",
        pattern: "\\S"
      },
      email: {
        type: "string",
        pattern: "\\S"
      },
      phone: {
        type: "string",
        pattern: "\\S"
      },
      type: {
        type: "string",
        pattern: "\\S"
      }
    }
  }
}
