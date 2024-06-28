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
    required: ["email"],
    properties: {
      email: {
        type: "string",
        pattern: "\\S"
      }
    }
  }
}
