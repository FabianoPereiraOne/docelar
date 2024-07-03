export const PatchConfigServices = {
  tags: ["Services"],
  summary: "Update a service",
  description: "This route allows the admin to update a service",
  produces: ["application/json"],
  operationId: "updateService",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "body",
      in: "body",
      required: false,
      description: "Enter the data for update",
      schema: {
        type: "object",
        properties: {
          description: {
            type: "string",
            example: "Esse serviço foi urgente devido a..."
          },
          status: {
            type: "boolean",
            example: false
          },
          animalId: {
            type: "string",
            example: "1e33ac81-fe39-496d-986h7-512b8843d66"
          },
          doctors: {
            type: "array",
            items: {
              type: "object",
              properties: {
                id: {
                  type: "string",
                  example: "1e33ac81-fe39-496d-986h7-512b8843d66"
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
                  type: "number",
                  example: 1
                }
              }
            }
          }
        }
      }
    },
    {
      name: "id",
      in: "query",
      required: true,
      description: "Enter service ID",
      type: "string"
    }
  ],
  responses: {
    "200": {
      description: "OK",
      schema: {
        $ref: "#/definitions/Service"
      }
    },
    "400": {
      description:
        "querystring must have required property 'id' \nbody/property must match pattern \nbody/property/0 must be object \nbody/property must NOT have fewer than 1 items\nbody/property/0/id must be number",
      error: "Bad Request"
    },
    "401": {
      description: "Collaborator not authorized for this operation",
      error: "Unauthorized"
    },
    "403": {
      description: "Token was not provided",
      error: "Forbidden"
    },
    "404": {
      description:
        "We were unable to locate the service \nWe were unable to locate the animal",
      error: "Not Found"
    },
    "409": {
      description: "Invalid doctor(s) \nInvalid procedure(s)",
      error: "Conflict"
    },
    "422": {
      description: "This token is not valid",
      error: "Unprocessable Entity"
    },
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
