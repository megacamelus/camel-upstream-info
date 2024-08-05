# Vertx

**Since Camel 2.12**

**Both producer and consumer are supported**

The Vert.x component is for working with the [Vertx](http://vertx.io/)
[EventBus](https://vertx.io/docs/vertx-core/java/#event_bus).

The vertx [EventBus](https://vertx.io/docs/vertx-core/java/#event_bus)
sends and receives JSON events.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-vertx</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    vertx:channelName[?options]

# Connecting to the existing Vert.x instance

If you would like to connect to the Vert.x instance already existing in
your JVM, you can set the instance on the component level:

    Vertx vertx = ...;
    VertxComponent vertxComponent = new VertxComponent();
    vertxComponent.setVertx(vertx);
    camelContext.addComponent("vertx", vertxComponent);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname for creating an embedded clustered EventBus||string|
|port|Port for creating an embedded clustered EventBus||integer|
|timeout|Timeout in seconds to wait for clustered Vertx EventBus to be ready. The default value is 60.|60|integer|
|vertx|To use the given vertx EventBus instead of creating a new embedded EventBus||object|
|vertxOptions|Options to use for creating vertx||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|vertxFactory|To use a custom VertxFactory implementation||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|address|Sets the event bus address used to communicate||string|
|pubSub|Whether to use publish/subscribe instead of point to point when sending to a vertx endpoint.||boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
