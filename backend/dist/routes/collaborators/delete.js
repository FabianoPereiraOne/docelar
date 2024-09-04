"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteCollaborators;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const delete_1 = require("../../services/prisma/collaborators/delete");
const fetch_1 = require("../../services/prisma/collaborators/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteCollaborators(server) {
    server.delete("/collaborators", { preHandler: operation_1.OperationMiddleware, schema: schemas_1.Schemas.general.delete }, async (request, reply) => {
        const { id } = request.query;
        try {
            const collaborator = await (0, fetch_1.fetchCollaborator)(id);
            const hasCollaborator = !!collaborator;
            if (!hasCollaborator) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the collaborator"
                });
            }
            // const dataDelete = { id, statusAccount: false, type: Role.USER }
            // const data = await updateCollaborator(dataDelete)
            const data = await (0, delete_1.deleteCollaborator)(id);
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
