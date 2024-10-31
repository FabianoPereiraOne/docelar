"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDocument = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const createDocument = async ({ key, animalId, serviceId }) => {
    const animal = animalId
        ? {
            connect: {
                id: animalId
            }
        }
        : undefined;
    const service = serviceId
        ? {
            connect: {
                id: serviceId
            }
        }
        : undefined;
    const result = await prisma_client_1.prisma.document.create({
        data: {
            key,
            animal,
            service
        }
    });
    return result;
};
exports.createDocument = createDocument;
