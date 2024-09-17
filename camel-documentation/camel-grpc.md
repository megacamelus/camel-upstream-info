# Grpc

**Since Camel 2.19**

**Both producer and consumer are supported**

The gRPC component allows you to call or expose Remote Procedure Call
(RPC) services using [Protocol Buffers
(protobuf)](https://developers.google.com/protocol-buffers/docs/overview)
exchange format over HTTP/2 transport.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-grpc</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    grpc:host:port/service[?options]

# Usage

## Transport security and authentication support

The following [authentication](https://grpc.io/docs/guides/auth.html)
mechanisms are built-in to gRPC and available in this component:

-   **SSL/TLS:** gRPC has SSL/TLS integration and promotes the use of
    SSL/TLS to authenticate the server, and to encrypt all the data
    exchanged between the client and the server. Optional mechanisms are
    available for clients to provide certificates for mutual
    authentication.

-   **Token-based authentication with Google:** gRPC provides a generic
    mechanism to attach metadata-based credentials to requests and
    responses. Additional support for acquiring access tokens while
    accessing Google APIs through gRPC is provided. In general, this
    mechanism must be used as well as SSL/TLS on the channel.

To enable these features, the following component properties
combinations must be configured:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 19%" />
<col style="width: 24%" />
<col style="width: 15%" />
<col style="width: 30%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Num.</th>
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Parameter</th>
<th style="text-align: left;">Value</th>
<th style="text-align: left;">Required/Optional</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>1</p></td>
<td style="text-align: left;"><p><strong>SSL/TLS</strong></p></td>
<td style="text-align: left;"><p>negotiationType</p></td>
<td style="text-align: left;"><p>TLS</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>keyCertChainResource</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>keyResource</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>keyPassword</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Optional</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>trustCertCollectionResource</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Optional</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>2</p></td>
<td style="text-align: left;"><p><strong>Token-based authentication with
Google API</strong></p></td>
<td style="text-align: left;"><p>authenticationType</p></td>
<td style="text-align: left;"><p>GOOGLE</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>negotiationType</p></td>
<td style="text-align: left;"><p>TLS</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>serviceAccountResource</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>3</p></td>
<td style="text-align: left;"><p><strong>Custom JSON Web Token
implementation authentication</strong></p></td>
<td style="text-align: left;"><p>authenticationType</p></td>
<td style="text-align: left;"><p>JWT</p></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>negotiationType</p></td>
<td style="text-align: left;"><p>NONE or TLS</p></td>
<td style="text-align: left;"><p>Optional. The TLS/SSL not checking for
this type, but strongly recommended.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>jwtAlgorithm</p></td>
<td style="text-align: left;"><p>HMAC256(default) or
(HMAC384,HMAC512)</p></td>
<td style="text-align: left;"><p>Optional</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>jwtSecret</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Required</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>jwtIssuer</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Optional</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>jwtSubject</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Optional</p></td>
</tr>
</tbody>
</table>

## gRPC producer resource type mapping

The table below shows the types of objects in the message body,
depending on the types (simple or stream) of incoming and outgoing
parameters, as well as the invocation style (synchronous or
asynchronous). Please note that invocation of the procedures with
incoming stream parameter in asynchronous style is not allowed.

<table>
<colgroup>
<col style="width: 15%" />
<col style="width: 15%" />
<col style="width: 15%" />
<col style="width: 26%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Invocation style</th>
<th style="text-align: left;">Request type</th>
<th style="text-align: left;">Response type</th>
<th style="text-align: left;">Request Body Type</th>
<th style="text-align: left;">Result Body Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>synchronous</strong></p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>synchronous</strong></p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>synchronous</p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>not allowed</p></td>
<td style="text-align: left;"><p>not allowed</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>synchronous</p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>not allowed</p></td>
<td style="text-align: left;"><p>not allowed</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><strong>asynchronous</strong></p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>asynchronous</strong></p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><strong>asynchronous</strong></p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>simple</p></td>
<td style="text-align: left;"><p>Object or List&lt;Object&gt;</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>asynchronous</strong></p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>stream</p></td>
<td style="text-align: left;"><p>Object or List&lt;Object&gt;</p></td>
<td style="text-align: left;"><p>List&lt;Object&gt;</p></td>
</tr>
</tbody>
</table>

## gRPC Proxy

It is not possible to create a universal proxy-route for all methods, so
you need to divide your gRPC service into several services by method’s
type: unary, server streaming, client streaming and bidirectional
streaming.

### Unary

For unary requests, it is enough to write the following code:

    from("grpc://localhost:1101" +
        "/org.apache.camel.component.grpc.PingPong"
    )
        .toD("grpc://remotehost:1101" +
            "/org.apache.camel.component.grpc.PingPong" +
            "?method=${header.CamelGrpcMethodName}"
        )

## Server streaming

Server streaming may be done by the same approach as unary, but in that
configuration Camel route will wait stream for completion and will
aggregate all responses to a list before sending that data as response
stream. If this behavior is unacceptable, you need to apply a number of
options:

1.  Set `routeControlledStreamObserver=true` for consumer. Later it will
    be used to publish responses;

2.  Set `streamRepliesTo` option for producer to handle streaming nature
    of responses;

3.  Set forwarding of `onError` and `onCompleted` for producer;

4.  Set `inheritExchangePropertiesForReplies=true` to inherit
    `StreamObserver` obtained on the first step;

5.  Create another route to process streamed data. That route must
    contain gRPC-producer step with the only parameter
    `toRouteControlledStreamObserver=true` which will publish incoming
    exchanges as response stream elements.

Example:

    from("grpc://localhost:1101" +
        "/org.apache.camel.component.grpc.PingPong" +
        "?routeControlledStreamObserver=true"
    )
        .toD("grpc://remotehost:1101" +
                "/org.apache.camel.component.grpc.PingPong" +
                "?method=${header.CamelGrpcMethodName}" +
                "&streamRepliesTo=direct:next" +
                "&forwardOnError=true" +
                "&forwardOnCompleted=true" +
                "&inheritExchangePropertiesForReplies=true"
        );
    
    from("direct:next")
            .to("grpc://dummy:0/?toRouteControlledStreamObserver=true");

## Client streaming and bidirectional streaming

Both client streaming and bidirectional streaming gRPC methods expose
‘StreamObserver\` as responses’ handler. Therefore, you need the same
technique as described in the server streaming section (all 5 steps).

But there is another thing: requests also come in streaming mode. So you
need the following:

1.  Set consumer strategy to DELEGATION - that differs from the default
    PROPAGATION option in the fact that consumer will not produce
    responses at all. If you set PROPAGATION, then you will receive more
    responses than you expected;

2.  Forward `onError` and `onCompletion` on consumer;

3.  Set producer strategy to STREAMING.

Example:

    from("grpc://localhost:1101" +
        "/org.apache.camel.component.grpc.PingPong" +
        "?routeControlledStreamObserver=true" +
        "&consumerStrategy=DELEGATION" +
        "&forwardOnError=true" +
        "&forwardOnCompleted=true"
    )
        .toD("grpc://remotehost:1101" +
                "/org.apache.camel.component.grpc.PingPong" +
                "?method=${header.CamelGrpcMethodName}" +
                "&producerStrategy=STREAMING" +
                "&streamRepliesTo=direct:next" +
                "&forwardOnError=true" +
                "&forwardOnCompleted=true" +
                "&inheritExchangePropertiesForReplies=true"
        );
    
    from("direct:next")
            .to("grpc://dummy:0/?toRouteControlledStreamObserver=true");

# Examples

Below is a simple synchronous method invoke with host and port
parameters

    from("direct:grpc-sync")
    .to("grpc://remotehost:1101/org.apache.camel.component.grpc.PingPong?method=sendPing&synchronous=true");
    
    <route>
        <from uri="direct:grpc-sync" />
        <to uri="grpc://remotehost:1101/org.apache.camel.component.grpc.PingPong?method=sendPing&synchronous=true"/>
    </route>

An asynchronous method invoke

    from("direct:grpc-async")
    .to("grpc://remotehost:1101/org.apache.camel.component.grpc.PingPong?method=pingAsyncResponse");

gRPC service consumer with propagation consumer strategy

    from("grpc://localhost:1101/org.apache.camel.component.grpc.PingPong?consumerStrategy=PROPAGATION")
    .to("direct:grpc-service");

gRPC service producer with streaming producer strategy (requires a
service that uses "stream" mode as input and output)

    from("direct:grpc-request-stream")
    .to("grpc://remotehost:1101/org.apache.camel.component.grpc.PingPong?method=PingAsyncAsync&producerStrategy=STREAMING&streamRepliesTo=direct:grpc-response-stream");
    
    from("direct:grpc-response-stream")
    .log("Response received: ${body}");

gRPC service consumer TLS/SSL security negotiation enabled

    from("grpc://localhost:1101/org.apache.camel.component.grpc.PingPong?consumerStrategy=PROPAGATION&negotiationType=TLS&keyCertChainResource=file:src/test/resources/certs/server.pem&keyResource=file:src/test/resources/certs/server.key&trustCertCollectionResource=file:src/test/resources/certs/ca.pem")
    .to("direct:tls-enable")

gRPC service producer with custom JSON Web Token (JWT) implementation
authentication

    from("direct:grpc-jwt")
    .to("grpc://localhost:1101/org.apache.camel.component.grpc.PingPong?method=pingSyncSync&synchronous=true&authenticationType=JWT&jwtSecret=supersecuredsecret");

# Configuration

It is recommended to use the `protobuf-maven-plugin`, which calls the
Protocol Buffer Compiler (protoc) to generate Java source files from
.proto (protocol buffer definition) files. This plugin will generate
procedure request and response classes, their builders and gRPC
procedures stubs classes as well.

The following steps are required:

Insert operating system and CPU architecture detection extension inside
**\<build\>** tag of the project `pom.xml` or set
`${os.detected.classifier}` parameter manually

    <extensions>
      <extension>
        <groupId>kr.motd.maven</groupId>
        <artifactId>os-maven-plugin</artifactId>
        <version>1.7.1</version>
      </extension>
    </extensions>

Insert the gRPC and protobuf Java code generator plugins into the
**\<plugins\>** tag of the project pom.xml

    <plugin>
      <groupId>org.xolstice.maven.plugins</groupId>
      <artifactId>protobuf-maven-plugin</artifactId>
      <version>0.6.1</version>
      <configuration>
        <protocArtifact>com.google.protobuf:protoc:${protobuf-version}:exe:${os.detected.classifier}</protocArtifact>
        <pluginId>grpc-java</pluginId>
        <pluginArtifact>io.grpc:protoc-gen-grpc-java:${grpc-version}:exe:${os.detected.classifier}</pluginArtifact>
      </configuration>
      <executions>
        <execution>
          <goals>
            <goal>compile</goal>
            <goal>compile-custom</goal>
            <goal>test-compile</goal>
            <goal>test-compile-custom</goal>
          </goals>
        </execution>
      </executions>
    </plugin>

# More information

See these resources:

-   [gRPC project site](https://www.grpc.io/)

-   [Maven Protocol Buffers
    Plugin](https://www.xolstice.org/protobuf-maven-plugin)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|The gRPC server host name. This is localhost or 0.0.0.0 when being a consumer or remote server host name when using producer.||string|
|port|The gRPC local or remote server port||integer|
|service|Fully qualified service name from the protocol buffer descriptor file (package dot service definition name)||string|
|flowControlWindow|The HTTP/2 flow control window size (MiB)|1048576|integer|
|maxMessageSize|The maximum message size allowed to be received/sent (MiB)|4194304|integer|
|autoDiscoverServerInterceptors|Setting the autoDiscoverServerInterceptors mechanism, if true, the component will look for a ServerInterceptor instance in the registry automatically otherwise it will skip that checking.|true|boolean|
|consumerStrategy|This option specifies the top-level strategy for processing service requests and responses in streaming mode. If an aggregation strategy is selected, all requests will be accumulated in the list, then transferred to the flow, and the accumulated responses will be sent to the sender. If a propagation strategy is selected, request is sent to the stream, and the response will be immediately sent back to the sender. If a delegation strategy is selected, request is sent to the stream, but no response generated under the assumption that all necessary responses will be sent at another part of route. Delegation strategy always comes with routeControlledStreamObserver=true to be able to achieve the assumption.|PROPAGATION|object|
|forwardOnCompleted|Determines if onCompleted events should be pushed to the Camel route.|false|boolean|
|forwardOnError|Determines if onError events should be pushed to the Camel route. Exceptions will be set as message body.|false|boolean|
|initialFlowControlWindow|Sets the initial flow control window in bytes.|1048576|integer|
|keepAliveTime|Sets a custom keepalive time in milliseconds, the delay time for sending next keepalive ping. A value of Long.MAX\_VALUE or a value greater or equal to NettyServerBuilder.AS\_LARGE\_AS\_INFINITE will disable keepalive.|7200000|integer|
|keepAliveTimeout|Sets a custom keepalive timeout in milliseconds, the timeout for keepalive ping requests.|20000|integer|
|maxConcurrentCallsPerConnection|The maximum number of concurrent calls permitted for each incoming server connection. Defaults to no limit.|2147483647|integer|
|maxConnectionAge|Sets a custom max connection age in milliseconds. Connections lasting longer than which will be gracefully terminated. A random jitter of /-10% will be added to the value. A value of Long.MAX\_VALUE (the default) or a value greater or equal to NettyServerBuilder.AS\_LARGE\_AS\_INFINITE will disable max connection age.|9223372036854775807|integer|
|maxConnectionAgeGrace|Sets a custom grace time in milliseconds for the graceful connection termination. A value of Long.MAX\_VALUE (the default) or a value greater or equal to NettyServerBuilder.AS\_LARGE\_AS\_INFINITE is considered infinite.|9223372036854775807|integer|
|maxConnectionIdle|Sets a custom max connection idle time in milliseconds. Connection being idle for longer than which will be gracefully terminated. A value of Long.MAX\_VALUE (the default) or a value greater or equal to NettyServerBuilder.AS\_LARGE\_AS\_INFINITE will disable max connection idle|9223372036854775807|integer|
|maxInboundMetadataSize|Sets the maximum size of metadata allowed to be received. The default is 8 KiB.|8192|integer|
|maxRstFramesPerWindow|Limits the rate of incoming RST\_STREAM frames per connection to maxRstFramesPerWindow per maxRstPeriodSeconds. This option MUST be used in conjunction with maxRstPeriodSeconds for it to be effective.|0|integer|
|maxRstPeriodSeconds|Limits the rate of incoming RST\_STREAM frames per maxRstPeriodSeconds. This option MUST be used in conjunction with maxRstFramesPerWindow for it to be effective.|0|integer|
|permitKeepAliveTime|Sets the most aggressive keep-alive time in milliseconds that clients are permitted to configure. The server will try to detect clients exceeding this rate and will forcefully close the connection.|300000|integer|
|permitKeepAliveWithoutCalls|Sets whether to allow clients to send keep-alive HTTP/ 2 PINGs even if there are no outstanding RPCs on the connection.|false|boolean|
|routeControlledStreamObserver|Lets the route to take control over stream observer. If this value is set to true, then the response observer of gRPC call will be set with the name GrpcConstants.GRPC\_RESPONSE\_OBSERVER in the Exchange object. Please note that the stream observer's onNext(), onError(), onCompleted() methods should be called in the route.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|autoDiscoverClientInterceptors|Setting the autoDiscoverClientInterceptors mechanism, if true, the component will look for a ClientInterceptor instance in the registry automatically otherwise it will skip that checking.|true|boolean|
|inheritExchangePropertiesForReplies|Copies exchange properties from original exchange to all exchanges created for route defined by streamRepliesTo.|false|boolean|
|method|gRPC method name||string|
|producerStrategy|The mode used to communicate with a remote gRPC server. In SIMPLE mode a single exchange is translated into a remote procedure call. In STREAMING mode all exchanges will be sent within the same request (input and output of the recipient gRPC service must be of type 'stream').|SIMPLE|object|
|streamRepliesTo|When using STREAMING client mode, it indicates the endpoint where responses should be forwarded.||string|
|toRouteControlledStreamObserver|Expects that exchange property GrpcConstants.GRPC\_RESPONSE\_OBSERVER is set. Takes its value and calls onNext, onError and onComplete on that StreamObserver. All other gRPC parameters are ignored.|false|boolean|
|userAgent|The user agent header passed to the server||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|authenticationType|Authentication method type in advance to the SSL/TLS negotiation|NONE|object|
|jwtAlgorithm|JSON Web Token sign algorithm|HMAC256|object|
|jwtIssuer|JSON Web Token issuer||string|
|jwtSecret|JSON Web Token secret||string|
|jwtSubject|JSON Web Token subject||string|
|keyCertChainResource|The X.509 certificate chain file resource in PEM format link||string|
|keyPassword|The PKCS#8 private key file password||string|
|keyResource|The PKCS#8 private key file resource in PEM format link||string|
|negotiationType|Identifies the security negotiation type used for HTTP/2 communication|PLAINTEXT|object|
|serviceAccountResource|Service Account key file in JSON format resource link supported by the Google Cloud SDK||string|
|trustCertCollectionResource|The trusted certificates collection file resource in PEM format for verifying the remote endpoint's certificate||string|
