"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchAllCollaborators = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchAllCollaborators = async () => {
    const result = await prisma_client_1.prisma.collaborator.findMany({
        select: {
            id: true,
            name: true,
            email: true,
            phone: true,
            type: true,
            statusAccount: true,
            createdAt: true,
            updatedAt: true,
            homes: true
        }
    });
    return result;
};
exports.fetchAllCollaborators = fetchAllCollaborators;
