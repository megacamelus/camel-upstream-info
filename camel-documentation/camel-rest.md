# Rest

**Since Camel 2.14**

**Both producer and consumer are supported**

The REST component allows defining REST endpoints (consumer) using the
Rest DSL and plugin to other Camel components as the REST transport.

The REST component can also be used as a client (producer) to call REST
services.

# URI format

    rest://method:path[:uriTemplate]?[options]

# Supported REST components

The following components support the REST consumer (Rest DSL):

-   camel-netty-http

-   camel-jetty

-   camel-servlet

-   camel-undertow

-   camel-platform-http

The following components support the REST producer:

-   camel-http

-   camel-netty-http

-   camel-undertow

-   camel-vertx-http

# Usage

## Path and uriTemplate syntax

The path and uriTemplate option is defined using a REST syntax where you
define the REST context path using support for parameters.

If no uriTemplate is configured then `path` option works the same way.

It does not matter if you configure only `path` or if you configure both
options. Though configuring both a path and uriTemplate is a more common
practice with REST.

The following is a Camel route using a path only

    from("rest:get:hello")
      .transform().constant("Bye World");

And the following route uses a parameter which is mapped to a Camel
header with the key "me".

    from("rest:get:hello/{me}")
      .transform().simple("Bye ${header.me}");

The following examples have configured a base path as "hello" and then
have two REST services configured using uriTemplates.

    from("rest:get:hello:/{me}")
      .transform().simple("Hi ${header.me}");
    
    from("rest:get:hello:/french/{me}")
      .transform().simple("Bonjour ${header.me}");

# Examples

## Rest producer examples

You can use the REST component to call REST services like any other
Camel component.

For example, to call a REST service on using `hello/{me}` you can do

    from("direct:start")
      .to("rest:get:hello/{me}");

And then the dynamic value `{me}` is mapped to a Camel message with the
same name. So to call this REST service, you can send an empty message
body and a header as shown:

    template.sendBodyAndHeader("direct:start", null, "me", "Donald Duck");

The Rest producer needs to know the hostname and port of the REST
service, which you can configure using the host option as shown:

    from("direct:start")
      .to("rest:get:hello/{me}?host=myserver:8080/foo");

Instead of using the host option, you can configure the host on the
`restConfiguration` as shown:

    restConfiguration().host("myserver:8080/foo");
    
    from("direct:start")
      .to("rest:get:hello/{me}");

You can use the `producerComponent` to select which Camel component to
use as the HTTP client, for example to use http, you can do:

    restConfiguration().host("myserver:8080/foo").producerComponent("http");
    
    from("direct:start")
      .to("rest:get:hello/{me}");

## Rest producer binding

The REST producer supports binding using JSON or XML like the rest-dsl
does.

For example, to use jetty with JSON binding mode turned on, you can
configure this in the REST configuration:

    restConfiguration().component("jetty").host("localhost").port(8080).bindingMode(RestBindingMode.json);
    
    from("direct:start")
      .to("rest:post:user");

Then when calling the REST service using the REST producer, it will
automatically bind any POJOs to JSON before calling the REST service:

      UserPojo user = new UserPojo();
      user.setId(123);
      user.setName("Donald Duck");
    
      template.sendBody("direct:start", user);

In the example above we send a POJO instance `UserPojo` as the message
body. And because we have turned on JSON binding in the REST
configuration, then the POJO will be marshalled from POJO to JSON before
calling the REST service.

However, if you want to also perform binding for the response message
(e.g., what the REST service sends back, as response) you would need to
configure the `outType` option to specify what is the class name of the
POJO to unmarshal from JSON to POJO.

For example, if the REST service returns a JSON payload that binds to
`com.foo.MyResponsePojo` you can configure this as shown:

      restConfiguration().component("jetty").host("localhost").port(8080).bindingMode(RestBindingMode.json);
    
      from("direct:start")
        .to("rest:post:user?outType=com.foo.MyResponsePojo");

You must configure `outType` option if you want POJO binding to happen
for the response messages received from calling the REST service.

## More examples

See Rest DSL, which offers more examples and how you can use the Rest
DSL to define those in a nicer, restful way.

There is a **camel-example-servlet-rest-tomcat** example in the Apache
Camel distribution, that demonstrates how to use the Rest DSL with
Servlet as transport that can be deployed on Apache Tomcat, or similar
web containers.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|consumerComponentName|The Camel Rest component to use for the consumer REST transport, such as jetty, servlet, undertow. If no component has been explicitly configured, then Camel will lookup if there is a Camel component that integrates with the Rest DSL, or if a org.apache.camel.spi.RestConsumerFactory is registered in the registry. If either one is found, then that is being used.||string|
|apiDoc|The swagger api doc resource to use. The resource is loaded from classpath by default and must be in JSON format.||string|
|host|Host and port of HTTP service to use (override host in swagger schema)||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|producerComponentName|The Camel Rest component to use for the producer REST transport, such as http, undertow. If no component has been explicitly configured, then Camel will lookup if there is a Camel component that integrates with the Rest DSL, or if a org.apache.camel.spi.RestProducerFactory is registered in the registry. If either one is found, then that is being used.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|method|HTTP method to use.||string|
|path|The base path, can use \&#42; as path suffix to support wildcard HTTP route matching.||string|
|uriTemplate|The uri template||string|
|consumes|Media type such as: 'text/xml', or 'application/json' this REST service accepts. By default we accept all kinds of types.||string|
|inType|To declare the incoming POJO binding type as a FQN class name||string|
|outType|To declare the outgoing POJO binding type as a FQN class name||string|
|produces|Media type such as: 'text/xml', or 'application/json' this REST service returns.||string|
|routeId|Name of the route this REST services creates||string|
|consumerComponentName|The Camel Rest component to use for the consumer REST transport, such as jetty, servlet, undertow. If no component has been explicitly configured, then Camel will lookup if there is a Camel component that integrates with the Rest DSL, or if a org.apache.camel.spi.RestConsumerFactory is registered in the registry. If either one is found, then that is being used.||string|
|description|Human description to document this REST service||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|apiDoc|The openapi api doc resource to use. The resource is loaded from classpath by default and must be in JSON format.||string|
|bindingMode|Configures the binding mode for the producer. If set to anything other than 'off' the producer will try to convert the body of the incoming message from inType to the json or xml, and the response from json or xml to outType.||object|
|host|Host and port of HTTP service to use (override host in openapi schema)||string|
|producerComponentName|The Camel Rest component to use for the producer REST transport, such as http, undertow. If no component has been explicitly configured, then Camel will lookup if there is a Camel component that integrates with the Rest DSL, or if a org.apache.camel.spi.RestProducerFactory is registered in the registry. If either one is found, then that is being used.||string|
|queryParameters|Query parameters for the HTTP service to call. The query parameters can contain multiple parameters separated by ampersand such such as foo=123\&bar=456.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
