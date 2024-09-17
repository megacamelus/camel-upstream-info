# Platform-http

**Since Camel 3.0**

**Only consumer is supported**

The Platform HTTP is used to allow Camel to use the existing HTTP server
from the runtime. For example, when running Camel on Spring Boot,
Quarkus, or other runtimes.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-platform-http</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

## Platform HTTP Provider

To use Platform HTTP, a provider (engine) is required to be available on
the classpath. The purpose is to have drivers for different runtimes
such as Quarkus, or Spring Boot.

To use it with different runtimes:

Quarkus  
<dependency>  
<groupId>org.apache.camel.quarkus</groupId>  
<artifactId>camel-quarkus-platform-http</artifactId>  
<version>x.x.x</version>  
<!-- use the same version as your Camel Quarkus version -->  
</dependency>

Spring Boot  
<dependency>  
<groupId>org.apache.camel.springboot</groupId>  
<artifactId>camel-platform-http-starter</artifactId>  
<version>x.x.x</version>  
<!-- use the same version as your Camel version -->  
</dependency>

## Implementing a reverse proxy

Platform HTTP component can act as a reverse proxy. In that case, some
headers are populated from the absolute URL received on the request line
of the HTTP request. Those headers are specific to the underlining
platform.

At this moment, this feature is only supported for Quarkus implemented
in `camel-platform-http-vertx` component.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|engine|An HTTP Server engine implementation to serve the requests||object|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|path|The path under which this endpoint serves the HTTP requests, for proxy use 'proxy'||string|
|consumes|The content type this endpoint accepts as an input, such as application/xml or application/json. null or \&#42;/\&#42; mean no restriction.||string|
|cookieDomain|Sets which server can receive cookies.||string|
|cookieHttpOnly|Sets whether to prevent client side scripts from accessing created cookies.|false|boolean|
|cookieMaxAge|Sets the maximum cookie age in seconds.||integer|
|cookiePath|Sets the URL path that must exist in the requested URL in order to send the Cookie.|/|string|
|cookieSameSite|Sets whether to prevent the browser from sending cookies along with cross-site requests.|Lax|object|
|cookieSecure|Sets whether the cookie is only sent to the server with an encrypted request over HTTPS.|false|boolean|
|httpMethodRestrict|A comma separated list of HTTP methods to serve, e.g. GET,POST . If no methods are specified, all methods will be served.||string|
|matchOnUriPrefix|Whether or not the consumer should try to find a target consumer by matching the URI prefix if no exact match is found.|false|boolean|
|muteException|If enabled and an Exchange failed processing on the consumer side the response's body won't contain the exception's stack trace.|true|boolean|
|produces|The content type this endpoint produces, such as application/xml or application/json.||string|
|returnHttpRequestHeaders|Whether to include HTTP request headers (Accept, User-Agent, etc.) into HTTP response produced by this endpoint.|false|boolean|
|useCookieHandler|Whether to enable the Cookie Handler that allows Cookie addition, expiry, and retrieval (currently only supported by camel-platform-http-vertx)|false|boolean|
|useStreaming|Whether to use streaming for large requests and responses (currently only supported by camel-platform-http-vertx)|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|fileNameExtWhitelist|A comma or whitespace separated list of file extensions. Uploads having these extensions will be stored locally. Null value or asterisk () will allow all files.||string|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter headers to and from Camel message.||object|
|platformHttpEngine|An HTTP Server engine implementation to serve the requests of this endpoint.||object|
