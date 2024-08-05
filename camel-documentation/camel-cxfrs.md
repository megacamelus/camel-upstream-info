# Cxfrs

**Since Camel 2.0**

**Both producer and consumer are supported**

The CXFRS component provides integration with [Apache
CXF](http://cxf.apache.org) for connecting to JAX-RS 1.1 and 2.0
services hosted in CXF.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
       <groupId>org.apache.camel</groupId>
       <artifactId>camel-cxf-rest</artifactId>
       <version>x.x.x</version>  <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    cxfrs://address?options

Where **address** represents the CXF endpoint’s address

    cxfrs:bean:rsEndpoint

Where **rsEndpoint** represents the spring bean’s name, which presents
the CXFRS client or server

For either style above, you can append options to the URI as follows:

    cxfrs:bean:cxfEndpoint?resourceClasses=org.apache.camel.rs.Example

You can also configure the CXF REST endpoint through the spring
configuration.

Since there are lots of differences between the CXF REST client and CXF
REST Server, we provide different configuration for them.

Please check the following files for more details:

-   the [schema
    file](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-spring-rest/src/main/resources/schema/cxfJaxrsEndpoint.xsd).

-   [CXF JAX-RS documentation](http://cxf.apache.org/docs/jax-rs.html).

# How to configure the REST endpoint in Camel

In the [camel-cxf schema
file](https://github.com/apache/camel/blob/main/components/camel-cxf/camel-cxf-spring-rest/src/main/resources/schema/cxfJaxrsEndpoint.xsd),
there are two elements for the REST endpoint definition:

-   `cxf:rsServer` for REST consumer

-   `cxf:rsClient` for REST producer.

You can find a Camel REST service route configuration example there.

# How to override the CXF producer address from message header

The `camel-cxfrs` producer supports overriding the service address by
setting the message with the key of `CamelDestinationOverrideUrl`.

     // set up the service address from the message header to override the setting of CXF endpoint
     exchange.getIn().setHeader(Exchange.DESTINATION_OVERRIDE_URL, constant(getServiceAddress()));

# Consuming a REST Request - Simple Binding Style

**Since Camel 2.11**

The `Default` binding style is rather low-level, requiring the user to
manually process the `MessageContentsList` object coming into the route.
Thus, it tightly couples the route logic with the method signature and
parameter indices of the JAX-RS operation. Somewhat inelegant, difficult
and error-prone.

In contrast, the `SimpleConsumer` binding style performs the following
mappings, to **make the request data more accessible** to you within the
Camel Message:

-   JAX-RS Parameters (`@HeaderParam`, `@QueryParam`, etc.) are injected
    as *IN* message headers. The header name matches the value of the
    annotation.

-   The request entity (POJO or another type) becomes the *IN* message
    body. If a single entity cannot be identified in the JAX-RS method
    signature, it falls back to the original `MessageContentsList`.

-   Binary `@Multipart` body parts become *IN* message attachments,
    supporting `DataHandler`, `InputStream`, `DataSource` and CXF’s
    `Attachment` class.

-   Non-binary `@Multipart` body parts are mapped as *IN* message
    headers. The header name matches the Body Part name.

Additionally, the following rules apply to the **Response mapping**:

-   If the message body type is different to `javax.ws.rs.core.Response`
    (user-built response), a new `Response` is created and the message
    body is set as the entity (so long it’s not null). The response
    status code is taken from the `Exchange.HTTP_RESPONSE_CODE` header,
    or defaults to 200 OK if not present.

-   If the message body type is equal to `javax.ws.rs.core.Response`, it
    means that the user has built a custom response, and therefore it is
    respected, and it becomes the final response.

-   In all cases, Camel headers permitted by custom or default
    `HeaderFilterStrategy` are added to the HTTP response.

## Enabling the Simple Binding Style

This binding style can be activated by setting the `bindingStyle`
parameter in the consumer endpoint to value `SimpleConsumer`:

      from("cxfrs:bean:rsServer?bindingStyle=SimpleConsumer")
        .to("log:TEST?showAll=true");

## Examples of request binding with different method signatures

Below is a list of method signatures along with the expected result from
the simple binding:

-   `public Response doAction(BusinessObject request);`: the request
    payload is placed in tbe *IN* message body, replacing the original
    MessageContentsList.

-   `public Response doAction(BusinessObject request, @HeaderParam("abcd") String abcd, @QueryParam("defg") String defg);`:
    the request payload is placed in the *IN* message body, replacing
    the original `MessageContentsList`. Both request parameters are
    mapped as IN message headers with names *"abcd"* and *"defg"*.

-   `public Response doAction(@HeaderParam("abcd") String abcd, @QueryParam("defg") String defg);`:
    both request parameters are mapped as the *IN* message headers with
    names *"abcd"* and *"defg"*. The original `MessageContentsList` is
    preserved, even though it only contains the two parameters.

-   `public Response doAction(@Multipart(value="body1") BusinessObject request, @Multipart(value="body2") BusinessObject request2);`:
    the first parameter is transferred as a header with name *"body1"*,
    and the second one is mapped as header *"body2"*. The original
    `MessageContentsList` is preserved as the *IN* message body.

-   `public Response doAction(InputStream abcd);`: the `InputStream` is
    unwrapped from the `MessageContentsList` and preserved as the *IN*
    message body.

-   `public Response doAction(DataHandler abcd);`: the *DataHandler* is
    unwrapped from the `MessageContentsList` and preserved as the *IN*
    message body.

## More examples of the Simple Binding Style

Given a JAX-RS resource class with this method:

    @POST @Path("/customers/{type}")
    public Response newCustomer(Customer customer, @PathParam("type") String type, @QueryParam("active") @DefaultValue("true") boolean active) {
        return null;
    }

Serviced by the following route:

    from("cxfrs:bean:rsServer?bindingStyle=SimpleConsumer")
        .recipientList(simple("direct:${header.operationName}"));
    
    from("direct:newCustomer")
        .log("Request: type=${header.type}, active=${header.active}, customerData=${body}");

The following HTTP request with XML payload (given that the Customer DTO
is JAXB-annotated):

    POST /customers/gold?active=true
    
    Payload:
    <Customer>
      <fullName>Raul Kripalani</fullName>
      <country>Spain</country>
      <project>Apache Camel</project>
    </Customer>

Will print the message:

    Request: type=gold, active=true, customerData=<Customer.toString() representation>

More examples on how to process requests and write responses can be
found
[here](https://svn.apache.org/repos/asf/camel/trunk/components/camel-cxf/src/test/java/org/apache/camel/component/cxf/jaxrs/simplebinding/).

# Consuming a REST Request - Default Binding Style

The [CXF JAXRS front end](http://cxf.apache.org/docs/jax-rs.html)
implements the [JAX-RS (JSR-311) API](https://javaee.github.io/jsr311/),
so we can export the resource classes as a REST service. And we leverage
the [CXF Invoker API](http://cxf.apache.org/docs/invokers.html) to turn
a REST request into a normal Java object method invocation. You don’t
need to specify the URI template within your endpoint, CXF takes care of
the REST request URI to resource class method mapping according to the
JSR-311 specification. All you need to do in Camel is delegate this
method request to the right processor or endpoint.

Here is an example of a CXFRS route…

    private static final String CXF_RS_ENDPOINT_URI =
            "cxfrs://http://localhost:" + CXT + "/rest?resourceClasses=org.apache.camel.component.cxf.jaxrs.testbean.CustomerServiceResource";
    private static final String CXF_RS_ENDPOINT_URI2 =
            "cxfrs://http://localhost:" + CXT + "/rest2?resourceClasses=org.apache.camel.component.cxf.jaxrs.testbean.CustomerService";
    private static final String CXF_RS_ENDPOINT_URI3 =
            "cxfrs://http://localhost:" + CXT + "/rest3?"
            + "resourceClasses=org.apache.camel.component.cxf.jaxrs.testbean.CustomerServiceNoAnnotations&"
            + "modelRef=classpath:/org/apache/camel/component/cxf/jaxrs/CustomerServiceModel.xml";
    private static final String CXF_RS_ENDPOINT_URI4 =
            "cxfrs://http://localhost:" + CXT + "/rest4?"
            + "modelRef=classpath:/org/apache/camel/component/cxf/jaxrs/CustomerServiceDefaultHandlerModel.xml";
    private static final String CXF_RS_ENDPOINT_URI5 =
            "cxfrs://http://localhost:" + CXT + "/rest5?"
            + "propagateContexts=true&"
            + "modelRef=classpath:/org/apache/camel/component/cxf/jaxrs/CustomerServiceDefaultHandlerModel.xml";
    protected RouteBuilder createRouteBuilder() throws Exception {
        final Processor testProcessor = new TestProcessor();
        final Processor testProcessor2 = new TestProcessor2();
        final Processor testProcessor3 = new TestProcessor3();
        return new RouteBuilder() {
            public void configure() {
                errorHandler(new NoErrorHandlerBuilder());
                from(CXF_RS_ENDPOINT_URI).process(testProcessor);
                from(CXF_RS_ENDPOINT_URI2).process(testProcessor);
                from(CXF_RS_ENDPOINT_URI3).process(testProcessor);
                from(CXF_RS_ENDPOINT_URI4).process(testProcessor2);
                from(CXF_RS_ENDPOINT_URI5).process(testProcessor3);
            }
        };
    }

And the corresponding resource class used to configure the endpoint…

**Note about resource classes**

By default, JAX-RS resource classes are **only** used to configure
JAX-RS properties. Methods will **not** be executed during routing of
messages to the endpoint. Instead, it is the responsibility of the route
to do all processing.

It is sufficient to provide an interface only as opposed to a no-op
service implementation class for the default mode.

If a **performInvocation** option is enabled, the service implementation
will be invoked first, the response will be set on the Camel exchange,
and the route execution will continue as usual. This can be useful for
integrating the existing JAX-RS implementations into Camel routes and
for post-processing JAX-RS Responses in custom processors.

    @Path("/customerservice/")
    public interface CustomerServiceResource {
    
        @GET
        @Path("/customers/{id}/")
        Customer getCustomer(@PathParam("id") String id);
    
        @PUT
        @Path("/customers/")
        Response updateCustomer(Customer customer);
    
        @Path("/{id}")
        @PUT()
        @Consumes({ "application/xml", "text/plain",
                        "application/json" })
        @Produces({ "application/xml", "text/plain",
                        "application/json" })
        Object invoke(@PathParam("id") String id,
                        String payload);
    }

# How to invoke the REST service through camel-cxfrs producer

The [CXF JAXRS front end](http://cxf.apache.org/docs/jax-rs.html)
implements [a proxy-based client
API](http://cxf.apache.org/docs/jax-rs-client-api.html#JAX-RSClientAPI-Proxy-basedAPI),
with this API you can invoke the remote REST service through a proxy.
The `camel-cxfrs` producer is based on this [proxy
API](http://cxf.apache.org/docs/jax-rs-client-api.html#JAX-RSClientAPI-Proxy-basedAPI).
You need to specify the operation name in the message header and prepare
the parameter in the message body, the camel-cxfrs producer will
generate the right REST request for you.

Here is an example:

    Exchange exchange = template.send("direct://proxy", new Processor() {
        public void process(Exchange exchange) throws Exception {
            exchange.setPattern(ExchangePattern.InOut);
            Message inMessage = exchange.getIn();
            // set the operation name
            inMessage.setHeader(CxfConstants.OPERATION_NAME, "getCustomer");
            // using the proxy client API
            inMessage.setHeader(CxfConstants.CAMEL_CXF_RS_USING_HTTP_API, Boolean.FALSE);
            // set a customer header
            inMessage.setHeader("key", "value");
            // set up the accepted content type
            inMessage.setHeader(Exchange.ACCEPT_CONTENT_TYPE, "application/json");
            // set the parameters, if you just have one parameter,
            // camel will put this object into an Object[] itself
            inMessage.setBody("123");
        }
    });
    
    // get the response message
    Customer response = (Customer) exchange.getMessage().getBody();
    
    assertNotNull(response, "The response should not be null");
    assertEquals(123, response.getId(), "Get a wrong customer id");
    assertEquals("John", response.getName(), "Get a wrong customer name");
    assertEquals(200, exchange.getMessage().getHeader(Exchange.HTTP_RESPONSE_CODE), "Get a wrong response code");
    assertEquals("value", exchange.getMessage().getHeader("key"), "Get a wrong header value");

The [CXF JAXRS front end](http://cxf.apache.org/docs/jax-rs.html) also
provides [an HTTP centric client
API](http://cxf.apache.org/docs/jax-rs-client-api.html#JAX-RSClientAPI-CXFWebClientAPI).
You can also invoke this API from `camel-cxfrs` producer. You need to
specify the
[HTTP\_PATH](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Exchange.html#HTTP_PATH)
and the
[HTTP\_METHOD](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Exchange.html#HTTP_METHOD)
and let the producer use the http centric client API by using the URI
option **httpClientAPI** or by setting the message header
[CxfConstants.CAMEL\_CXF\_RS\_USING\_HTTP\_API](https://www.javadoc.io/doc/org.apache.camel/camel-cxf-transport/current/org/apache/camel/component/cxf/common/message/CxfConstants.html#CAMEL_CXF_RS_USING_HTTP_API).
You can turn the response object to the type class specified with the
message header
[CxfConstants.CAMEL\_CXF\_RS\_RESPONSE\_CLASS](https://www.javadoc.io/doc/org.apache.camel/camel-cxf-transport/current/org/apache/camel/component/cxf/common/message/CxfConstants.html#CAMEL_CXF_RS_RESPONSE_CLASS).

    Exchange exchange = template.send("direct://http", new Processor() {
        public void process(Exchange exchange) throws Exception {
            exchange.setPattern(ExchangePattern.InOut)
            Message inMessage = exchange.getIn();
            // using the http central client API
            inMessage.setHeader(CxfConstants.CAMEL_CXF_RS_USING_HTTP_API, Boolean.TRUE);
            // set the Http method
            inMessage.setHeader(Exchange.HTTP_METHOD, "GET");
            // set the relative path
            inMessage.setHeader(Exchange.HTTP_PATH, "/customerservice/customers/123");
            // Specify the response class, cxfrs will use InputStream as the response object type
            inMessage.setHeader(CxfConstants.CAMEL_CXF_RS_RESPONSE_CLASS, Customer.class);
            // set a customer header
            inMessage.setHeader("key", "value");
            // since we use the Get method, so we don't need to set the message body
            inMessage.setBody(null);
        }
    });

We also support to specify the query parameters from cxfrs URI for the
CXFRS http centric client.

    Exchange exchange = template.send("cxfrs://http://localhost:9003/testQuery?httpClientAPI=true&q1=12&q2=13"

To support the Dynamical routing, you can override the URI’s query
parameters by using the
[CxfConstants.CAMEL\_CXF\_RS\_QUERY\_MAP](https://www.javadoc.io/doc/org.apache.camel/camel-cxf-transport/current/org/apache/camel/component/cxf/common/message/CxfConstants.html#CAMEL_CXF_RS_QUERY_MAP)
header to set the parameter map for it.

    Map<String, String> queryMap = new LinkedHashMap<>();
    queryMap.put("q1", "new");
    queryMap.put("q2", "world");
    inMessage.setHeader(CxfConstants.CAMEL_CXF_RS_QUERY_MAP, queryMap);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|beanId|To lookup an existing configured CxfRsEndpoint. Must used bean: as prefix.||string|
|address|The service publish address.||string|
|features|Set the feature list to the CxfRs endpoint.||array|
|modelRef|This option is used to specify the model file which is useful for the resource class without annotation. When using this option, then the service class can be omitted, to emulate document-only endpoints||string|
|providers|Set custom JAX-RS provider(s) list to the CxfRs endpoint. You can specify a string with a list of providers to lookup in the registy separated by comma.||string|
|resourceClasses|The resource classes which you want to export as REST service. Multiple classes can be separated by comma.||array|
|schemaLocations|Sets the locations of the schema(s) which can be used to validate the incoming XML or JAXB-driven JSON.||array|
|skipFaultLogging|This option controls whether the PhaseInterceptorChain skips logging the Fault that it catches.|false|boolean|
|bindingStyle|Sets how requests and responses will be mapped to/from Camel. Two values are possible: SimpleConsumer: This binding style processes request parameters, multiparts, etc. and maps them to IN headers, IN attachments and to the message body. It aims to eliminate low-level processing of org.apache.cxf.message.MessageContentsList. It also also adds more flexibility and simplicity to the response mapping. Only available for consumers. Default: The default style. For consumers this passes on a MessageContentsList to the route, requiring low-level processing in the route. This is the traditional binding style, which simply dumps the org.apache.cxf.message.MessageContentsList coming in from the CXF stack onto the IN message body. The user is then responsible for processing it according to the contract defined by the JAX-RS method signature. Custom: allows you to specify a custom binding through the binding option.|Default|object|
|publishedEndpointUrl|This option can override the endpointUrl that published from the WADL which can be accessed with resource address url plus \_wadl||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|serviceBeans|The service beans (the bean ids to lookup in the registry) which you want to export as REST service. Multiple beans can be separated by comma||string|
|cookieHandler|Configure a cookie handler to maintain a HTTP session||object|
|hostnameVerifier|The hostname verifier to be used. Use the # notation to reference a HostnameVerifier from the registry.||object|
|sslContextParameters|The Camel SSL setting reference. Use the # notation to reference the SSL Context.||object|
|throwExceptionOnFailure|This option tells the CxfRsProducer to inspect return codes and will generate an Exception if the return code is larger than 207.|true|boolean|
|httpClientAPI|If it is true, the CxfRsProducer will use the HttpClientAPI to invoke the service. If it is false, the CxfRsProducer will use the ProxyClientAPI to invoke the service|true|boolean|
|ignoreDeleteMethodMessageBody|This option is used to tell CxfRsProducer to ignore the message body of the DELETE method when using HTTP API.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxClientCacheSize|This option allows you to configure the maximum size of the cache. The implementation caches CXF clients or ClientFactoryBean in CxfProvider and CxfRsProvider.|10|integer|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|binding|To use a custom CxfBinding to control the binding between Camel Message and CXF Message.||object|
|bus|To use a custom configured CXF Bus.||object|
|continuationTimeout|This option is used to set the CXF continuation timeout which could be used in CxfConsumer by default when the CXF server is using Jetty or Servlet transport.|30000|duration|
|cxfRsConfigurer|This option could apply the implementation of org.apache.camel.component.cxf.jaxrs.CxfRsEndpointConfigurer which supports to configure the CXF endpoint in programmatic way. User can configure the CXF server and client by implementing configure{Server/Client} method of CxfEndpointConfigurer.||object|
|defaultBus|Will set the default bus when CXF endpoint create a bus by itself|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|performInvocation|When the option is true, Camel will perform the invocation of the resource class instance and put the response object into the exchange for further processing.|false|boolean|
|propagateContexts|When the option is true, JAXRS UriInfo, HttpHeaders, Request and SecurityContext contexts will be available to custom CXFRS processors as typed Camel exchange properties. These contexts can be used to analyze the current requests using JAX-RS API.|false|boolean|
|loggingFeatureEnabled|This option enables CXF Logging Feature which writes inbound and outbound REST messages to log.|false|boolean|
|loggingSizeLimit|To limit the total size of number of bytes the logger will output when logging feature has been enabled and -1 for no limit.|49152|integer|
