"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAllConfigProcedures = void 0;
exports.GetAllConfigProcedures = {
    tags: ["Procedures"],
    summary: "Find all procedures",
    description: "This route allows you to search for all procedures",
    produces: ["application/json"],
    operationId: "getAllProcedures",
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
                                name: {
                                    type: "string"
                                },
                                description: {
                                    type: "string"
                                },
                                dosage: {
                                    type: "string"
                                },
                                createdAt: {
                                    type: "string"
                                },
                                updateAt: {
                                    type: "string"
                                },
                                services: {
                                    type: "array",
                                    items: {
                                        type: "object",
                                        properties: {
                                            id: {
                                                type: "string"
                                            },
                                            description: {
                                                type: "string"
                                            },
                                            status: {
                                                type: "boolean"
                                            },
                                            createdAt: {
                                                type: "string"
                                            },
                                            updatedAt: {
                                                type: "string"
                                            },
                                            animalId: {
                                                type: "string"
                                            },
                                            procedures: {
                                                type: "array",
                                                items: {
                                                    type: "object"
                                                }
                                            },
                                            doctors: {
                                                type: "array",
                                                items: {
                                                    type: "object"
                                                }
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
