export const PostConfigDocuments = {
  tags: ["Documents"],
  summary: "Create a document",
  description: "This route allows the admin to create a document",
  produces: ["application/json"],
  operationId: "createDocument",
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
          key: {
            type: "string",
            example: "/uploads/name-file.jpg"
          },
          animalId: {
            type: "string",
            example: "Enter animalID (Optional)"
          },
          serviceId: {
            type: "string",
            example: "Enter service ID (Optional)"
          }
        }
      }
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Document"
      }
    },
    "400": {
      description:
        "body must have required property 'id' \nbody/property must match pattern \n Key document is required.",
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
