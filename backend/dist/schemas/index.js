"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Schemas = void 0;
const animals_1 = require("./animals");
const collaborators_1 = require("./collaborators");
const doctors_1 = require("./doctors");
const documents_1 = require("./documents");
const general_1 = require("./general");
const homes_1 = require("./homes");
const procedures_1 = require("./procedures");
const services_1 = require("./services");
const sign_1 = require("./sign");
const typesAnimals_1 = require("./typesAnimals");
exports.Schemas = {
    collaborators: collaborators_1.schemaCollaborators,
    sign: sign_1.schemaSign,
    homes: homes_1.schemaHomes,
    general: general_1.schemaGeneral,
    animals: animals_1.schemaAnimals,
    typesAnimals: typesAnimals_1.schemaTypesAnimals,
    doctors: doctors_1.schemaTypesDoctors,
    procedures: procedures_1.schemaProcedures,
    services: services_1.schemaServices,
    documents: documents_1.schemaDocuments
};
