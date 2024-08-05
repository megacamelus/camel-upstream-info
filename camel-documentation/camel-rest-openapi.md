# Rest-openapi

**Since Camel 3.1**

**Both producer and consumer are supported**

The REST OpenApi configures rest producers from
[OpenApi](https://www.openapis.org/) (Open API) specification document
and delegates to a component implementing the *RestProducerFactory*
interface. Currently, known working components are:

-   [http](#http-component.adoc)

-   [netty-http](#netty-http-component.adoc)

-   [undertow](#undertow-component.adoc)

-   [vertx-http](#vertx-http-component.adoc)

Only OpenAPI spec version 3.x is supported. You cannot use the old
Swagger 2.0 spec.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-rest-openapi</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    rest-openapi:[specificationPath#]operationId

Where `operationId` is the ID of the operation in the OpenApi
specification, and `specificationPath` is the path to the specification.
If the `specificationPath` is not specified it defaults to
`openapi.json`. The lookup mechanism uses Camels `ResourceHelper` to
load the resource, which means that you can use CLASSPATH resources
(`classpath:my-specification.json`), files (`file:/some/path.json`), the
web (`\http://api.example.com/openapi.json`) or reference a bean
(`ref:nameOfBean`) or use a method of a bean
(`bean:nameOfBean.methodName`) to get the specification resource,
failing that OpenApi’s own resource loading support.

This component does not act as an HTTP client. It delegates that to
another component mentioned above. The lookup mechanism searches for a
single component that implements the *RestProducerFactory* interface and
uses that. If the CLASSPATH contains more than one, then the property
`componentName` should be set to indicate which component to delegate
to.

Most of the configuration is taken from the OpenApi specification, but
the option exists to override those by specifying them on the component
or on the endpoint. Typically, you would need to override the `host` or
`basePath` if those differ from the specification.

The `host` parameter should contain the absolute URI containing scheme,
hostname and port number, for instance: `\https://api.example.com`

With `componentName` you specify what component is used to perform the
requests, this named component needs to be present in the Camel context
and implement the required *RestProducerFactory* interface — as do the
components listed at the top.

If you do not specify the *componentName* at either component or
endpoint level, CLASSPATH is searched for a suitable delegate. There
should be only one component present on the CLASSPATH that implements
the *RestProducerFactory* interface for this to work.

This component’s endpoint URI is lenient which means that in addition to
message headers you can specify REST operation’s parameters as endpoint
parameters, these will be constant for all subsequent invocations, so it
makes sense to use this feature only for parameters that are indeed
constant for all invocations — for example API version in path such as
`/api/{version}/users/{id}`.

# Example: PetStore

Checkout the `rest-openapi-simple` example project in the
[https://github.com/apache/camel-spring-boot-examples](https://github.com/apache/camel-spring-boot-examples) repository.

For example, if you wanted to use the
[*PetStore*](https://petstore3.swagger.io/api/v3/) provided REST API
simply reference the specification URI and desired operation id from the
OpenApi specification or download the specification and store it as
`openapi.json` (in the root) of CLASSPATH that way it will be
automatically used. Let’s use the [HTTP](#http-component.adoc) component
to perform all the requests and Camel’s excellent support for Spring
Boot.

Here are our dependencies defined in Maven POM file:

    <dependency>
      <groupId>org.apache.camel.springboot</groupId>
      <artifactId>camel-http-starter</artifactId>
    </dependency>
    
    <dependency>
      <groupId>org.apache.camel.springboot</groupId>
      <artifactId>camel-rest-openapi-starter</artifactId>
    </dependency>

Start by defining a *RestOpenApiComponent* bean:

    @Bean
    public Component petstore(CamelContext camelContext) {
        RestOpenApiComponent petstore = new RestOpenApiComponent(camelContext);
        petstore.setSpecificationUri("https://petstore3.swagger.io/api/v3/openapi.json");
        petstore.setHost("https://petstore3.swagger.io");
        return petstore;
    }

Support in Camel for Spring Boot will auto create the `HttpComponent`
Spring bean, and you can configure it using `application.properties` (or
`application.yml`) using prefix `camel.component.http.`. We are defining
the `petstore` component here to have a named component in the Camel
context that we can use to interact with the PetStore REST API, if this
is the only `rest-openapi` component used we might configure it in the
same manner (using `application.properties`).

In this example, there is no need to explicitly associate the `petstore`
component with the `HttpComponent` as Camel will use the first class on
the CLASSPATH that implements `RestProducerFactory`. However, if a
different component is required, then calling
`petstore.setComponentName("http")` would use the named component from
the Camel registry.

Now in our application we can simply use the `ProducerTemplate` to
invoke PetStore REST methods:

    @Autowired
    ProducerTemplate template;
    
    String getPetJsonById(int petId) {
        return template.requestBodyAndHeader("petstore:getPetById", null, "petId", petId);
    }

# Request validation

API requests can be validated against the configured OpenAPI
specification before they are sent by setting the
`requestValidationEnabled` option to `true`. Validation is provided by
the
[swagger-request-validator](https://bitbucket.org/atlassian/swagger-request-validator/src/master/).

The validator checks for the following conditions:

-   request body - Checks if the request body is required and whether
    there is any body on the Camel Exchange.

-   valid json - Checks if the content-type is `application/json` that
    the message body can be parsed as valid JSon.

-   content-type - Validates whether the `Content-Type` header for the
    request is valid for the API operation. The value is taken from the
    `Content-Type` Camel message exchange header.

-   request parameters - Validates whether an HTTP header required by
    the API operation is present. The header is expected to be present
    among the Camel message exchange headers.

-   query parameters - Validates whether an HTTP query parameter
    required by the API operation is present. The query parameter is
    expected to be present among the Camel message exchange headers.

If any of the validation checks fail, then a
`RestOpenApiValidationException` is thrown. The exception object has a
`getValidationErrors` method that returns the error messages from the
validator.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|basePath|API basePath, for example /v2. Default is unset, if set overrides the value present in OpenApi specification.||string|
|specificationUri|Path to the OpenApi specification file. The scheme, host base path are taken from this specification, but these can be overridden with properties on the component or endpoint level. If not given the component tries to load openapi.json resource. Note that the host defined on the component and endpoint of this Component should contain the scheme, hostname and optionally the port in the URI syntax (i.e. https://api.example.com:8080). Can be overridden in endpoint configuration.|openapi.json|string|
|apiContextPath|Sets the context-path to use for servicing the OpenAPI specification||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|clientRequestValidation|Whether to enable validation of the client request to check if the incoming request is valid according to the OpenAPI specification|false|boolean|
|missingOperation|Whether the consumer should fail,ignore or return a mock response for OpenAPI operations that are not mapped to a corresponding route.|fail|string|
|bindingPackageScan|Package name to use as base (offset) for classpath scanning of POJO classes are located when using binding mode is enabled for JSon or XML. Multiple package names can be separated by comma.||string|
|consumerComponentName|Name of the Camel component that will service the requests. The component must be present in Camel registry and it must implement RestOpenApiConsumerFactory service provider interface. If not set CLASSPATH is searched for single component that implements RestOpenApiConsumerFactory SPI. Can be overridden in endpoint configuration.||string|
|mockIncludePattern|Used for inclusive filtering of mock data from directories. The pattern is using Ant-path style pattern. Multiple patterns can be specified separated by comma.|classpath:camel-mock/\*\*|string|
|restOpenapiProcessorStrategy|To use a custom strategy for how to process Rest DSL requests||object|
|host|Scheme hostname and port to direct the HTTP requests to in the form of https://hostname:port. Can be configured at the endpoint, component or in the corresponding REST configuration in the Camel Context. If you give this component a name (e.g. petstore) that REST configuration is consulted first, rest-openapi next, and global configuration last. If set overrides any value found in the OpenApi specification, RestConfiguration. Can be overridden in endpoint configuration.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|requestValidationEnabled|Enable validation of requests against the configured OpenAPI specification|false|boolean|
|componentName|Name of the Camel component that will perform the requests. The component must be present in Camel registry and it must implement RestProducerFactory service provider interface. If not set CLASSPATH is searched for single component that implements RestProducerFactory SPI. Can be overridden in endpoint configuration.||string|
|consumes|What payload type this component capable of consuming. Could be one type, like application/json or multiple types as application/json, application/xml; q=0.5 according to the RFC7231. This equates to the value of Accept HTTP header. If set overrides any value found in the OpenApi specification. Can be overridden in endpoint configuration||string|
|produces|What payload type this component is producing. For example application/json according to the RFC7231. This equates to the value of Content-Type HTTP header. If set overrides any value present in the OpenApi specification. Can be overridden in endpoint configuration.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|sslContextParameters|Customize TLS parameters used by the component. If not set defaults to the TLS parameters set in the Camel context||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|specificationUri|Path to the OpenApi specification file. The scheme, host base path are taken from this specification, but these can be overridden with properties on the component or endpoint level. If not given the component tries to load openapi.json resource from the classpath. Note that the host defined on the component and endpoint of this Component should contain the scheme, hostname and optionally the port in the URI syntax (i.e. http://api.example.com:8080). Overrides component configuration. The OpenApi specification can be loaded from different sources by prefixing with file: classpath: http: https:. Support for https is limited to using the JDK installed UrlHandler, and as such it can be cumbersome to setup TLS/SSL certificates for https (such as setting a number of javax.net.ssl JVM system properties). How to do that consult the JDK documentation for UrlHandler. Default value notice: By default loads openapi.json file|openapi.json|string|
|operationId|ID of the operation from the OpenApi specification. This is required when using producer||string|
|apiContextPath|Sets the context-path to use for servicing the OpenAPI specification||string|
|clientRequestValidation|Whether to enable validation of the client request to check if the incoming request is valid according to the OpenAPI specification|false|boolean|
|consumes|What payload type this component capable of consuming. Could be one type, like application/json or multiple types as application/json, application/xml; q=0.5 according to the RFC7231. This equates or multiple types as application/json, application/xml; q=0.5 according to the RFC7231. This equates to the value of Accept HTTP header. If set overrides any value found in the OpenApi specification and. in the component configuration||string|
|missingOperation|Whether the consumer should fail,ignore or return a mock response for OpenAPI operations that are not mapped to a corresponding route.|fail|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|consumerComponentName|Name of the Camel component that will service the requests. The component must be present in Camel registry and it must implement RestOpenApiConsumerFactory service provider interface. If not set CLASSPATH is searched for single component that implements RestOpenApiConsumerFactory SPI. Overrides component configuration.||string|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|mockIncludePattern|Used for inclusive filtering of mock data from directories. The pattern is using Ant-path style pattern. Multiple patterns can be specified separated by comma.|classpath:camel-mock/\*\*|string|
|restOpenapiProcessorStrategy|To use a custom strategy for how to process Rest DSL requests||object|
|basePath|API basePath, for example /v3. Default is unset, if set overrides the value present in OpenApi specification and in the component configuration.||string|
|host|Scheme hostname and port to direct the HTTP requests to in the form of https://hostname:port. Can be configured at the endpoint, component or in the corresponding REST configuration in the Camel Context. If you give this component a name (e.g. petstore) that REST configuration is consulted first, rest-openapi next, and global configuration last. If set overrides any value found in the OpenApi specification, RestConfiguration. Overrides all other configuration.||string|
|produces|What payload type this component is producing. For example application/json according to the RFC7231. This equates to the value of Content-Type HTTP header. If set overrides any value present in the OpenApi specification. Overrides all other configuration.||string|
|requestValidationEnabled|Enable validation of requests against the configured OpenAPI specification|false|boolean|
|componentName|Name of the Camel component that will perform the requests. The component must be present in Camel registry and it must implement RestProducerFactory service provider interface. If not set CLASSPATH is searched for single component that implements RestProducerFactory SPI. Overrides component configuration.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
