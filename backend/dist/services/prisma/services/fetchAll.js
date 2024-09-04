"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchAllServices = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchAllServices = async () => {
    const result = await prisma_client_1.prisma.service.findMany({
        select: {
            id: true,
            description: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            animal: true,
            doctors: true,
            procedures: true
        }
    });
    return result;
};
exports.fetchAllServices = fetchAllServices;
