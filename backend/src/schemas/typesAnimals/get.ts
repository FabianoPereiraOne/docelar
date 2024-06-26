export const getProperties = {
  params: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "number", minLength: 1 }
    }
  }
}
