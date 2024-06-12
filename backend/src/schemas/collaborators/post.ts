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
        type: "string"
      },
      email: {
        type: "string"
      },
      phone: {
        type: "string"
      },
      type: {
        type: "string"
      }
    }
  }
}
