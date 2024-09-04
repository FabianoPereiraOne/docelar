"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchCollaborator = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchCollaborator = async (id) => {
    return await prisma_client_1.prisma.collaborator.findFirst({
        where: {
            id
        },
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
};
exports.fetchCollaborator = fetchCollaborator;
