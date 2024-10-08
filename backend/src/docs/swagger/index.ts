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
      securityDefinitions: {
        authorization: {
          type: "apiKey",
          name: "authorization",
          in: "header",
          description: "Authorization Token"
        }
      },
      servers: [
        {
          url: "http://patrick.vps-kinghost.net:7001",
          description: "Ambiente de Produção"
        },
        {
          url: "http://localhost:7001",
          description: "Ambiente de Desenvolvimento"
        }
      ],
      externalDocs: {
        url: "https://swagger.io",
        description: "Descubra mais"
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      paths: SwaggerRoutes,
      definitions: SwaggerTypes
    }
  }
}
