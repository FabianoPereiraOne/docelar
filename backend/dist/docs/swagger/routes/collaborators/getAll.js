"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAllConfigCollaborators = void 0;
exports.GetAllConfigCollaborators = {
    tags: ["Collaborators"],
    summary: "Find all collaborators",
    description: "This route allows you to search for all collaborators",
    produces: ["application/json"],
    operationId: "getAllCollaborators",
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
                                    type: "string"
                                },
                                name: {
                                    type: "string"
                                },
                                email: {
                                    type: "string"
                                },
                                phone: {
                                    type: "string"
                                },
                                type: {
                                    type: "string"
                                },
                                statusAccount: {
                                    type: "boolean"
                                },
                                createdAt: {
                                    type: "string"
                                },
                                updateAt: {
                                    type: "string"
                                },
                                homes: {
                                    type: "array",
                                    items: {
                                        type: "object",
                                        properties: {
                                            id: {
                                                type: "string"
                                            },
                                            cep: {
                                                type: "string"
                                            },
                                            state: {
                                                type: "string"
                                            },
                                            city: {
                                                type: "string"
                                            },
                                            district: {
                                                type: "string"
                                            },
                                            address: {
                                                type: "string"
                                            },
                                            number: {
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
                                            collaboratorId: {
                                                type: "string"
                                            },
                                            animals: {
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
        "500": {
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
