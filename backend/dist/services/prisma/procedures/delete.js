"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteProcedure = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteProcedure = async (id) => {
    const result = await prisma_client_1.prisma.procedure.delete({
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
exports.deleteProcedure = deleteProcedure;
