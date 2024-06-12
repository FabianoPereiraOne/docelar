export const TypeCollaborator = {
  type: "object",
  properties: {
    data: {
      type: "object",
      properties: {
        id: {
          type: "string"
        },
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
        },
        statusAccount: {
          type: "boolean"
        },
        createdAt: {
          type: "string"
        },
        updateAt: {
          type: "string"
        },
        homes: {
          type: "array",
          items: {
            type: "object"
          }
        }
      }
    }
  }
}
