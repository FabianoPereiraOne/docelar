"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Sign;
const useCompareHash_1 = require("../../hooks/useCompareHash");
const useGenerateToken_1 = require("../../hooks/useGenerateToken");
const schemas_1 = require("../../schemas");
const fetchByEmail_1 = require("../../services/prisma/collaborators/fetchByEmail");
const statusCode_1 = require("../../utils/statusCode");
async function Sign(server) {
    server.post("/sign", { schema: schemas_1.Schemas.sign.post }, async (request, reply) => {
        const { password } = request.headers;
        const { email } = request.body;
        try {
            const collaborator = await (0, fetchByEmail_1.fetchCollaboratorByEmail)(email);
            const hasCollaborator = !!collaborator;
            if (!hasCollaborator) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the collaborator"
                });
            }
            const { password: hash, id } = collaborator;
            const match = await (0, useCompareHash_1.useCompareHash)(password, hash);
            if (!match) {
                return reply.status(statusCode_1.statusCode.unAuthorized.status).send({
                    error: statusCode_1.statusCode.unAuthorized.error,
                    description: "The password provided is invalid"
                });
            }
            const authorization = await (0, useGenerateToken_1.useGenerateToken)(id, email);
            return reply.status(statusCode_1.statusCode.success.status).send({
                data: {
                    id: collaborator.id,
                    name: collaborator.name,
                    email: collaborator.email,
                    phone: collaborator.phone,
                    type: collaborator.type,
                    statusAccount: collaborator.statusAccount,
                    createdAt: collaborator.createdAt,
                    updatedAt: collaborator.updatedAt,
                    homes: collaborator.homes
                },
                authorization
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
