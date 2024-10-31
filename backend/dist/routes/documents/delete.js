"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteDocuments;
const promises_1 = require("fs/promises");
const path_1 = __importDefault(require("path"));
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const delete_1 = require("../../services/prisma/documents/delete");
const fetch_1 = require("../../services/prisma/documents/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteDocuments(server) {
    server.delete("/documents", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.documents.delete
    }, async (request, reply) => {
        const { id } = request.query;
        try {
            const document = await (0, fetch_1.fetchDocument)({ id });
            const key = document?.key;
            const hasDocument = !!document;
            if (!hasDocument) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate document"
                });
            }
            const data = await (0, delete_1.deleteDocument)({ id });
            if (key) {
                const replacePaste = new RegExp(`^/uploads/`);
                const filePath = path_1.default.resolve(process.cwd(), "public", "uploads", key.replace(replacePaste, ""));
                await (0, promises_1.unlink)(filePath);
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
