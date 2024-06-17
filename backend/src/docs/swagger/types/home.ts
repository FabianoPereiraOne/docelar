export const TypeHome = {
  type: "object",
  properties: {
    data: {
      type: "object",
      properties: {
        id: {
          type: "string"
        },
        cep: {
          type: "string"
        },
        state: {
          type: "string"
        },
        city: {
          type: "string"
        },
        district: {
          type: "string"
        },
        address: {
          type: "string"
        },
        number: {
          type: "string"
        },
        status: {
          type: "boolean"
        },
        createdAt: {
          type: "string"
        },
        updateAt: {
          type: "string"
        },
        collaboratorId: {
          type: "string"
        }
      }
    }
  }
}
