"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchCollaborators;
const useGenerateHash_1 = require("../../hooks/useGenerateHash");
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/collaborators/fetch");
const update_1 = require("../../services/prisma/collaborators/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchCollaborators(server) {
    server.patch("/collaborators", { preHandler: operation_1.OperationMiddleware, schema: schemas_1.Schemas.collaborators.patch }, async (request, reply) => {
        const { name, phone, statusAccount, type, id } = request.body;
        const { password } = request.headers;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Collaborator ID is required"
            });
        }
        try {
            const hasCollaborator = !!(await (0, fetch_1.fetchCollaborator)(id));
            if (!hasCollaborator) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the collaborator"
                });
            }
            const pass = password != undefined ? await (0, useGenerateHash_1.useGenerateHash)(password) : undefined;
            const collaborator = {
                id,
                name,
                phone,
                type,
                statusAccount,
                password: pass
            };
            const data = await (0, update_1.updateCollaborator)(collaborator);
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
