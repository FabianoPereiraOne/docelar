"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostConfigDocuments = void 0;
exports.PostConfigDocuments = {
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
            required: false,
            description: "Enter the data for registration",
            schema: {
                type: "object",
                required: ["file"],
                properties: {
                    file: { type: "string", format: "binary" },
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
            description: "body must have required property 'id' \nbody/property must match pattern \n File is required.",
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
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
