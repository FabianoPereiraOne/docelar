"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteDocument = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const deleteDocument = async ({ id }) => {
    const result = await prisma_client_1.prisma.document.delete({
        where: {
            id
        }
    });
    return result;
};
exports.deleteDocument = deleteDocument;
