# Hazelcast-queue

**Since Camel 2.7**

**Both producer and consumer are supported**

The [Hazelcast](http://www.hazelcast.com/) Queue component is one of
Camel Hazelcast Components which allows you to access Hazelcast
distributed queue.

# Queue producer – to(“hazelcast-queue:foo”)

The queue producer provides 12 operations:

-   add

-   put

-   poll

-   peek

-   offer

-   removevalue

-   remainingCapacity

-   removeAll

-   removeIf

-   drainTo

-   take

-   retainAll

## Sample for **add**:

    from("direct:add")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.ADD))
    .toF("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX);

## Sample for **put**:

    from("direct:put")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.PUT))
    .toF("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX);

## Sample for **poll**:

    from("direct:poll")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.POLL))
    .toF("hazelcast:%sbar", HazelcastConstants.QUEUE_PREFIX);

## Sample for **peek**:

    from("direct:peek")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.PEEK))
    .toF("hazelcast:%sbar", HazelcastConstants.QUEUE_PREFIX);

## Sample for **offer**:

    from("direct:offer")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.OFFER))
    .toF("hazelcast:%sbar", HazelcastConstants.QUEUE_PREFIX);

## Sample for **removevalue**:

    from("direct:removevalue")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.REMOVE_VALUE))
    .toF("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX);

## Sample for **remaining capacity**:

    from("direct:remaining-capacity").setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.REMAINING_CAPACITY)).to(
    String.format("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX));

## Sample for **remove all**:

    from("direct:removeAll").setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.REMOVE_ALL)).to(
    String.format("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX));

## Sample for **remove if**:

    from("direct:removeIf").setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.REMOVE_IF)).to(
    String.format("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX));

## Sample for **drain to**:

    from("direct:drainTo").setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.DRAIN_TO)).to(
    String.format("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX));

## Sample for **take**:

    from("direct:take").setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.TAKE)).to(
    String.format("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX));

## Sample for **retain all**:

    from("direct:retainAll").setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.RETAIN_ALL)).to(
    String.format("hazelcast-%sbar", HazelcastConstants.QUEUE_PREFIX));

# Queue consumer – from(“hazelcast-queue:foo”)

The queue consumer provides two different modes:

-   Poll

-   Listen

Sample for **Poll** mode

    fromF("hazelcast-%sfoo?queueConsumerMode=Poll", HazelcastConstants.QUEUE_PREFIX)).to("mock:result");

In this way, the consumer will poll the queue and return the head of the
queue or null after a timeout.

In Listen mode instead, the consumer will listen for events on queue.

The queue consumer in Listen mode provides 2 operations: \* add \*
remove

Sample for **Listen** mode

    fromF("hazelcast-%smm", HazelcastConstants.QUEUE_PREFIX)
       .log("object...")
       .choice()
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.ADDED))
                .log("...added")
            .to("mock:added")
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.REMOVED))
            .log("...removed")
            .to("mock:removed")
        .otherwise()
            .log("fail!");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|hazelcastInstance|The hazelcast instance reference which can be used for hazelcast endpoint. If you don't specify the instance reference, camel use the default hazelcast instance from the camel-hazelcast instance.||object|
|hazelcastMode|The hazelcast mode reference which kind of instance should be used. If you don't specify the mode, then the node mode will be the default.|node|string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheName|The name of the cache||string|
|defaultOperation|To specify a default operation to use, if no operation header has been provided.||object|
|hazelcastConfigUri|Hazelcast configuration file.||string|
|hazelcastInstance|The hazelcast instance reference which can be used for hazelcast endpoint.||object|
|hazelcastInstanceName|The hazelcast instance reference name which can be used for hazelcast endpoint. If you don't specify the instance reference, camel use the default hazelcast instance from the camel-hazelcast instance.||string|
|pollingTimeout|Define the polling timeout of the Queue consumer in Poll mode|10000|integer|
|poolSize|Define the Pool size for Queue Consumer Executor|1|integer|
|queueConsumerMode|Define the Queue Consumer mode: Listen or Poll|Listen|object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
