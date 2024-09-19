"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetConfigDoctors = void 0;
exports.GetConfigDoctors = {
    tags: ["Doctors"],
    summary: "Search for a doctor",
    description: "This route allows you to search for a doctor by ID",
    produces: ["application/json"],
    operationId: "getDoctorByID",
    security: [
        {
            authorization: []
        }
    ],
    parameters: [
        {
            name: "id",
            in: "path",
            description: "doctor ID",
            required: true,
            type: "string"
        }
    ],
    responses: {
        "200": {
            description: "OK",
            schema: {
                $ref: "#/definitions/Doctor"
            }
        },
        "400": {
            description: "params/id must NOT have fewer than 10 characters",
            error: "Bad Request"
        },
        "404": {
            description: "We were unable to locate the doctor",
            error: "Not Found"
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
