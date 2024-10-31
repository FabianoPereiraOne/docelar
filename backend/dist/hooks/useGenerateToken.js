"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useGenerateToken = void 0;
const jwt_1 = require("../utils/jwt");
const useGenerateToken = async (id, email) => {
    const result = await (0, jwt_1.sign)({ id, email });
    return result;
};
exports.useGenerateToken = useGenerateToken;
