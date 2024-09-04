"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SwaggerTypes = void 0;
const animal_1 = require("./animal");
const collaborator_1 = require("./collaborator");
const doctors_1 = require("./doctors");
const home_1 = require("./home");
const procedures_1 = require("./procedures");
const services_1 = require("./services");
const typesAnimals_1 = require("./typesAnimals");
exports.SwaggerTypes = {
    Collaborator: collaborator_1.TypeCollaborator,
    Home: home_1.TypeHome,
    Animal: animal_1.TypeAnimal,
    TypesAnimal: typesAnimals_1.TypesAnimal,
    Doctor: doctors_1.TypeDoctor,
    Procedure: procedures_1.TypeProcedure,
    Service: services_1.TypeService
};
