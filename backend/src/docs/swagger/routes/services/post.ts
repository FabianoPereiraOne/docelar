export const PostConfigServices = {
  tags: ["Services"],
  summary: "Create a service",
  description: "This route allows the admin to create a service",
  produces: ["application/json"],
  operationId: "createService",
  security: [
    {
      authorization: []
    }
  ],
  parameters: [
    {
      name: "body",
      in: "body",
      required: true,
      description: "Enter the data for registration",
      schema: {
        type: "object",
        properties: {
          description: {
            type: "string",
            example: "Esse serviço foi urgente devido a..."
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
      name: "animalId",
      in: "query",
      required: true,
      description: "Enter the animal ID to link",
      type: "string"
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Service"
      }
    },
    "400": {
      description:
        "querystring or body must have required property \nbody/property must match pattern \nbody/property must NOT have fewer than 1 items\n body/property/0/id must be number \nbody/property/0 must be object",
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
      description: "We were unable to locate the animal",
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
