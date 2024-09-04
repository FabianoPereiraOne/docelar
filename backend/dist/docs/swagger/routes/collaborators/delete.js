"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeleteConfigCollaborators = void 0;
exports.DeleteConfigCollaborators = {
    tags: ["Collaborators"],
    summary: "Delete collaborator",
    description: "This route allows the admin to delete a collaborator",
    produces: ["application/json"],
    operationId: "deleteCollaboratorByID",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "id",
            in: "query",
            description: "ID Collaborator",
            required: true,
            type: "string"
        }
    ],
    responses: {
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Collaborator"
            }
        },
        "400": {
            description: "querystring must have required property 'id'",
            error: "Bad Request"
        },
        "404": {
            description: "We were unable to locate the collaborator",
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
