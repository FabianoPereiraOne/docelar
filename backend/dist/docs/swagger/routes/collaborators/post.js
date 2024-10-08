"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostConfigCollaborators = void 0;
exports.PostConfigCollaborators = {
    tags: ["Collaborators"],
    summary: "Create collaborator",
    description: "This route allows the admin to create a collaborator",
    produces: ["application/json"],
    operationId: "createCollaborator",
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
                        example: "Lucas Silva"
                    },
                    email: {
                        type: "string",
                        example: "exemplo@gmail.com"
                    },
                    phone: {
                        type: "string",
                        example: "55 33 999999999"
                    },
                    type: {
                        type: "string",
                        example: "USER"
                    }
                }
            }
        },
        {
            name: "password",
            in: "header",
            required: true,
            description: "Enter the password for registration",
            type: "string"
        }
    ],
    responses: {
        "201": {
            description: "Created",
            schema: {
                $ref: "#/definitions/Collaborator"
            }
        },
        "400": {
            description: "headers or body must have required property \nbody/property must match pattern",
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
