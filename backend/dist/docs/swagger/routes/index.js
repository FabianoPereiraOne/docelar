"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SwaggerRoutes = void 0;
const animals_1 = require("./animals");
const get_1 = require("./animals/get");
const collaborators_1 = require("./collaborators");
const get_2 = require("./collaborators/get");
const doctors_1 = require("./doctors");
const get_3 = require("./doctors/get");
const homes_1 = require("./homes");
const get_4 = require("./homes/get");
const procedures_1 = require("./procedures");
const get_5 = require("./procedures/get");
const services_1 = require("./services");
const get_6 = require("./services/get");
const sign_1 = require("./sign");
const typesAnimals_1 = require("./typesAnimals");
const get_7 = require("./typesAnimals/get");
const upload_1 = require("./upload");
exports.SwaggerRoutes = {
    "/sign": sign_1.PathSign,
    "/collaborators": collaborators_1.PathCollaborators,
    "/homes": homes_1.PathHomes,
    "/animals": animals_1.PathAnimals,
    "/types-animals": typesAnimals_1.PathTypesAnimals,
    "/doctors": doctors_1.PathDoctors,
    "/procedures": procedures_1.PathProcedure,
    "/services": services_1.PathServices,
    "/upload": upload_1.PathUpload,
    "/collaborators/{id}": { get: get_2.GetConfigCollaborators },
    "/homes/{id}": { get: get_4.GetConfigHomes },
    "/animals/{id}": { get: get_1.GetConfigAnimals },
    "/types-animals/{id}": { get: get_7.GetConfigTypesAnimals },
    "/doctors/{id}": { get: get_3.GetConfigDoctors },
    "/procedures/{id}": { get: get_5.GetConfigProcedures },
    "/services/{id}": { get: get_6.GetConfigServices }
};
