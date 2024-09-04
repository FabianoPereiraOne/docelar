"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDoctor = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createDoctor = async ({ name, crmv, expertise, phone, socialReason, cep, state, city, district, address, number, openHours }) => {
    const result = await prisma_client_1.prisma.doctor.create({
        data: {
            name,
            crmv,
            expertise,
            phone,
            socialReason,
            cep,
            state,
            city,
            district,
            address,
            number,
            openHours
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
exports.createDoctor = createDoctor;
