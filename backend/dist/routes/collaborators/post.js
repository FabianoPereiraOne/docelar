"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostCollaborators;
const useGenerateHash_1 = require("../../hooks/useGenerateHash");
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const create_1 = require("../../services/prisma/collaborators/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostCollaborators(server) {
    server.post("/collaborators", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.collaborators.post
    }, async (request, reply) => {
        const { password } = request.headers;
        const { name, email, phone, type } = request.body;
        try {
            const pass = await (0, useGenerateHash_1.useGenerateHash)(password);
            const collaborator = { name, email, phone, type, password: pass };
            const data = await (0, create_1.createCollaborator)(collaborator);
            return reply.status(statusCode_1.statusCode.create.status).send({
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
