"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = GetAllDocuments;
const operation_1 = require("../../middlewares/operation");
const fetchAll_1 = require("../../services/prisma/documents/fetchAll");
const statusCode_1 = require("../../utils/statusCode");
async function GetAllDocuments(server) {
    server.get("/documents", {
        preHandler: operation_1.OperationMiddleware
    }, async (request, reply) => {
        try {
            const data = await (0, fetchAll_1.fetchAllDocuments)();
            return reply.status(statusCode_1.statusCode.success.status).send({
                data
            });
        }
        catch (error) {
            return reply.status(statusCode_1.statusCode.serverError.status).send({
                error: statusCode_1.statusCode.serverError.error,
                description: "Something unexpected happened during processing on the server"
            });
        }
    });
}
