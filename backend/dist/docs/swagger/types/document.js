"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TypeDocument = void 0;
exports.TypeDocument = {
    type: "object",
    properties: {
        data: {
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
};
