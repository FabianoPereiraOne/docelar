"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteProcedures;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const delete_1 = require("../../services/prisma/procedures/delete");
const fetch_1 = require("../../services/prisma/procedures/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteProcedures(server) {
    server.delete("/procedures", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.procedures.delete
    }, async (request, reply) => {
        const { id } = request.query;
        try {
            const procedure = await (0, fetch_1.fetchProcedure)(id);
            const hasProcedure = !!procedure;
            if (!hasProcedure) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the procedure"
                });
            }
            const data = await (0, delete_1.deleteProcedure)(id);
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
