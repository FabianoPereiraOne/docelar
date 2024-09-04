"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OperationMiddleware = void 0;
const useVerifyToken_1 = require("../hooks/useVerifyToken");
const statusCode_1 = require("../utils/statusCode");
const OperationMiddleware = async (request, reply) => {
    const token = request.headers.authorization;
    const hasToken = !!token;
    const method = request.method;
    if (!hasToken) {
        return reply.status(statusCode_1.statusCode.forbidden.status).send({
            error: statusCode_1.statusCode.forbidden.error,
            description: "Token was not provided"
        });
    }
    try {
        const collaborator = await (0, useVerifyToken_1.useVerifyToken)(token);
        const isValidToken = !!collaborator;
        if (!isValidToken) {
            return reply.status(statusCode_1.statusCode.unprocessableEntity.status).send({
                error: statusCode_1.statusCode.unprocessableEntity.error,
                description: "This token is not valid"
            });
        }
        if ((method != "GET" && collaborator.type != "ADMIN") ||
            collaborator.statusAccount != true) {
            return reply.status(statusCode_1.statusCode.unAuthorized.status).send({
                error: statusCode_1.statusCode.unAuthorized.error,
                description: "Collaborator not authorized for this operation"
            });
        }
    }
    catch (error) {
        return reply.status(statusCode_1.statusCode.serverError.status).send({
            error: error?.message,
            description: "Something unexpected happened during processing on the server"
        });
    }
};
exports.OperationMiddleware = OperationMiddleware;
