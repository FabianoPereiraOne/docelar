"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchProcedures;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/procedures/fetch");
const update_1 = require("../../services/prisma/procedures/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchProcedures(server) {
    server.patch("/procedures", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.procedures.patch
    }, async (request, reply) => {
        const { name, description, dosage, id } = request.body;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Procedure ID is required"
            });
        }
        try {
            const procedure = { id, name, description, dosage };
            const hasProcedure = await (0, fetch_1.fetchProcedure)(id);
            if (!hasProcedure) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the procedure"
                });
            }
            const data = await (0, update_1.updateProcedure)(procedure);
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
