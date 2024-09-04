"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = PatchDoctors;
const operation_1 = require("../../middlewares/operation");
const schemas_1 = require("../../schemas");
const fetch_1 = require("../../services/prisma/doctors/fetch");
const update_1 = require("../../services/prisma/doctors/update");
const statusCode_1 = require("../../utils/statusCode");
async function PatchDoctors(server) {
    server.patch("/doctors", {
        preHandler: operation_1.OperationMiddleware,
        schema: schemas_1.Schemas.doctors.patch
    }, async (request, reply) => {
        const { address, cep, city, crmv, district, expertise, name, number, openHours, phone, socialReason, state, status, id } = request.body;
        if (!id) {
            return reply.status(statusCode_1.statusCode.badRequest.status).send({
                error: statusCode_1.statusCode.badRequest.error,
                description: "Doctor ID is required"
            });
        }
        try {
            const hasDoctor = !!(await (0, fetch_1.fetchDoctor)(id));
            if (!hasDoctor) {
                return reply.status(statusCode_1.statusCode.notFound.status).send({
                    error: statusCode_1.statusCode.notFound.error,
                    description: "We were unable to locate the doctor"
                });
            }
            const doctor = {
                id,
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
                state,
                status
            };
            const data = await (0, update_1.updateDoctor)(doctor);
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
