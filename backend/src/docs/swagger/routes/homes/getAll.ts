export const GetAllConfigHomes = {
  tags: ["Homes"],
  summary: "Find all temporary homes",
  description: "This route allows you to search for all temporary homes",
  produces: ["application/json"],
  operationId: "getAllHomes",
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
