export const deleteProperties = {
  querystring: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "number" }
    }
  }
}
