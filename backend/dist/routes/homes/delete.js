"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteHomes;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const delete_1 = require("../../services/prisma/homes/delete");
const fetch_1 = require("../../services/prisma/homes/fetch");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteHomes(server) {
    server.delete("/homes", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.general.delete
    }, async (request, reply) => {
        const { id } = request.query;
        try {
            const hasHome = !!(await (0, fetch_1.fetchHome)(id));
            if (!hasHome) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the home"
                });
            }
            const data = await (0, delete_1.deleteHome)(id);
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
