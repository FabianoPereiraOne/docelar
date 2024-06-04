export const statusCode = {
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
  }
}
