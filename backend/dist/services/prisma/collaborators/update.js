"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateCollaborator = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateCollaborator = async ({ id, name, password, phone, statusAccount, type }) => {
    return await prisma_client_1.prisma.collaborator.update({
        where: {
            id
        },
        data: {
            name,
            password,
            phone,
            statusAccount,
            type
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
exports.updateCollaborator = updateCollaborator;
