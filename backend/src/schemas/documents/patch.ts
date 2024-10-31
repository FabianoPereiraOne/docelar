export const patchProperties = {
  body: {
    type: "object",
    required: ["id"],
    properties: {
      id: { type: "number" },
      animalId: {
        type: "string"
      },
      serviceId: {
        type: "string"
      }
    }
  }
}
