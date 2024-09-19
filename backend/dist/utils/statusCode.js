"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.statusCode = void 0;
exports.statusCode = {
    unAuthorized: {
        status: 401,
        error: "Unauthorized"
    },
    notFound: {
        status: 404,
        error: "Not Found"
    },
    badRequest: {
        status: 400,
        error: "Bad Request"
    },
    conflict: {
        status: 409,
        error: "Conflict"
    },
    unprocessableEntity: {
        status: 422,
        error: "Unprocessable Entity"
    },
    forbidden: {
        status: 403,
        error: "Forbidden"
    },
    success: {
        status: 200,
        success: "OK"
    },
    create: {
        status: 201,
        success: "Created"
    },
    redirect: {
        status: 308,
        redirect: "Permanent Redirect"
    },
    serverError: {
        status: 500,
        error: "Internal Server Error"
    },
    tokenExpired: {
        status: 498,
        error: "Token Expired"
    }
};
