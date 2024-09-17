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

# Uploading and downloading files

The embedded HTTP server comes with a set of features out of the box,
that can be enabled.

These features are as follows:

-   `/q/info` - Report basic information about Camel

-   `/dev/console` - Developer console that provides a lot of statistics
    and information

-   `/q/health` - Health checks

-   `/q/jolokia` - To use Jolokia to expose JMX over HTTP REST

-   `/q/metrics` - To provide otel metrics in prometheus format

-   `/q/upload` - Uploading source files, to allow hot reloading.

-   `/q/download` - Downloading source files, to allow inspecting

-   `/q/send` - Sending messages to the Camel application via HTTP

-   `/` - Serving static content such as html, javascript, css, and
    images to make it easy to embed very small web applications.

You configure these features in the `application.properties` file using
the `camel.server.xxx` options.

# See More

-   [Platform HTTP Vert.x](#platform-http-vertx.adoc)
