"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeleteConfigServices = void 0;
exports.DeleteConfigServices = {
    tags: ["Services"],
    summary: "Delete a service",
    description: "This route allows the admin to delete a service",
    produces: ["application/json"],
    operationId: "deleteServiceByID",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "id",
            in: "query",
            description: "Enter service ID",
            required: true,
            type: "string"
        }
    ],
    responses: {
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Service"
            }
        },
        "400": {
            description: "querystring must have required property 'id'",
            error: "Bad Request"
        },
        "404": {
            description: "We were unable to locate the service",
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
        "498": {
            description: "The token has expired. Please refresh your token",
            error: "Token Expired"
        },
        "500": {
            description: "Something unexpected happened during processing on the server",
            error: "Internal Server Error"
        }
    }
};
