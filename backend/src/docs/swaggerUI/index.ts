import { DoneFuncWithErrOrRes, FastifyReply, FastifyRequest } from "fastify"

export const SwaggerUIDocConfig = () => {
  return {
    routePrefix: "/docs",
    theme: {
      title: "API Docelar"
    },
    uiConfig: {
      docExpansion: "full",
      deepLinking: false
    },
    uiHooks: {
      onRequest: function (
        request: FastifyRequest,
        reply: FastifyReply,
        done: DoneFuncWithErrOrRes
      ) {
        done()
      },
      preHandler: function (
        request: FastifyRequest,
        reply: FastifyReply,
        done: DoneFuncWithErrOrRes
      ) {
        done()
      }
    },
    staticCSP: true,
    transformStaticCSP: (header: any) => header,
    transformSpecification: (
      swaggerObject: any,
      request: FastifyRequest,
      reply: FastifyReply
    ) => {
      return swaggerObject
    },
    transformSpecificationClone: true
  }
}
