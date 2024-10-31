"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypeCollaborator = void 0;
exports.TypeCollaborator = {
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
};
