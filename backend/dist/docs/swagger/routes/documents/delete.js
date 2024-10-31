"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeleteConfigDocuments = void 0;
exports.DeleteConfigDocuments = {
    tags: ["Documents"],
    summary: "Delete document",
    description: "This route allows the admin to delete document",
    produces: ["application/json"],
    operationId: "deleteDocumentById",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "id",
            in: "query",
            description: "Enter document ID",
            required: true,
            type: "number"
        }
    ],
    responses: {
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Document"
            }
        },
        "400": {
            description: "querystring must have required property 'id'",
            error: "Bad Request"
        },
        "404": {
            description: "We were unable to locate document",
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
