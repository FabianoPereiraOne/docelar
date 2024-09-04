"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = GetCollaborators;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/collaborators/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function GetCollaborators(server) {
    server.get("/collaborators/:id", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.general.get
    }, async (request, reply) => {
        const { id } = request.params;
        try {
            const collaborator = await (0, fetch_1.fetchCollaborator)(id);
            const hasCollaborator = !!collaborator;
            if (!hasCollaborator) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the collaborator"
                });
            }
            return reply.status(statusCode_1.statusCode.success.status).send({
                data: collaborator
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
