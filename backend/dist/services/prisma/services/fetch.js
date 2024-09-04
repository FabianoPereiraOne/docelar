"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchService = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchService = async (id) => {
    const result = await prisma_client_1.prisma.service.findFirst({
        where: {
            id
        },
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
exports.fetchService = fetchService;
