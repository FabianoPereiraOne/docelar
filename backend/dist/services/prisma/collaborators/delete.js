"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteCollaborator = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteCollaborator = async (id) => {
    return await prisma_client_1.prisma.collaborator.delete({
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
exports.deleteCollaborator = deleteCollaborator;
