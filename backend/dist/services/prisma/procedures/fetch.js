"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchProcedure = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchProcedure = async (id) => {
    const result = await prisma_client_1.prisma.procedure.findFirst({
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
exports.fetchProcedure = fetchProcedure;
