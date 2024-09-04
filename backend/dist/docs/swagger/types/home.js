"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypeHome = void 0;
exports.TypeHome = {
    type: "object",
    properties: {
        data: {
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
