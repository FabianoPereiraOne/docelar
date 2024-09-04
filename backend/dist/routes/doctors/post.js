"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PostDoctors;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const create_1 = require("../../services/prisma/doctors/create");
const statusCode_1 = require("../../utils/statusCode");
async function PostDoctors(server) {
    server.post("/doctors", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.doctors.post
    }, async (request, reply) => {
        const { address, cep, city, crmv, district, expertise, name, number, openHours, phone, socialReason, state } = request.body;
        try {
            const doctor = {
                address,
                cep,
                city,
                crmv,
                district,
                expertise,
                name,
                number,
                openHours,
                phone,
                socialReason,
                state
            };
            const data = await (0, create_1.createDoctor)(doctor);
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
