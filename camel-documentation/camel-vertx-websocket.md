# Vertx-websocket

**Since Camel 3.5**

**Both producer and consumer are supported**

The [Vert.x](http://vertx.io/) WebSocket component provides WebSocket
capabilities as a WebSocket server, or as a client to connect to an
existing WebSocket.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-vertx-websocket</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    vertx-websocket://hostname[:port][/resourceUri][?options]

# Usage

The following example shows how to expose a WebSocket on
[http://localhost:8080/echo](http://localhost:8080/echo) and returns an **echo** response back to
the same channel:

    from("vertx-websocket:localhost:8080/echo")
        .transform().simple("Echo: ${body}")
        .to("vertx-websocket:localhost:8080/echo");

It’s also possible to configure the consumer to connect as a WebSocket
client on a remote address with the `consumeAsClient` option:

    from("vertx-websocket:my.websocket.com:8080/chat?consumeAsClient=true")
        .log("Got WebSocket message ${body}");

## Path \& query parameters

The WebSocket server consumer supports the configuration of
parameterized paths. The path parameter value will be set as a Camel
exchange header:

    from("vertx-websocket:localhost:8080/chat/{user}")
        .log("New message from ${header.user} >>> ${body}")

Similarly, you can retrieve any query parameter values used by the
WebSocket client to connect to the server endpoint:

    from("direct:sendChatMessage")
        .to("vertx-websocket:localhost:8080/chat/camel?role=admin");
    
    from("vertx-websocket:localhost:8080/chat/{user}")
        .log("New message from ${header.user} (${header.role}) >>> ${body}")

## Sending messages to peers connected to the vertx-websocket server consumer

This section only applies when producing messages to a WebSocket hosted
by the camel-vertx-websocket consumer. It is not relevant when producing
messages to an externally hosted WebSocket.

To send a message to all peers connected to a WebSocket hosted by the
vertx-websocket server consumer, use the `sendToAll=true` endpoint
option, or the `CamelVertxWebsocket.sendToAll` header.

    from("vertx-websocket:localhost:8080/chat")
        .log("Got WebSocket message ${body}");
    
    from("direct:broadcastMessage")
        .setBody().constant("This is a broadcast message!")
        .to("vertx-websocket:localhost:8080/chat?sendToAll=true");

Alternatively, you can send messages to specific peers by using the
`CamelVertxWebsocket.connectionKey` header. Multiple peers can be
specified as a comma separated list.

The value of the `connectionKey` can be determined whenever a peer
triggers an event on the vertx-websocket consumer, where a unique key
identifying the peer will be propagated via the
`CamelVertxWebsocket.connectionKey` header.

    from("vertx-websocket:localhost:8080/chat")
        .log("Got WebSocket message ${body}");
    
    from("direct:broadcastMessage")
        .setBody().constant("This is a broadcast message!")
        .setHeader(VertxWebsocketConstants.CONNECTION_KEY).constant("key-1,key-2,key-3")
        .to("vertx-websocket:localhost:8080/chat");

## SSL

By default, the `ws://` protocol is used, but secure connections with
`wss://` are supported by configuring the consumer or producer via the
`sslContextParameters` URI parameter and the [Camel JSSE Configuration
Utility](#manual::camel-configuration-utilities.adoc)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|allowOriginHeader|Whether the WebSocket client should add the Origin header to the WebSocket handshake request.|true|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|defaultHost|Default value for host name that the WebSocket should bind to|0.0.0.0|string|
|defaultPort|Default value for the port that the WebSocket should bind to|0|integer|
|originHeaderUrl|The value of the Origin header that the WebSocket client should use on the WebSocket handshake request. When not specified, the WebSocket client will automatically determine the value for the Origin from the request URL.||string|
|router|To provide a custom vertx router to use on the WebSocket server||object|
|vertx|To use an existing vertx instead of creating a new instance||object|
|vertxOptions|To provide a custom set of vertx options for configuring vertx||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|WebSocket hostname, such as localhost or a remote host when in client mode.||string|
|port|WebSocket port number to use.||integer|
|path|WebSocket path to use.||string|
|allowedOriginPattern|Regex pattern to match the origin header sent by WebSocket clients||string|
|allowOriginHeader|Whether the WebSocket client should add the Origin header to the WebSocket handshake request.|true|boolean|
|consumeAsClient|When set to true, the consumer acts as a WebSocket client, creating exchanges on each received WebSocket event.|false|boolean|
|fireWebSocketConnectionEvents|Whether the server consumer will create a message exchange when a new WebSocket peer connects or disconnects|false|boolean|
|handshakeHeaders|Headers to send in the HTTP handshake request. When the endpoint is a consumer, it only works when it consumes a remote host as a client (i.e. consumeAsClient is true).||object|
|maxReconnectAttempts|When consumeAsClient is set to true this sets the maximum number of allowed reconnection attempts to a previously closed WebSocket. A value of 0 (the default) will attempt to reconnect indefinitely.|0|integer|
|originHeaderUrl|The value of the Origin header that the WebSocket client should use on the WebSocket handshake request. When not specified, the WebSocket client will automatically determine the value for the Origin from the request URL.||string|
|reconnectInitialDelay|When consumeAsClient is set to true this sets the initial delay in milliseconds before attempting to reconnect to a previously closed WebSocket.|0|integer|
|reconnectInterval|When consumeAsClient is set to true this sets the interval in milliseconds at which reconnecting to a previously closed WebSocket occurs.|1000|integer|
|router|To use an existing vertx router for the HTTP server||object|
|serverOptions|Sets customized options for configuring the HTTP server hosting the WebSocket for the consumer||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|clientOptions|Sets customized options for configuring the WebSocket client used in the producer||object|
|clientSubProtocols|Comma separated list of WebSocket subprotocols that the client should use for the Sec-WebSocket-Protocol header||string|
|sendToAll|To send to all websocket subscribers. Can be used to configure at the endpoint level, instead of providing the VertxWebsocketConstants.SEND\_TO\_ALL header on the message. Note that when using this option, the host name specified for the vertx-websocket producer URI must match one used for an existing vertx-websocket consumer. Note that this option only applies when producing messages to endpoints hosted by the vertx-websocket consumer and not to an externally hosted WebSocket.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|sslContextParameters|To configure security using SSLContextParameters||object|
