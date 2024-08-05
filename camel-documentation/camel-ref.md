# Ref

**Since Camel 1.2**

**Both producer and consumer are supported**

The Ref component is used for lookup of existing endpoints bound in the
Registry.

# URI format

    ref:someName[?options]

Where **someName** is the name of an endpoint in the Registry (usually,
but not always, the Spring registry). If you are using the Spring
registry, `someName` would be the bean ID of an endpoint in the Spring
registry.

# Runtime lookup

This component can be used when you need dynamic discovery of endpoints
in the Registry where you can compute the URI at runtime. Then you can
look up the endpoint using the following code:

    // lookup the endpoint
    String myEndpointRef = "bigspenderOrder";
    Endpoint endpoint = context.getEndpoint("ref:" + myEndpointRef);
    
    Producer producer = endpoint.createProducer();
    Exchange exchange = producer.createExchange();
    exchange.getIn().setBody(payloadToSend);
    // send the exchange
    producer.process(exchange);

With Spring XML, you could have a list of endpoints defined in the
Registry such as:

    <camelContext id="camel" xmlns="http://activemq.apache.org/camel/schema/spring">
        <endpoint id="normalOrder" uri="activemq:order.slow"/>
        <endpoint id="bigspenderOrder" uri="activemq:order.high"/>
    </camelContext>

# Sample

Bind endpoints to the Camel registry:

    context.getRegistry().bind("endpoint1", context.getEndpoint("direct:start"));
    context.getRegistry().bind("endpoint2", context.getEndpoint("log:end"));

Use the `ref` URI scheme to refer to endpoint’s bond to the Camel
registry:

    public class MyRefRoutes extends RouteBuilder {
        @Override
        public void configure() {
            // direct:start -> log:end
            from("ref:endpoint1")
                .to("ref:endpoint2");
        }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name of endpoint to lookup in the registry.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
