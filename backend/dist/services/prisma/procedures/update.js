"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateProcedure = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateProcedure = async ({ id, name, description, dosage }) => {
    const result = await prisma_client_1.prisma.procedure.update({
        data: {
            name,
            description,
            dosage
        },
        where: {
            id
        },
        select: {
            id: true,
            name: true,
            description: true,
            dosage: true,
            createdAt: true,
            updatedAt: true,
            services: true
        }
    });
    return result;
};
exports.updateProcedure = updateProcedure;
