"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchCollaboratorByEmail = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchCollaboratorByEmail = async (email) => {
    const result = await prisma_client_1.prisma.collaborator.findFirst({
        where: {
            email
        },
        select: {
            id: true,
            name: true,
            email: true,
            phone: true,
            type: true,
            password: true,
            statusAccount: true,
            createdAt: true,
            updatedAt: true,
            homes: true
        }
    });
    return result;
};
exports.fetchCollaboratorByEmail = fetchCollaboratorByEmail;
