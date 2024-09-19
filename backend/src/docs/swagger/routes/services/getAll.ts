export const GetAllConfigServices = {
  tags: ["Services"],
  summary: "Find all the services",
  description: "This route allows you to search for all the services",
  produces: ["application/json"],
  operationId: "getAllServices",
  security: [
    {
      authorization: []
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        type: "object",
        properties: {
          data: {
            type: "array",
            items: {
              type: "object",
              properties: {
                id: {
                  type: "number"
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
                }
              }
            }
          }
        }
      }
    },
    "403": {
      description: "Token was not provided",
      error: "Forbidden"
    },
    "422": {
      description: "This token is not valid",
      error: "Unprocessable Entity"
    },
    "498": {
      description: "The token has expired. Please refresh your token",
      error: "Token Expired"
    },
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
