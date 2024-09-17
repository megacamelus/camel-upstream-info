# Platform-http-vertx.md

**Since Camel 3.2**

The camel-platform-http-vertx is a Vert.x based implementation of the
`PlatformHttp` SPI.

# Vert.x Route

This implementation will by default lookup the instance of
`VertxPlatformHttpRouter` on the registry, however, you can configure an
existing instance using the getter/setter on the
`VertxPlatformHttpEngine` class.

# Auto-detection from classpath

To use this implementation all you need to do is to add the
`camel-platform-http-vertx` dependency to the classpath, and the
platform http component should auto-detect this.

# Message Headers

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 19%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelVertxPlatformHttpAuthenticatedUser</code></p></td>
<td
style="text-align: left;"><p><code>io.vertx.ext.auth.User</code></p></td>
<td style="text-align: left;"><p>If an authenticated user is present on
the Vert.x Web <code>RoutingContext</code>, this header is populated
with a <code>User</code> object containing the
<code>Principal</code>.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelVertxPlatformHttpLocalAddress</code></p></td>
<td
style="text-align: left;"><p><code>io.vertx.core.net.SocketAddress</code></p></td>
<td style="text-align: left;"><p>The local address for the connection if
present on the Vert.x Web <code>RoutingContext</code>.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelVertxPlatformHttpRemoteAddress</code></p></td>
<td
style="text-align: left;"><p><code>io.vertx.core.net.SocketAddress</code></p></td>
<td style="text-align: left;"><p>The remote address for the connection
if present on the Vert.x Web <code>RoutingContext</code>.</p></td>
</tr>
</tbody>
</table>

Camel also populates **all** `request.parameter` and Camel also
populates **all** `request.headers`. For example, given a client request
with the URL, `\http://myserver/myserver?orderid=123`, the exchange will
contain a header named `orderid` with value `123`.

# VertxPlatformHttpServer

In addition to the implementation of the `PlatformHttp` SPI based on
Vert.x, this module provides a Vert.x based HTTP server compatible with
the `VertxPlatformHttpEngine`:

    final int port = AvailablePortFinder.getNextAvailable();
    final CamelContext context = new DefaultCamelContext();
    
    VertxPlatformHttpServerConfiguration conf = new VertxPlatformHttpServerConfiguration();
    conf.setBindPort(port);
    
    context.addService(new VertxPlatformHttpServer(conf));
    context.addRoutes(new RouteBuilder() {
        @Override
        public void configure() throws Exception {
            from("platform-http:/test")
                .routeId("get")
                .setBody().constant("Hello from Camel's PlatformHttp service");
        }
    });
    
    context.start();

# Implementing a reverse proxy

Platform HTTP component can act as a reverse proxy, in that case
`Exchange.HTTP_URI`, `Exchange.HTTP_HOST` headers are populated from the
absolute URL received on the request line of the HTTP request.

Here’s an example of an HTTP proxy that simply redirects the Exchange to
the origin server.

    from("platform-http:proxy")
        .toD("http://"
            + "${headers." + Exchange.HTTP_HOST + "}");

# Access to Request and Response

The Vertx HTTP server has its own API abstraction for HTTP
request/response objects which you can access via Camel `HttpMessage` as
shown in the custom `Processor` below :

    .process(exchange -> {
        // grab the message as HttpMessage
        HttpMessage message = exchange.getMessage(HttpMessage.class);
        // use getRequest() / getResponse() to access Vertx directly
        // you can add custom headers
        message.getResponse().putHeader("beer", "Heineken");
        // also access request details and use that in the code
        String p = message.getRequest().path();
        message.setBody("request path: " + p);
    });

# Handling large request / response payloads

When large request / response payloads are expected, there is a
`useStreaming` option, which can be enabled to improve performance. When
`useStreaming` is `true`, it will take advantage of [stream
caching](#manual::stream-caching.adoc). In conjunction with enabling
disk spooling, you can avoid having to store the entire request body
payload in memory.

    // Handle a large request body and stream it to a file
    from("platform-http:/upload?httpMethodRestrict=POST&useStreaming=true")
        .log("Processing large request body...")
        .to("file:/uploads?fileName=uploaded.txt")

# Setting up http authentication

Http authentication is disabled by default. In can be enabled by calling
`setEnabled(true)` of `AuthenticationConfig`. Default http
authentication takes http-basic credentials and compares them with those
provided in camel-platform-http-vertx-auth.properties file. To be more
specific, default http authentication

To set up authentication, you need to create
`AuthenticationConfigEntries`, as shown in the example below. This
example uses Vert.x
[BasicAuthHandler](https://vertx.io/docs/apidocs/io/vertx/ext/web/handler/BasicAuthHandler.html)
and
[PropertyFileAuthentication](https://vertx.io/docs/vertx-auth-properties/java/)
to configure Basic http authentication with users info stored in
`myPropFile.properties` file. Mind that in Vert.x order of adding
`AuthenticationHandlers` matters, so `AuthenticationConfigEntries` with
a more specific url path are applied first.

    final int port = AvailablePortFinder.getNextAvailable();
    final CamelContext context = new DefaultCamelContext();
    
    VertxPlatformHttpServerConfiguration conf = new VertxPlatformHttpServerConfiguration();
    conf.setBindPort(port);
    
    //creating custom auth settings
    AuthenticationConfigEntry customEntry = new AuthenticationConfigEntry();
    AuthenticationProviderFactory provider = vertx -> PropertyFileAuthentication.create(vertx, "myPropFile.properties");
    AuthenticationHandlerFactory handler = BasicAuthHandler::create;
    customEntry.setPath("/path/that/will/be/protected");
    customEntry.setAuthenticationProviderFactory(provider);
    customEntry.setAuthenticationHandlerFactory(handler);
    
    AuthenticationConfig authenticationConfig = new AuthenticationConfig(List.of(customEntry));
    authenticationConfig.setEnabled(true);
    
    conf.setAuthenticationConfig(authenticationConfig);
    
    context.addService(new VertxPlatformHttpServer(conf));
    context.addRoutes(new RouteBuilder() {
        @Override
        public void configure() throws Exception {
            from("platform-http:/test")
                .routeId("get")
                .setBody().constant("Hello from Camel's PlatformHttp service");
        }
    });
    
    context.start();
