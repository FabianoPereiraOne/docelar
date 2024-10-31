"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = GetDocuments;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/documents/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function GetDocuments(server) {
    server.get("/documents/:id", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.documents.get
    }, async (request, reply) => {
        const { id } = request.params;
        try {
            const data = await (0, fetch_1.fetchDocument)({ id });
            const hasDocument = !!data;
            if (!hasDocument) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate document"
                });
            }
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
