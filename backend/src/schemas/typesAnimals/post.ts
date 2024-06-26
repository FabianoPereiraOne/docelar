export const postProperties = {
  body: {
    type: "object",
    required: ["type"],
    properties: {
      type: {
        type: "string"
      }
    }
  }
}
