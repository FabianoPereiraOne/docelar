"use strict"
Object.defineProperty(exports, "__esModule", { value: true })
exports.SwaggerUIDocConfig = void 0
const SwaggerUIDocConfig = () => {
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
      onRequest: function (request, reply, done) {
        done()
      },
      preHandler: function (request, reply, done) {
        done()
      }
    },
    staticCSP: false
  }
}
exports.SwaggerUIDocConfig = SwaggerUIDocConfig
