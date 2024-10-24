export const TypeAnimal = {
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
        home: {
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
            updatedAt: {
              type: "string"
            },
            collaboratorId: {
              type: "string"
            }
          }
        },
        typeAnimal: {
          type: "object",
          properties: {
            id: {
              type: "number"
            },
            type: {
              type: "string"
            }
          }
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
