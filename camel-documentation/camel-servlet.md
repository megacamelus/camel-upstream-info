# Servlet

**Since Camel 2.0**

**Only consumer is supported**

The Servlet component provides HTTP-based endpoints for consuming HTTP
requests that arrive at an HTTP endpoint that is bound to a published
Servlet.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-servlet</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

**Stream**

Servlet is stream-based, which means the input it receives is submitted
to Camel as a stream. That means you will only be able to read the
content of the stream **once**. If you find a situation where the
message body appears to be empty, or you need to access the data
multiple times (eg: doing multicasting, or redelivery error handling),
you should use Stream caching or convert the message body to a `String`
which is safe to be read multiple times.

# URI format

    servlet://relative_path[?options]

# Message Headers

Camel will apply the same Message Headers as the
[HTTP](#http-component.adoc) component.

Camel will also populate **all** `request.parameter` and
`request.headers`. For example, if a client request has the URL,
[http://myserver/myserver?orderid=123](http://myserver/myserver?orderid=123), the exchange will contain a
header named `orderid` with the value `123`.

# Examples

You can consume only `from` endpoints generated by the Servlet
component. Therefore, it should be used only as input into your Camel
routes. To issue HTTP requests against other HTTP endpoints, use the
[HTTP Component](#http-component.adoc).

## Example `CamelHttpTransportServlet` configuration

### Camel Spring Boot / Camel Quarkus

When running camel-servlet on the Spring Boot or Camel Quarkus runtimes,
`CamelHttpTransportServlet` is configured for you automatically and is
driven by configuration properties. Refer to the camel-servlet
configuration documentation for these runtimes.

### Servlet container / application server

If you’re running Camel standalone on a Servlet container or application
server, you can use `web.xml` to configure `CamelHttpTransportServlet`.

For example, to define a route that exposes an HTTP service under the
path `/services`.

    <web-app>
      <servlet>
        <servlet-name>CamelServlet</servlet-name>
        <servlet-class>org.apache.camel.component.servlet.CamelHttpTransportServlet</servlet-class>
      </servlet>
    
      <servlet-mapping>
        <servlet-name>CamelServlet</servlet-name>
        <url-pattern>/services/*</url-pattern>
      </servlet-mapping>
    </web-app>

## Example route

    from("servlet:hello").process(new Processor() {
        public void process(Exchange exchange) throws Exception {
            // Access HTTP headers sent by the client
            Message message = exchange.getMessage();
            String contentType = message.getHeader(Exchange.CONTENT_TYPE, String.class);
            String httpUri = message.getHeader(Exchange.HTTP_URI, String.class);
    
            // Set the response body
            message.setBody("<b>Got Content-Type: " + contentType = ", URI: " + httpUri + "</b>");
        }
    });

## Camel Servlet HTTP endpoint path

The full path where the camel-servlet HTTP endpoint is published depends
on:

-   The Servlet application context path

-   The configured Servlet mapping URL patterns

-   The camel-servlet endpoint URI context path

For example, if the application context path is `/camel` and
`CamelHttpTransportServlet` is configured with a URL mapping of
`/services/*`. Then a Camel route like `from("servlet:hello")` would be
published to a path like [http://localhost:8080/camel/services/hello](http://localhost:8080/camel/services/hello).

## Servlet asynchronous support

To enable Camel to benefit from Servlet asynchronous support, you must
enable the `async` boolean init parameter by setting it to `true`.

By default, the servlet thread pool is used for exchange processing.
However, to use a custom thread pool, you can configure an init
parameter named `executorRef` with the String value set to the name of a
bean bound to the Camel registry of type `Executor`. If no bean was
found in the Camel registry, the Servlet component will attempt to fall
back on an executor policy or default executor service.

If you want to force exchange processing to wait in another container
background thread, you can set the `forceAwait` boolean init parameter
to `true`.

On the Camel Quarkus runtime, these init parameters can be set via
configuration properties. Refer to the Camel Quarkus Servlet extension
documentation for more information.

On other runtimes you can configure these parameters in `web.xml` as
follows.

    <web-app>
        <servlet>
            <servlet-name>CamelServlet</servlet-name>
            <servlet-class>org.apache.camel.component.servlet.CamelHttpTransportServlet</servlet-class>
            <init-param>
                <param-name>async</param-name>
                <param-value>true</param-value>
            </init-param>
            <init-param>
                <param-name>executorRef</param-name>
                <param-value>my-custom-thread-pool</param-value>
            </init-param>
        </servlet>
    
        <servlet-mapping>
            <servlet-name>CamelServlet</servlet-name>
            <url-pattern>/services/*</url-pattern>
        </servlet-mapping>
    </web-app>

## Camel JARs on an application server boot classpath

If deploying into an application server / servlet container and you
choose to have Camel JARs such as `camel-core`, `camel-servlet`, etc on
the boot classpath. Then the servlet mapping list will be shared between
multiple deployed Camel application in the app server.

Having Camel JARs on the boot classpath of the application server is not
best practice.

In this scenario, you **must** define a custom and unique servlet name
in each of your Camel applications. For example, in `web.xml`:

    <web-app>
        <servlet>
          <servlet-name>MyServlet</servlet-name>
          <servlet-class>org.apache.camel.component.servlet.CamelHttpTransportServlet</servlet-class>
          <load-on-startup>1</load-on-startup>
        </servlet>
    
        <servlet-mapping>
          <servlet-name>MyServlet</servlet-name>
          <url-pattern>/*</url-pattern>
        </servlet-mapping>
    </web-app>

In your Camel servlet endpoints, include the servlet name:

    from("servlet://foo?servletName=MyServlet")

Camel detects duplicate Servlet names and will fail to start the
application. You can control and ignore such duplicates by setting the
servlet init parameter `ignoreDuplicateServletName` to `true` as
follows:

      <servlet>
        <servlet-name>CamelServlet</servlet-name>
        <display-name>Camel Http Transport Servlet</display-name>
        <servlet-class>org.apache.camel.component.servlet.CamelHttpTransportServlet</servlet-class>
        <init-param>
          <param-name>ignoreDuplicateServletName</param-name>
          <param-value>true</param-value>
        </init-param>
      </servlet>

But it is **strongly advised** to use unique `servlet-name` for each
Camel application to avoid this duplication clash, as well any
unforeseen side effects.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|muteException|If enabled and an Exchange failed processing on the consumer side the response's body won't contain the exception's stack trace.|true|boolean|
|servletName|Default name of servlet to use. The default name is CamelServlet.|CamelServlet|string|
|attachmentMultipartBinding|Whether to automatic bind multipart/form-data as attachments on the Camel Exchange. The options attachmentMultipartBinding=true and disableStreamCache=false cannot work together. Remove disableStreamCache to use AttachmentMultipartBinding. This is turn off by default as this may require servlet specific configuration to enable this when using Servlet's.|false|boolean|
|fileNameExtWhitelist|Whitelist of accepted filename extensions for accepting uploaded files. Multiple extensions can be separated by comma, such as txt,xml.||string|
|httpRegistry|To use a custom org.apache.camel.component.servlet.HttpRegistry.||object|
|allowJavaSerializedObject|Whether to allow java serialization when a request uses context-type=application/x-java-serialized-object. This is by default turned off. If you enable this then be aware that Java will deserialize the incoming data from the request to Java and that can be a potential security risk.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|httpBinding|To use a custom HttpBinding to control the mapping between Camel message and HttpClient.||object|
|httpConfiguration|To use the shared HttpConfiguration as base configuration.||object|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|contextPath|The context-path to use||string|
|disableStreamCache|Determines whether or not the raw input stream is cached or not. The Camel consumer (camel-servlet, camel-jetty etc.) will by default cache the input stream to support reading it multiple times to ensure it Camel can retrieve all data from the stream. However you can set this option to true when you for example need to access the raw stream, such as streaming it directly to a file or other persistent store. DefaultHttpBinding will copy the request input stream into a stream cache and put it into message body if this option is false to support reading the stream multiple times. If you use Servlet to bridge/proxy an endpoint then consider enabling this option to improve performance, in case you do not need to read the message payload multiple times. The producer (camel-http) will by default cache the response body stream. If setting this option to true, then the producers will not cache the response body stream but use the response stream as-is (the stream can only be read once) as the message body.|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|httpBinding|To use a custom HttpBinding to control the mapping between Camel message and HttpClient.||object|
|chunked|If this option is false the Servlet will disable the HTTP streaming and set the content-length header on the response|true|boolean|
|transferException|If enabled and an Exchange failed processing on the consumer side, and if the caused Exception was send back serialized in the response as a application/x-java-serialized-object content type. On the producer side the exception will be deserialized and thrown as is, instead of the HttpOperationFailedException. The caused exception is required to be serialized. This is by default turned off. If you enable this then be aware that Java will deserialize the incoming data from the request to Java and that can be a potential security risk.|false|boolean|
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
