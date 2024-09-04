"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostHomes;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/collaborators/fetch");
const create_1 = require("../../services/prisma/homes/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostHomes(server) {
    server.post("/homes", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.homes.post
    }, async (request, reply) => {
        const { cep, address, city, number, state, district, collaboratorId } = request.body;
        if (!collaboratorId) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Collaborator ID is required"
            });
        }
        try {
            const hasCollaboratorId = !!(await (0, fetch_1.fetchCollaborator)(collaboratorId));
            if (!hasCollaboratorId) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the collaborator"
                });
            }
            const home = {
                collaboratorId,
                cep,
                address,
                city,
                district,
                number,
                state
            };
            const data = await (0, create_1.createHome)(home);
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
