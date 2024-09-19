"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAllConfigTypesAnimals = void 0;
exports.GetAllConfigTypesAnimals = {
    tags: ["Type of Animals"],
    summary: "Find all types of animals",
    description: "This route allows you to search for all type of animals",
    produces: ["application/json"],
    operationId: "getAllTypesAnimals",
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
                                    type: "number"
                                },
                                type: {
                                    type: "string"
                                },
                                createdAt: {
                                    type: "string"
                                },
                                updateAt: {
                                    type: "string"
                                },
                                animals: {
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
                                            description: {
                                                type: "string"
                                            },
                                            sex: {
                                                type: "string"
                                            },
                                            castrated: {
                                                type: "boolean"
                                            },
                                            race: {
                                                type: "string"
                                            },
                                            linkPhoto: {
                                                type: "string"
                                            },
                                            dateExit: {
                                                type: "string"
                                            },
                                            status: {
                                                type: "boolean"
                                            },
                                            createdAt: {
                                                type: "string"
                                            },
                                            updateAt: {
                                                type: "string"
                                            },
                                            homeId: {
                                                type: "string"
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
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
