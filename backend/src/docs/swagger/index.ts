import { SwaggerRoutes } from "./routes"
import { SwaggerTypes } from "./types"

export const SwaggerDocConfig = () => {
  return {
    swagger: {
      openapi: "3.1.1",
      exposeRoute: true,
      info: {
        title: "API Docelar",
        version: "1.0.0",
        description: "This API aims to control animals and procedures"
      },
      servers: [
        {
          url: "http://patrick.vps-kinghost.net:7001",
          description: "API Docelar"
        }
      ],
      securityDefinitions: {
        authorization: {
          type: "apiKey",
          name: "authorization",
          in: "header",
          description: "Authorization Token"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      paths: SwaggerRoutes,
      definitions: SwaggerTypes
    }
  }
}
