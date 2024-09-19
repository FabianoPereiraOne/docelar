export const GetAllConfigDoctors = {
  tags: ["Doctors"],
  summary: "Find all the doctors",
  description: "This route allows you to search for all the doctors",
  produces: ["application/json"],
  operationId: "getAllDoctors",
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
                openHours: {
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
