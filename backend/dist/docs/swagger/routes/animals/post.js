"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostConfigAnimals = void 0;
exports.PostConfigAnimals = {
    tags: ["Animals"],
    summary: "Create animal",
    description: "This route allows the admin to create a animal",
    produces: ["application/json"],
    operationId: "createAnimal",
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
                    homeId: {
                        type: "string",
                        example: "Enter the temporary home ID to link"
                    },
                    name: {
                        type: "string",
                        example: "Scooby"
                    },
                    description: {
                        type: "string",
                        example: "Cão Bravo"
                    },
                    sex: {
                        type: "string",
                        example: "M"
                    },
                    castrated: {
                        type: "boolean",
                        example: true
                    },
                    race: {
                        type: "string",
                        example: "Lavrador"
                    },
                    typeAnimalId: {
                        type: "number",
                        example: 1
                    }
                }
            }
        }
    ],
    responses: {
        "201": {
            description: "Created",
            schema: {
                $ref: "#/definitions/Animal"
            }
        },
        "400": {
            description: "Home ID is required.\n Body must have required property. \nBody/property must match pattern.",
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
            description: "We were unable to locate the property",
            error: "Not Found"
        },
        "422": {
            description: "This token is not valid",
            error: "Unprocessable Entity"
        },
        "500": {
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
