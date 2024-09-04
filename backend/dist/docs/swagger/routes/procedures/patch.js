"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PatchConfigProcedures = void 0;
exports.PatchConfigProcedures = {
    tags: ["Procedures"],
    summary: "Update a procedure",
    description: "This route allows the admin to update a procedure",
    produces: ["application/json"],
    operationId: "updateProcedure",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "body",
            in: "body",
            required: false,
            description: "Enter the data for update",
            schema: {
                type: "object",
                properties: {
                    id: {
                        type: "number",
                        example: 1
                    },
                    name: {
                        type: "string",
                        example: "Vacina Gripe"
                    },
                    description: {
                        type: "string",
                        example: "Protege contra o vírus da gripe canina"
                    },
                    dosage: {
                        type: "string",
                        example: "2 dose"
                    }
                }
            }
        }
    ],
    responses: {
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Procedure"
            }
        },
        "400": {
            description: "Procedure ID is required. \nBody/property must match pattern.",
            error: "Bad Request"
        },
        "401": {
            description: "Collaborator not authorized for this operation",
            error: "Unauthorized"
        },
        "403": {
            description: "Token was not provided",
            error: "Forbidden"
        },
        "404": {
            description: "We were unable to locate the procedure",
            error: "Not Found"
        },
        "422": {
            description: "This token is not valid",
            error: "Unprocessable Entity"
        },
        "500": {
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
