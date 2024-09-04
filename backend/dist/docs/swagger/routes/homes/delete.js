"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeleteConfigHomes = void 0;
exports.DeleteConfigHomes = {
    tags: ["Homes"],
    summary: "Delete temporary home",
    description: "This route allows the admin to delete a temporary home",
    produces: ["application/json"],
    operationId: "deleteHomeByID",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "id",
            in: "query",
            description: "Enter the ID temporary home",
            required: true,
            type: "string"
        }
    ],
    responses: {
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Home"
            }
        },
        "400": {
            description: "querystring must have required property 'id'",
            error: "Bad Request"
        },
        "404": {
            description: "We were unable to locate the home",
            error: "Not Found"
        },
        "401": {
            description: "Collaborator not authorized for this operation",
            error: "Unauthorized"
        },
        "403": {
            description: "Token was not provided",
            error: "Forbidden"
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
