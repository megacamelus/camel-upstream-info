# Vertx-http

**Since Camel 3.5**

**Only producer is supported**

The [Vert.x](https://vertx.io/) HTTP component provides the capability
to produce messages to HTTP endpoints via the [Vert.x Web
Client](https://vertx.io/docs/vertx-web-client/java/).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-vertx-http</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    vertx-http:hostname[:port][/resourceUri][?options]

# Usage

The following example shows how to send a request to an HTTP endpoint.

You can override the URI configured on the `vertx-http` producer via
headers `Exchange.HTTP_URI` and `Exchange.HTTP_PATH`.

    from("direct:start")
        .to("vertx-http:https://camel.apache.org");

## URI Parameters

The `vertx-http` producer supports URI parameters to be sent to the HTTP
server. The URI parameters can either be set directly on the endpoint
URI, or as a header with the key `Exchange.HTTP_QUERY` on the message.

## Response code

Camel will handle, according to the HTTP response code:

-   Response code is in the range 100..299, Camel regards it as a
    success response.

-   Response code is in the range 300..399, Camel regards it as a
    redirection response and will throw a `HttpOperationFailedException`
    with the information.

-   Response code is 400+, Camel regards it as an external server
    failure and will throw a `HttpOperationFailedException` with the
    information.

## throwExceptionOnFailure

The option, `throwExceptionOnFailure`, can be set to `false` to prevent
the `HttpOperationFailedException` from being thrown for failed response
codes. This allows you to get any response from the remote server.

## Exceptions

`HttpOperationFailedException` exception contains the following
information:

-   The HTTP status code

-   The HTTP status line (text of the status code)

-   Redirect location if server returned a redirect

-   Response body as a `java.lang.String`, if server provided a body as
    response

## HTTP method

The following algorithm determines the HTTP method to be used:

1. Use method provided as endpoint configuration (`httpMethod`).
2. Use method provided in header (`Exchange.HTTP_METHOD`).
3. `GET` if query string is provided in header.
4. `GET` if endpoint is configured with a query string.
5. `POST` if there is data to send (body is not `null`).
6. `GET` otherwise.

## HTTP form parameters

You can send HTTP form parameters in one of two ways.

1.  Set the `Exchange.CONTENT_TYPE` header to the value
    `application/x-www-form-urlencoded` and ensure the message body is a
    `String` formatted as form variables. For example
    `param1=value1&param2=value2`.

2.  Set the message body as a
    [MultiMap](https://vertx.io/docs/apidocs/io/vertx/core/MultiMap.html)
    which allows you to configure form parameter names and values.

## Multipart form data

You can upload text or binary files by setting the message body as a
[MultipartForm](https://vertx.io/docs/apidocs/io/vertx/ext/web/multipart/MultipartForm.html).

## Customizing Vert.x Web Client options

When finer control of the Vert.x Web Client configuration is required,
you can bind a custom
[WebClientOptions](https://vertx.io/docs/apidocs/io/vertx/ext/web/client/WebClientOptions.html)
instance to the registry.

    WebClientOptions options = new WebClientOptions().setMaxRedirects(5)
        .setIdleTimeout(10)
        .setConnectTimeout(3);
    
    camelContext.getRegistry.bind("clientOptions", options);

Then reference the options on the `vertx-http` producer.

    from("direct:start")
        .to("vertx-http:http://localhost:8080?webClientOptions=#clientOptions")

## SSL

The Vert.x HTTP component supports SSL/TLS configuration through the
[Camel JSSE Configuration
Utility](#manual::camel-configuration-utilities.adoc).

It is also possible to configure SSL options by providing a custom
`WebClientOptions`.

## Session Management

Session management can be enabled via the `sessionManagement` URI
option. When enabled, an in-memory cookie store is used to track
cookies. This can be overridden by providing a custom `CookieStore` via
the `cookieStore` URI option.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|responsePayloadAsByteArray|Whether the response body should be byte or as io.vertx.core.buffer.Buffer|true|boolean|
|allowJavaSerializedObject|Whether to allow java serialization when a request has the Content-Type application/x-java-serialized-object This is disabled by default. If you enable this, be aware that Java will deserialize the incoming data from the request. This can be a potential security risk.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|vertx|To use an existing vertx instead of creating a new instance||object|
|vertxHttpBinding|A custom VertxHttpBinding which can control how to bind between Vert.x and Camel||object|
|vertxOptions|To provide a custom set of vertx options for configuring vertx||object|
|webClientOptions|To provide a custom set of options for configuring vertx web client||object|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|proxyHost|The proxy server host address||string|
|proxyPassword|The proxy server password if authentication is required||string|
|proxyPort|The proxy server port||integer|
|proxyType|The proxy server type||object|
|proxyUsername|The proxy server username if authentication is required||string|
|basicAuthPassword|The password to use for basic authentication||string|
|basicAuthUsername|The user name to use for basic authentication||string|
|bearerToken|The bearer token to use for bearer token authentication||string|
|sslContextParameters|To configure security using SSLContextParameters||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|httpUri|The HTTP URI to connect to||string|
|connectTimeout|The amount of time in milliseconds until a connection is established. A timeout value of zero is interpreted as an infinite timeout.|60000|integer|
|cookieStore|A custom CookieStore to use when session management is enabled. If this option is not set then an in-memory CookieStore is used|InMemoryCookieStore|object|
|headerFilterStrategy|A custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.|VertxHttpHeaderFilterStrategy|object|
|httpMethod|The HTTP method to use. The HttpMethod header cannot override this option if set||object|
|okStatusCodeRange|The status codes which are considered a success response. The values are inclusive. Multiple ranges can be defined, separated by comma, e.g. 200-204,209,301-304. Each range must be a single number or from-to with the dash included|200-299|string|
|responsePayloadAsByteArray|Whether the response body should be byte or as io.vertx.core.buffer.Buffer|true|boolean|
|sessionManagement|Enables session management via WebClientSession. By default the client is configured to use an in-memory CookieStore. The cookieStore option can be used to override this|false|boolean|
|throwExceptionOnFailure|Disable throwing HttpOperationFailedException in case of failed responses from the remote server|true|boolean|
|timeout|The amount of time in milliseconds after which if the request does not return any data within the timeout period a TimeoutException fails the request. Setting zero or a negative value disables the timeout.|-1|integer|
|transferException|If enabled and an Exchange failed processing on the consumer side, and if the caused Exception was sent back serialized in the response as a application/x-java-serialized-object content type. On the producer side the exception will be deserialized and thrown as is, instead of HttpOperationFailedException. The caused exception is required to be serialized. This is by default turned off. If you enable this then be aware that Camel will deserialize the incoming data from the request to a Java object, which can be a potential security risk.|false|boolean|
|useCompression|Set whether compression is enabled to handled compressed (E.g gzipped) responses|false|boolean|
|vertxHttpBinding|A custom VertxHttpBinding which can control how to bind between Vert.x and Camel.||object|
|webClientOptions|Sets customized options for configuring the Vert.x WebClient||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|proxyHost|The proxy server host address||string|
|proxyPassword|The proxy server password if authentication is required||string|
|proxyPort|The proxy server port||integer|
|proxyType|The proxy server type||object|
|proxyUsername|The proxy server username if authentication is required||string|
|basicAuthPassword|The password to use for basic authentication||string|
|basicAuthUsername|The user name to use for basic authentication||string|
|bearerToken|The bearer token to use for bearer token authentication||string|
|sslContextParameters|To configure security using SSLContextParameters||object|
