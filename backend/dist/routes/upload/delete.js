"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteUpload;
const promises_1 = require("fs/promises");
const path_1 = __importDefault(require("path"));
const operation_1 = require("../../middlewares/operation");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteUpload(server) {
    server.delete("/upload", {
        preHandler: operation_1.OperationMiddleware
    }, async (request, reply) => {
        const { key } = request.query;
        if (!key) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "File key is required."
            });
        }
        try {
            const replacePaste = new RegExp(`^/uploads/`);
            const filePath = path_1.default.resolve(process.cwd(), "public", "uploads", key.replace(replacePaste, ""));
            await (0, promises_1.unlink)(filePath);
            return reply
                .status(statusCode_1.statusCode.success.status)
                .send({ success: "File deleted successfully." });
        }
        catch (error) {
            return reply.status(statusCode_1.statusCode.serverError.status).send({
                error: statusCode_1.statusCode.serverError.error,
                description: "Something unexpected happened during processing on the server"
            });
        }
    });
}
