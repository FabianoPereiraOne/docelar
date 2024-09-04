"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createCollaborator = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createCollaborator = async ({ name, email, password, phone, type = "USER" }) => {
    const result = await prisma_client_1.prisma.collaborator.create({
        data: {
            name,
            email,
            password,
            phone,
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
    return result;
};
exports.createCollaborator = createCollaborator;
