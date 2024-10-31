"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchHome = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchHome = async (id) => {
    const result = await prisma_client_1.prisma.home.findFirst({
        where: {
            id
        },
        select: {
            id: true,
            cep: true,
            state: true,
            city: true,
            district: true,
            address: true,
            number: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            collaboratorId: true,
            animals: true
        }
    });
    return result;
};
exports.fetchHome = fetchHome;
