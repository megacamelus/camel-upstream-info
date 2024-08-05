# Platform-http-main.md

**Since Camel 4.0**

The camel-platform-http-main is an embedded HTTP server for `camel-main`
standalone applications.

The embedded HTTP server is using VertX from the
`camel-platform-http-vertx` dependency.

# Enabling

The HTTP server for `camel-main` is disabled by default, and you need to
explicitly enable this by setting `camel.server.enabled=true` in
application.properties.

# Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-platform-http-main` dependency to the classpath. Then, the
platform http component should auto-detect this.

# See More

-   [Platform HTTP Vert.x](#platform-http-vertx.adoc)
