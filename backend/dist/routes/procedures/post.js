"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostProcedures;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const create_1 = require("../../services/prisma/procedures/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostProcedures(server) {
    server.post("/procedures", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.procedures.post
    }, async (request, reply) => {
        const { name, description, dosage } = request.body;
        try {
            const procedure = { name, description, dosage };
            const data = await (0, create_1.createProcedure)(procedure);
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
