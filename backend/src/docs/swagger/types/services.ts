export const TypeService = {
  type: "object",
  properties: {
    data: {
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
        updateAt: {
          type: "string"
        },
        animal: {
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
            homeId: {
              type: "string"
            },
            typeAnimalId: {
              type: "number"
            }
          }
        },
        doctors: {
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
              crmv: {
                type: "string"
              },
              expertise: {
                type: "string"
              },
              phone: {
                type: "string"
              },
              socialReason: {
                type: "string"
              },
              openHours: {
                type: "string"
              },
              cep: {
                type: "string"
              },
              state: {
                type: "string"
              },
              city: {
                type: "boolean"
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
              }
            }
          }
        },
        procedures: {
          type: "array",
          items: {
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
              }
            }
          }
        },
        documents: {
          type: "array",
          items: {
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
    }
  }
}
