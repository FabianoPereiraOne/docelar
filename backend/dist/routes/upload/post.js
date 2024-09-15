"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostUpload;
const fs_1 = require("fs");
const promises_1 = require("fs/promises");
const path_1 = __importDefault(require("path"));
const useClearString_1 = __importDefault(require("../../hooks/useClearString"));
const operation_1 = require("../../middlewares/operation");
const statusCode_1 = require("../../utils/statusCode");
const { clearString } = (0, useClearString_1.default)();
async function PostUpload(server) {
    server.post("/upload", {
        preHandler: operation_1.OperationMiddleware
    }, async (request, reply) => {
        const data = await request.file();
        if (!data) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "File is required"
            });
        }
        try {
            const timestamp = Date.now();
            const originalFileName = clearString(data?.filename);
            const fileExtension = path_1.default.extname(originalFileName);
            const fileBaseName = path_1.default.basename(originalFileName, fileExtension);
            const newFileName = `${fileBaseName}-${timestamp}${fileExtension}`;
            const filePath = path_1.default.resolve(process.cwd(), "public", "uploads", newFileName);
            const dir = path_1.default.dirname(filePath);
            await (0, promises_1.mkdir)(dir, { recursive: true });
            const fileStream = data.file;
            await new Promise((resolve, reject) => {
                const writeStream = (0, fs_1.createWriteStream)(filePath);
                fileStream.pipe(writeStream);
                writeStream.on("finish", resolve);
                writeStream.on("error", reject);
            });
            return reply.status(statusCode_1.statusCode.create.status).send({
                key: `/uploads/${newFileName}`
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
