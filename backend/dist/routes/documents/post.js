"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostDocuments;
const fs_1 = require("fs");
const promises_1 = require("fs/promises");
const path_1 = __importDefault(require("path"));
const useClearString_1 = __importDefault(require("../../hooks/useClearString"));
const operation_1 = require("../../middlewares/operation");
const create_1 = require("../../services/prisma/documents/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostDocuments(server) {
    server.post("/documents", {
        preHandler: operation_1.OperationMiddleware
    }, async (request, reply) => {
        const { clearString } = (0, useClearString_1.default)();
        try {
            const body = request.body;
            const animalId = body?.animalId?.value ?? undefined;
            const serviceId = body?.serviceId?.value ?? undefined;
            const files = body?.file;
            if (!files) {
                return reply.status(statusCode_1.statusCode.badRequest.status).send({
                    error: statusCode_1.statusCode.badRequest.error,
                    description: "File is required"
                });
            }
            const timestamp = Date.now();
            const originalFileName = clearString(files?.filename);
            const fileExtension = path_1.default.extname(originalFileName);
            const fileBaseName = path_1.default.basename(originalFileName, fileExtension);
            const newFileName = `${fileBaseName}-${timestamp}${fileExtension}`;
            const filePath = path_1.default.resolve(process.cwd(), "public", "uploads", newFileName);
            const dir = path_1.default.dirname(filePath);
            await (0, promises_1.mkdir)(dir, { recursive: true });
            const fileStream = await files.toBuffer();
            const key = `/uploads/${newFileName}`;
            const writeStream = (0, fs_1.createWriteStream)(filePath);
            await new Promise((resolve, reject) => {
                writeStream.write(fileStream, err => {
                    if (err) {
                        reject(err);
                    }
                    else {
                        resolve(null);
                    }
                });
                writeStream.end();
            });
            const result = await (0, create_1.createDocument)({ key, animalId, serviceId });
            return reply.status(statusCode_1.statusCode.create.status).send({
                success: statusCode_1.statusCode.create.success,
                data: result
            });
        }
        catch (error) {
            console.error(error);
            return reply.status(statusCode_1.statusCode.serverError.status).send({
                error: statusCode_1.statusCode.serverError.error,
                description: "Something unexpected happened during processing on the server"
            });
        }
    });
}
