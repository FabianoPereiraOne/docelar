"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postProperties = void 0;
exports.postProperties = {
    body: {
        type: "object",
        required: ["description", "procedures"],
        properties: {
            animalId: { type: "string", pattern: "\\S" },
            description: {
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
                    properties: {
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
