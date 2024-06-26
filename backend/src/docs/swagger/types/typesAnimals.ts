export const TypesAnimal = {
  type: "object",
  properties: {
    data: {
      type: "object",
      properties: {
        id: {
          type: "number"
        },
        type: {
          type: "string"
        },
        createdAt: {
          type: "string"
        },
        updateAt: {
          type: "string"
        },
        animals: {
          type: "array",
          items: {
            type: "object",
            properties: {
              id: {
                type: "string"
              },
              name: {
                type: "string"
              },
              description: {
                type: "string"
              },
              sex: {
                type: "string"
              },
              castrated: {
                type: "boolean"
              },
              race: {
                type: "string"
              },
              linkPhoto: {
                type: "string"
              },
              dateExit: {
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
              homeId: {
                type: "string"
              }
            }
          }
        }
      }
    }
  }
}
