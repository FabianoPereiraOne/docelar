"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostConfigUpload = void 0;
exports.PostConfigUpload = {
    tags: ["Upload"],
    summary: "Upload File",
    description: "This route allows the administrator to upload files",
    produces: ["multipart/form-data"],
    operationId: "uploadFiles",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "body",
            in: "body",
            required: true,
            description: "Enter the data for upload",
            schema: {
                type: "object",
                properties: {
                    file: {
                        type: "object",
                        format: "binary"
                    }
                }
            }
        }
    ],
    responses: {
        "201": {
            description: "Created",
            schema: {
                type: "object",
                properties: {
                    key: {
                        type: "string",
                        example: "/uploads/file-name.file"
                    }
                }
            }
        },
        "400": {
            description: "File is required",
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
