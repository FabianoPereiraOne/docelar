"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateDoctor = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const updateDoctor = async ({ id, address, cep, city, crmv, district, expertise, name, number, openHours, phone, socialReason, state, status }) => {
    const result = await prisma_client_1.prisma.doctor.update({
        data: {
            address,
            cep,
            city,
            crmv,
            district,
            expertise,
            name,
            number,
            openHours,
            phone,
            socialReason,
            state,
            status
        },
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
exports.updateDoctor = updateDoctor;
