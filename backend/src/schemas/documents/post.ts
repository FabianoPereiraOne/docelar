export const postProperties = {
  body: {
    type: "object",
    required: ["key"],
    properties: {
      key: {
        type: "string",
        pattern: "\\S"
      },
      animalId: {
        type: "string"
      },
      serviceId: {
        type: "string"
      }
    }
  }
}
