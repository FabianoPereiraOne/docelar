export const PostConfigDoctors = {
  tags: ["Doctors"],
  summary: "Create a doctor",
  description: "This route allows the admin to create a doctor",
  produces: ["application/json"],
  operationId: "createDoctor",
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
          name: {
            type: "string",
            example: "Dr. Magno"
          },
          crmv: {
            type: "string",
            example: "CRMV-MG 12345"
          },
          expertise: {
            type: "string",
            example: "Cirurgião"
          },
          phone: {
            type: "string",
            example: "33 999746824"
          },
          socialReason: {
            type: "string",
            example: "Clinica Veterinária S.A"
          },
          cep: {
            type: "string",
            example: "39000-000"
          },
          state: {
            type: "string",
            example: "Minas Gerais"
          },
          city: {
            type: "string",
            example: "Governador Valadares"
          },
          district: {
            type: "string",
            example: "São Paulo"
          },
          address: {
            type: "string",
            example: "Rua Joaquim Coelho"
          },
          number: {
            type: "string",
            example: "1005"
          },
          openHours: {
            type: "string",
            example: "08:00"
          }
        }
      }
    }
  ],
  responses: {
    "201": {
      description: "Created",
      schema: {
        $ref: "#/definitions/Doctor"
      }
    },
    "400": {
      description:
        "body must have required property \n body/property must match pattern '\\S'",
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
    "500": {
      description:
        "Something unexpected happened during processing on the server",
      error: "Internal Server Error"
    }
  }
}
