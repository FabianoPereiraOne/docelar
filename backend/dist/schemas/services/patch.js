"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.patchProperties = void 0;
exports.patchProperties = {
    body: {
        type: "object",
        properties: {
            id: { type: "string", pattern: "\\S" },
            description: {
                type: "string",
                pattern: "\\S"
            },
            status: {
                type: "boolean"
            },
            animalId: {
                type: "string",
                pattern: "\\S"
            },
            procedures: {
                type: "array",
                items: {
                    type: "object",
                    required: ["id"],
                    properties: {
                        id: {
                            type: "number"
                        }
                    }
                },
                minItems: 1
            },
            doctors: {
                type: "array",
                items: {
                    type: "object",
                    required: ["id"],
                    properties: {
                        id: {
                            type: "string",
                            pattern: "\\S"
                        }
                    }
                },
                minItems: 1
            },
            documents: {
                type: "array",
                items: {
                    type: "object",
                    required: ["id"],
                    properties: {
                        id: {
                            type: "number"
                        },
                        animalId: {
                            type: "string"
                        },
                        serviceId: {
                            type: "string"
                        },
                        key: {
                            type: "string"
                        }
                    }
                }
            }
        }
    }
};
