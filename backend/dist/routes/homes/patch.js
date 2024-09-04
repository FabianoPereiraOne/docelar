"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchHomes;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/homes/fetch");
const update_1 = require("../../services/prisma/homes/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchHomes(server) {
    server.patch("/homes", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.homes.patch
    }, async (request, reply) => {
        const { cep, address, city, number, state, status, district, id } = request.body;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Home ID is required"
            });
        }
        try {
            const hasHome = !!(await (0, fetch_1.fetchHome)(id));
            if (!hasHome) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the home"
                });
            }
            const home = {
                id,
                cep,
                address,
                city,
                district,
                number,
                state,
                status
            };
            const data = await (0, update_1.updateHome)(home);
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
