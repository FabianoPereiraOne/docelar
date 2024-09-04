"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getProperties = void 0;
exports.getProperties = {
    params: {
        type: "object",
        required: ["id"],
        properties: {
            id: { type: "string", minLength: 10 }
        }
    }
};
