"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteDoctor = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteDoctor = async (id) => {
    const result = await prisma_client_1.prisma.doctor.delete({
        where: {
            id
        },
        select: {
            id: true,
            name: true,
            crmv: true,
            expertise: true,
            phone: true,
            socialReason: true,
            cep: true,
            state: true,
            city: true,
            district: true,
            address: true,
            number: true,
            openHours: true,
            status: true,
            createdAt: true,
            updatedAt: true,
            services: true
        }
    });
    return result;
};
exports.deleteDoctor = deleteDoctor;