export const TypeProcedure = {
  type: "object",
  properties: {
    data: {
      type: "object",
      properties: {
        id: {
          type: "number"
        },
        name: {
          type: "string"
        },
        description: {
          type: "string"
        },
        dosage: {
          type: "string"
        },
        createdAt: {
          type: "string"
        },
        updateAt: {
          type: "string"
        },
        services: {
          type: "array",
          items: {
            type: "object",
            properties: {
              id: {
                type: "string"
              },
              description: {
                type: "string"
              },
              status: {
                type: "boolean"
              },
              createdAt: {
                type: "string"
              },
              updatedAt: {
                type: "string"
              },
              animalId: {
                type: "string"
              },
              procedures: {
                type: "array",
                items: {
                  type: "object"
                }
              },
              doctors: {
                type: "array",
                items: {
                  type: "object"
                }
              }
            }
          }
        }
      }
    }
  }
}
