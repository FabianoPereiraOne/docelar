"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.fetchAllDocuments = void 0;
const prisma_client_1 = require("../../../database/prisma-client");
const fetchAllDocuments = async () => {
    const result = await prisma_client_1.prisma.document.findMany();
    return result;
};
exports.fetchAllDocuments = fetchAllDocuments;
