"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.useVerifyToken = void 0;
const fetch_1 = require("../services/prisma/collaborators/fetch");
const jwt_1 = require("../utils/jwt");
const useVerifyToken = async (token) => {
    const decodedToken = await (0, jwt_1.verify)(token);
    if (typeof decodedToken == "string")
        throw new Error("Unable to validate token");
    const result = await (0, fetch_1.fetchCollaborator)(decodedToken.id);
    return result;
};
exports.useVerifyToken = useVerifyToken;
