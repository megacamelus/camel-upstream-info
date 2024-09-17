# Atmosphere-websocket

**Since Camel 2.14**

**Both producer and consumer are supported**

The Atmosphere-Websocket component provides Websocket based endpoints
for a servlet communicating with external clients over Websocket (as a
servlet accepting websocket connections from external clients). This
component uses the
[Atmosphere](https://github.com/Atmosphere/atmosphere) library to
support the Websocket transport in various Servlet containers.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-atmosphere-websocket</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Reading and Writing Data over Websocket

An atmopshere-websocket endpoint can either write data to the socket or
read from the socket, depending on whether the endpoint is configured as
the producer or the consumer, respectively.

# Examples

## Consumer Example

In the route below, Camel will read from the specified websocket
connection.

    from("atmosphere-websocket:///servicepath")
            .to("direct:next");

And the equivalent Spring sample:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="atmosphere-websocket:///servicepath"/>
        <to uri="direct:next"/>
      </route>
    </camelContext>

## Producer Example

In the route below, Camel will write to the specified websocket
connection.

    from("direct:next")
            .to("atmosphere-websocket:///servicepath");

And the equivalent Spring sample:

    <camelContext xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:next"/>
        <to uri="atmosphere-websocket:///servicepath"/>
      </route>
    </camelContext>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|muteException|If enabled and an Exchange failed processing on the consumer side the response's body won't contain the exception's stack trace.|true|boolean|
|servletName|Default name of servlet to use. The default name is CamelServlet.|CamelServlet|string|
|attachmentMultipartBinding|Whether to automatic bind multipart/form-data as attachments on the Camel Exchange. The options attachmentMultipartBinding=true and disableStreamCache=false cannot work together. Remove disableStreamCache to use AttachmentMultipartBinding. This is turn off by default as this may require servlet specific configuration to enable this when using Servlet's.|false|boolean|
|fileNameExtWhitelist|Whitelist of accepted filename extensions for accepting uploaded files. Multiple extensions can be separated by comma, such as txt,xml.||string|
|httpRegistry|To use a custom org.apache.camel.component.servlet.HttpRegistry.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|allowJavaSerializedObject|Whether to allow java serialization when a request uses context-type=application/x-java-serialized-object. This is by default turned off. If you enable this then be aware that Java will deserialize the incoming data from the request to Java and that can be a potential security risk.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|httpBinding|To use a custom HttpBinding to control the mapping between Camel message and HttpClient.||object|
|httpConfiguration|To use the shared HttpConfiguration as base configuration.||object|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|servicePath|Name of websocket endpoint||string|
|chunked|If this option is false the Servlet will disable the HTTP streaming and set the content-length header on the response|true|boolean|
|disableStreamCache|Determines whether or not the raw input stream is cached or not. The Camel consumer (camel-servlet, camel-jetty etc.) will by default cache the input stream to support reading it multiple times to ensure it Camel can retrieve all data from the stream. However you can set this option to true when you for example need to access the raw stream, such as streaming it directly to a file or other persistent store. DefaultHttpBinding will copy the request input stream into a stream cache and put it into message body if this option is false to support reading the stream multiple times. If you use Servlet to bridge/proxy an endpoint then consider enabling this option to improve performance, in case you do not need to read the message payload multiple times. The producer (camel-http) will by default cache the response body stream. If setting this option to true, then the producers will not cache the response body stream but use the response stream as-is (the stream can only be read once) as the message body.|false|boolean|
|sendToAll|Whether to send to all (broadcast) or send to a single receiver.|false|boolean|
|transferException|If enabled and an Exchange failed processing on the consumer side, and if the caused Exception was send back serialized in the response as a application/x-java-serialized-object content type. On the producer side the exception will be deserialized and thrown as is, instead of the HttpOperationFailedException. The caused exception is required to be serialized. This is by default turned off. If you enable this then be aware that Java will deserialize the incoming data from the request to Java and that can be a potential security risk.|false|boolean|
|useStreaming|To enable streaming to send data as multiple text fragments.|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|httpBinding|To use a custom HttpBinding to control the mapping between Camel message and HttpClient.||object|
|async|Configure the consumer to work in async mode|false|boolean|
|httpMethodRestrict|Used to only allow consuming if the HttpMethod matches, such as GET/POST/PUT etc. Multiple methods can be specified separated by comma.||string|
|logException|If enabled and an Exchange failed processing on the consumer side the exception's stack trace will be logged when the exception stack trace is not sent in the response's body.|false|boolean|
|matchOnUriPrefix|Whether or not the consumer should try to find a target consumer by matching the URI prefix if no exact match is found.|false|boolean|
|muteException|If enabled and an Exchange failed processing on the consumer side the response's body won't contain the exception's stack trace.|false|boolean|
|responseBufferSize|To use a custom buffer size on the jakarta.servlet.ServletResponse.||integer|
|servletName|Name of the servlet to use|CamelServlet|string|
|attachmentMultipartBinding|Whether to automatic bind multipart/form-data as attachments on the Camel Exchange. The options attachmentMultipartBinding=true and disableStreamCache=false cannot work together. Remove disableStreamCache to use AttachmentMultipartBinding. This is turn off by default as this may require servlet specific configuration to enable this when using Servlet's.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|eagerCheckContentAvailable|Whether to eager check whether the HTTP requests has content if the content-length header is 0 or not present. This can be turned on in case HTTP clients do not send streamed data.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|fileNameExtWhitelist|Whitelist of accepted filename extensions for accepting uploaded files. Multiple extensions can be separated by comma, such as txt,xml.||string|
|mapHttpMessageBody|If this option is true then IN exchange Body of the exchange will be mapped to HTTP body. Setting this to false will avoid the HTTP mapping.|true|boolean|
|mapHttpMessageFormUrlEncodedBody|If this option is true then IN exchange Form Encoded body of the exchange will be mapped to HTTP. Setting this to false will avoid the HTTP Form Encoded body mapping.|true|boolean|
|mapHttpMessageHeaders|If this option is true then IN exchange Headers of the exchange will be mapped to HTTP headers. Setting this to false will avoid the HTTP Headers mapping.|true|boolean|
|optionsEnabled|Specifies whether to enable HTTP OPTIONS for this Servlet consumer. By default OPTIONS is turned off.|false|boolean|
|traceEnabled|Specifies whether to enable HTTP TRACE for this Servlet consumer. By default TRACE is turned off.|false|boolean|
|bridgeEndpoint|If the option is true, HttpProducer will ignore the Exchange.HTTP\_URI header, and use the endpoint's URI for request. You may also set the option throwExceptionOnFailure to be false to let the HttpProducer send all the fault response back.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
