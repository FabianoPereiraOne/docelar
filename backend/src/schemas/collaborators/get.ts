export const getProperties = {
  params: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "string", minLength: 10 }
    }
  }
}
