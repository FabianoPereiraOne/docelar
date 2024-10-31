"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = DeleteAnimals;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/animals/fetch");
const update_1 = require("../../services/prisma/animals/update");
const statusCode_1 = require("../../utils/statusCode");
async function DeleteAnimals(server) {
    server.delete("/animals", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.general.delete
    }, async (request, reply) => {
        const { id } = request.query;
        try {
            const animal = await (0, fetch_1.fetchAnimal)(id);
            const hasAnimal = !!animal;
            if (!hasAnimal) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the animal"
                });
            }
            const data = await (0, update_1.updateAnimal)({ id, status: false });
            return reply.status(statusCode_1.statusCode.success.status).send({
                data
            });
        }
        catch (error) {
            console.log(error);
            return reply.status(statusCode_1.statusCode.serverError.status).send({
                error: statusCode_1.statusCode.serverError.error,
                description: "Something unexpected happened during processing on the server"
            });
        }
    });
}
