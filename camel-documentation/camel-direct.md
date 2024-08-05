# Direct

**Since Camel 1.0**

**Both producer and consumer are supported**

The Direct component provides direct, synchronous invocation of any
consumers when a producer sends a message exchange. This endpoint can be
used to connect existing routes in the **same** camel context.

**Asynchronous**

The [SEDA](#seda-component.adoc) component provides asynchronous
invocation of any consumers when a producer sends a message exchange.

# URI format

    direct:someId[?options]

Where *someId* can be any string to uniquely identify the endpoint.

# Samples

In the route below, we use the direct component to link the two routes
together:

Java  
from("activemq:queue:order.in")
.to("bean:orderServer?method=validate")
.to("direct:processOrder");

    from("direct:processOrder")
        .to("bean:orderService?method=process")
        .to("activemq:queue:order.out");

Spring XML  
<route>  
<from uri="activemq:queue:order.in"/>  
<to uri="bean:orderService?method=validate"/>  
<to uri="direct:processOrder"/>  
</route>

    <route>
     <from uri="direct:processOrder"/>
     <to uri="bean:orderService?method=process"/>
     <to uri="activemq:queue:order.out"/>
    </route>

See also samples from the [SEDA](#seda-component.adoc) component, how
they can be used together.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|block|If sending a message to a direct endpoint which has no active consumer, then we can tell the producer to block and wait for the consumer to become active.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|timeout|The timeout value to use if block is enabled.|30000|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name of direct endpoint||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|block|If sending a message to a direct endpoint which has no active consumer, then we can tell the producer to block and wait for the consumer to become active.|true|boolean|
|failIfNoConsumers|Whether the producer should fail by throwing an exception, when sending to a DIRECT endpoint with no active consumers.|true|boolean|
|timeout|The timeout value to use if block is enabled.|30000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|synchronous|Whether synchronous processing is forced. If enabled then the producer thread, will be forced to wait until the message has been completed before the same thread will continue processing. If disabled (default) then the producer thread may be freed and can do other work while the message is continued processed by other threads (reactive).|false|boolean|
