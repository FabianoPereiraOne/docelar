"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostConfigSign = void 0;
exports.PostConfigSign = {
    tags: ["Sign"],
    summary: "Sign-in collaborator",
    description: "This route allows the collaborator to log into the system",
    produces: ["application/json"],
    operationId: "signCollaborator",
    parameters: [
        {
            name: "body",
            in: "body",
            required: true,
            description: "Enter the email for sign-in",
            schema: {
                type: "object",
                properties: {
                    email: {
                        type: "string",
                        example: "exemplo@gmail.com"
                    }
                }
            }
        },
        {
            name: "password",
            in: "header",
            required: true,
            description: "Enter the password for sign-in",
            type: "string"
        }
    ],
    responses: {
        "200": {
            description: "Success",
            schema: {
                type: "object",
                properties: {
                    data: {
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
                                        }
                                    }
                                }
                            }
                        }
                    },
                    authorization: {
                        type: "string"
                    }
                }
            }
        },
        "401": {
            description: "The password provided is invalid",
            error: "Unauthorized"
        },
        "404": {
            description: "We were unable to locate the collaborator",
            error: "Not found"
        },
        "400": {
            description: "headers or body must have required property \nbody/property must match pattern",
            error: "Bad Request"
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
