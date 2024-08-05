# Hazelcast-instance

**Since Camel 2.7**

**Only consumer is supported**

The [Hazelcast](http://www.hazelcast.com/) instance component is one of
Camel Hazelcast Components which allows you to consume join/leave events
of the cache instance in the cluster. Hazelcast makes sense in one
single "server node", but it’s extremely powerful in a clustered
environment.

# instance consumer - from("hazelcast-instance:foo")

The instance consumer fires if a new cache instance joins or leaves the
cluster.

Here’s a sample:

    fromF("hazelcast-%sfoo", HazelcastConstants.INSTANCE_PREFIX)
    .log("instance...")
    .choice()
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.ADDED))
            .log("...added")
            .to("mock:added")
        .otherwise()
            .log("...removed")
            .to("mock:removed");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
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
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
