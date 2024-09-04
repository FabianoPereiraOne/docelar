"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useReturnDecoded = void 0;
const jwt_1 = require("../utils/jwt");
const useReturnDecoded = async (authorization) => {
    const decoded = await (0, jwt_1.verify)(authorization);
    if (typeof decoded != "string")
        return { id: decoded.id, email: decoded.email };
};
exports.useReturnDecoded = useReturnDecoded;
