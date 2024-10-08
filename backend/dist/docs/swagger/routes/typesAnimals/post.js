"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostConfigTypesAnimals = void 0;
exports.PostConfigTypesAnimals = {
    tags: ["Type of Animals"],
    summary: "Create type of animal",
    description: "This route allows the admin to create the type of animal",
    produces: ["application/json"],
    operationId: "createTypeAnimal",
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
                    type: {
                        type: "string",
                        example: "Cachorro"
                    }
                }
            }
        }
    ],
    responses: {
        "201": {
            description: "Created",
            schema: {
                $ref: "#/definitions/TypesAnimal"
            }
        },
        "400": {
            description: "body must have required property 'type' \nbody/property must match pattern",
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
