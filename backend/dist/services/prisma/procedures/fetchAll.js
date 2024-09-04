"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchAllProcedures = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchAllProcedures = async () => {
    const result = await prisma_client_1.prisma.procedure.findMany({
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
exports.fetchAllProcedures = fetchAllProcedures;
