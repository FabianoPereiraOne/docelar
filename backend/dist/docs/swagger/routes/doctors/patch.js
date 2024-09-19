"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PatchConfigDoctors = void 0;
exports.PatchConfigDoctors = {
    tags: ["Doctors"],
    summary: "Update a doctor",
    description: "This route allows the admin to update a doctor",
    produces: ["application/json"],
    operationId: "updateDoctor",
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
                    id: {
                        type: "string",
                        example: "Enter ID the doctor"
                    },
                    name: {
                        type: "string",
                        example: "Dr. Magno"
                    },
                    crmv: {
                        type: "string",
                        example: "CRMV-MG 19845"
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
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Doctor"
            }
        },
        "400": {
            description: "Doctor ID is required. \nBody/property must match pattern.",
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
            description: "We were unable to locate the doctor",
            error: "Not Found"
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
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
