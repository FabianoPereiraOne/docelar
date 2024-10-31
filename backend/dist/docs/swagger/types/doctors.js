"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypeDoctor = void 0;
exports.TypeDoctor = {
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
                crmv: {
                    type: "string"
                },
                expertise: {
                    type: "string"
                },
                phone: {
                    type: "string"
                },
                socialReason: {
                    type: "string"
                },
                cep: {
                    type: "string"
                },
                state: {
                    type: "string"
                },
                city: {
                    type: "boolean"
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
                openHours: {
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
};
