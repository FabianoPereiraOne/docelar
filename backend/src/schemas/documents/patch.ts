export const patchProperties = {
  body: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "number" },
      key: {
        type: "string"
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
