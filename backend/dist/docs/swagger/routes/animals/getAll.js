"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetAllConfigAnimals = void 0;
exports.GetAllConfigAnimals = {
    tags: ["Animals"],
    summary: "Find all animals",
    description: "This route allows you to search for all animals",
    produces: ["application/json"],
    operationId: "getAllAnimals",
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
                                home: {
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
                                        }
                                    }
                                },
                                typeAnimal: {
                                    type: "object",
                                    properties: {
                                        id: {
                                            type: "number"
                                        },
                                        type: {
                                            type: "string"
                                        }
                                    }
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
                                },
                                documents: {
                                    type: "array",
                                    items: {
                                        type: "object",
                                        properties: {
                                            id: {
                                                type: "number"
                                            },
                                            key: {
                                                type: "string"
                                            },
                                            animalId: {
                                                type: "string"
                                            },
                                            serviceId: {
                                                type: "string"
                                            },
                                            createdAt: {
                                                type: "string"
                                            },
                                            updateAt: {
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
