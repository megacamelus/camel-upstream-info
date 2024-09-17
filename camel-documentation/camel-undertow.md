# Undertow

**Since Camel 2.16**

**Both producer and consumer are supported**

The Undertow component provides HTTP and WebSocket based endpoints for
consuming and producing HTTP/WebSocket requests.

That is, the Undertow component behaves as a simple Web server. Undertow
can also be used as an HTTP client that means you can also use it with
Camel as a producer.

Since the component also supports WebSocket connections, it can serve as
a drop-in replacement for the Camel websocket component or
atmosphere-websocket component.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-undertow</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

**HTTP**

    undertow:http://hostname[:port][/resourceUri][?options]
    undertow:https://hostname[:port][/resourceUri][?options]

**WebSocket**

    undertow:ws://hostname[:port][/resourceUri][?options]
    undertow:wss://hostname[:port][/resourceUri][?options]

# Usage

## Message Headers

Camel uses the same message headers as the [HTTP](#http-component.adoc)
component. It also uses `Exchange.HTTP_CHUNKED,CamelHttpChunked` header
to turn on or turn off the chunked encoding on the camel-undertow
consumer.

Camel also populates **all** `request.parameter` and `request.headers`.
For example, given a client request with the URL,
`\http://myserver/myserver?orderid=123`, the exchange will contain a
header named `orderid` with the value `123`.

## Using localhost as host

When you specify `localhost` in a URL, Camel exposes the endpoint only
on the local TCP/IP network interface, so it cannot be accessed from
outside the machine it operates on.

If you need to expose an Undertow endpoint on a specific network
interface, the numerical IP address of this interface should be used as
the host. If you need to expose an Undertow endpoint on all network
interfaces, the `0.0.0.0` address should be used.

To listen across an entire URI prefix, see [How do I let Jetty match
wildcards?](#manual:faq:how-do-i-let-jetty-match-wildcards.adoc).

If you actually want to expose routes by HTTP and already have a
Servlet, you should instead refer to the [Servlet
Transport](#servlet-component.adoc).

## Security provider

To plug in a security provider for endpoint authentication, implement
SPI interface
`org.apache.camel.component.undertow.spi.UndertowSecurityProvider`.

Undertow component locates all implementations of
`UndertowSecurityProvider` using Java SPI (Service Provider Interfaces).
If there is an object passed to the component as parameter
`securityConfiguration` and provider accepts it. Provider will be used
for authentication of all requests.

Property `requireServletContext` of security providers forces the
Undertow server to start with servlet context. There will be no servlet
actually handled. This feature is meant only for use with servlet
filters, which needs servlet context for their functionality.

# Examples

## HTTP Producer Example

The following is a basic example of how to send an HTTP request to an
existing HTTP endpoint.

Java  
from("direct:start")
.to("undertow:http://www.google.com");

XML  
<route>  
<from uri="direct:start"/>  
<to uri="undertow:http://www.google.com"/>  
</route>

## HTTP Consumer Example

In this sample we define a route that exposes a HTTP service at
`\http://localhost:8080/myapp/myservice`:

    <route>
      <from uri="undertow:http://localhost:8080/myapp/myservice"/>
      <to uri="bean:myBean"/>
    </route>

## WebSocket Example

In this sample we define a route that exposes a WebSocket service at
`\http://localhost:8080/myapp/mysocket` and returns back a response to
the same channel:

    <route>
      <from uri="undertow:ws://localhost:8080/myapp/mysocket"/>
      <transform><simple>Echo ${body}</simple></transform>
      <to uri="undertow:ws://localhost:8080/myapp/mysocket"/>
    </route>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|muteException|If enabled and an Exchange failed processing on the consumer side the response's body won't contain the exception's stack trace.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|hostOptions|To configure common options, such as thread pools||object|
|undertowHttpBinding|To use a custom HttpBinding to control the mapping between Camel message and HttpClient.||object|
|allowedRoles|Configuration used by UndertowSecurityProvider. Comma separated list of allowed roles.||string|
|securityConfiguration|Configuration used by UndertowSecurityProvider. Security configuration object for use from UndertowSecurityProvider. Configuration is UndertowSecurityProvider specific. Each provider decides, whether it accepts configuration.||object|
|securityProvider|Security provider allows plug in the provider, which will be used to secure requests. SPI approach could be used too (component then finds security provider using SPI).||object|
|sslContextParameters|To configure security using SSLContextParameters||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|httpURI|The url of the HTTP endpoint to use.||string|
|useStreaming|For HTTP endpoint: if true, text and binary messages will be wrapped as java.io.InputStream before they are passed to an Exchange; otherwise they will be passed as byte. For WebSocket endpoint: if true, text and binary messages will be wrapped as java.io.Reader and java.io.InputStream respectively before they are passed to an Exchange; otherwise they will be passed as String and byte respectively.|false|boolean|
|accessLog|Whether or not the consumer should write access log|false|boolean|
|httpMethodRestrict|Used to only allow consuming if the HttpMethod matches, such as GET/POST/PUT etc. Multiple methods can be specified separated by comma.||string|
|matchOnUriPrefix|Whether or not the consumer should try to find a target consumer by matching the URI prefix if no exact match is found.|false|boolean|
|muteException|If enabled and an Exchange failed processing on the consumer side the response's body won't contain the exception's stack trace.|false|boolean|
|optionsEnabled|Specifies whether to enable HTTP OPTIONS for this Servlet consumer. By default OPTIONS is turned off.|false|boolean|
|transferException|If enabled and an Exchange failed processing on the consumer side and if the caused Exception was send back serialized in the response as a application/x-java-serialized-object content type. On the producer side the exception will be deserialized and thrown as is instead of the HttpOperationFailedException. The caused exception is required to be serialized. This is by default turned off. If you enable this then be aware that Java will deserialize the incoming data from the request to Java and that can be a potential security risk.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|handlers|Specifies a comma-delimited set of io.undertow.server.HttpHandler instances to lookup in your Registry. These handlers are added to the Undertow handler chain (for example, to add security). Important: You can not use different handlers with different Undertow endpoints using the same port number. The handlers is associated to the port number. If you need different handlers, then use different port numbers.||string|
|cookieHandler|Configure a cookie handler to maintain a HTTP session||object|
|keepAlive|Setting to ensure socket is not closed due to inactivity|true|boolean|
|options|Sets additional channel options. The options that can be used are defined in org.xnio.Options. To configure from endpoint uri, then prefix each option with option., such as option.close-abort=true\&option.send-buffer=8192||object|
|preserveHostHeader|If the option is true, UndertowProducer will set the Host header to the value contained in the current exchange Host header, useful in reverse proxy applications where you want the Host header received by the downstream server to reflect the URL called by the upstream client, this allows applications which use the Host header to generate accurate URL's for a proxied service.|true|boolean|
|reuseAddresses|Setting to facilitate socket multiplexing|true|boolean|
|tcpNoDelay|Setting to improve TCP protocol performance|true|boolean|
|throwExceptionOnFailure|Option to disable throwing the HttpOperationFailedException in case of failed responses from the remote server. This allows you to get all responses regardless of the HTTP status code.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|accessLogReceiver|Which Undertow AccessLogReceiver should be used Will use JBossLoggingAccessLogReceiver if not specified||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|undertowHttpBinding|To use a custom UndertowHttpBinding to control the mapping between Camel message and undertow.||object|
|allowedRoles|Configuration used by UndertowSecurityProvider. Comma separated list of allowed roles.||string|
|securityConfiguration|OConfiguration used by UndertowSecurityProvider. Security configuration object for use from UndertowSecurityProvider. Configuration is UndertowSecurityProvider specific. Each provider decides whether accepts configuration.||object|
|securityProvider|Security provider allows plug in the provider, which will be used to secure requests. SPI approach could be used too (endpoint then finds security provider using SPI).||object|
|sslContextParameters|To configure security using SSLContextParameters||object|
|fireWebSocketChannelEvents|if true, the consumer will post notifications to the route when a new WebSocket peer connects, disconnects, etc. See UndertowConstants.EVENT\_TYPE and EventType.|false|boolean|
|sendTimeout|Timeout in milliseconds when sending to a websocket channel. The default timeout is 30000 (30 seconds).|30000|integer|
|sendToAll|To send to all websocket subscribers. Can be used to configure on endpoint level, instead of having to use the UndertowConstants.SEND\_TO\_ALL header on the message.||boolean|
