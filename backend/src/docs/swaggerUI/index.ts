import { DoneFuncWithErrOrRes, FastifyReply, FastifyRequest } from "fastify"

export const SwaggerUIDocConfig = () => {
  return {
    routePrefix: "/docs",
    theme: {
      title: "API Docelar"
    },
    uiConfig: {
      docExpansion: "list",
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
    staticCSP: false
  }
}
