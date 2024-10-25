export const TypeDocument = {
  type: "object",
  properties: {
    data: {
      type: "object",
      properties: {
        id: {
          type: "number"
        },
        key: {
          type: "string"
        },
        animalId: {
          type: "string"
        },
        serviceId: {
          type: "string"
        },
        createdAt: {
          type: "string"
        },
        updateAt: {
          type: "string"
        }
      }
    }
  }
}
