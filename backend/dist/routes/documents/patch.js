"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchDocuments;
const fs_1 = require("fs");
const promises_1 = require("fs/promises");
const path_1 = __importDefault(require("path"));
const useClearString_1 = __importDefault(require("../../hooks/useClearString"));
const operation_1 = require("../../middlewares/operation");
const fetch_1 = require("../../services/prisma/documents/fetch");
const update_1 = require("../../services/prisma/documents/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchDocuments(server) {
    server.patch("/documents", {
        preHandler: operation_1.OperationMiddleware
    }, async (request, reply) => {
        const { clearString } = (0, useClearString_1.default)();
        const body = request.body;
        const animalId = body?.animalId?.value ?? undefined;
        const serviceId = body?.serviceId?.value ?? undefined;
        const idQuery = body?.id?.value ?? undefined;
        const idFormatted = Number(idQuery);
        const id = isNaN(idFormatted) ? 0 : idFormatted;
        const files = body?.file;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Document ID is required."
            });
        }
        try {
            const hasDocument = await (0, fetch_1.fetchDocument)({ id });
            if (!hasDocument) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate document"
                });
            }
            if (files) {
                const keyOld = hasDocument?.key;
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
                }).then(async () => {
                    const replacePaste = new RegExp(`^/uploads/`);
                    const filePath = path_1.default.resolve(process.cwd(), "public", "uploads", keyOld.replace(replacePaste, ""));
                    await (0, promises_1.unlink)(filePath);
                });
                const data = await (0, update_1.updateDocument)({
                    id,
                    key,
                    animalId,
                    serviceId
                });
                return reply.status(statusCode_1.statusCode.success.status).send({
                    data
                });
            }
            const data = await (0, update_1.updateDocument)({
                id,
                animalId,
                serviceId
            });
            return reply.status(statusCode_1.statusCode.success.status).send({
                data
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
