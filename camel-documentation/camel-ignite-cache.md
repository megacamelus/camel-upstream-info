# Ignite-cache

**Since Camel 2.17**

**Both producer and consumer are supported**

The Ignite Cache endpoint is one of camel-ignite endpoints that allow
you to interact with an [Ignite
Cache](https://apacheignite.readme.io/docs/data-grid). This offers both
a Producer (to invoke cache operations on an Ignite cache) and a
Consumer (to consume changes from a continuous query).

The cache value is always the body of the message, whereas the cache key
is always stored in the `IgniteConstants.IGNITE_CACHE_KEY` message
header.

Even if you configure a fixed operation in the endpoint URI, you can
vary it per-exchange by setting the
`IgniteConstants.IGNITE_CACHE_OPERATION` message header.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configurationResource|The resource from where to load the configuration. It can be a: URL, String or InputStream type.||object|
|ignite|To use an existing Ignite instance.||object|
|igniteConfiguration|Allows the user to set a programmatic ignite configuration.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheName|The cache name.||string|
|propagateIncomingBodyIfNoReturnValue|Sets whether to propagate the incoming body if the return type of the underlying Ignite operation is void.|true|boolean|
|treatCollectionsAsCacheObjects|Sets whether to treat Collections as cache objects or as Collections of items to insert/update/compute, etc.|false|boolean|
|autoUnsubscribe|Whether auto unsubscribe is enabled in the Continuous Query Consumer. Default value notice: ContinuousQuery.DFLT\_AUTO\_UNSUBSCRIBE|true|boolean|
|fireExistingQueryResults|Whether to process existing results that match the query. Used on initialization of the Continuous Query Consumer.|false|boolean|
|oneExchangePerUpdate|Whether to pack each update in an individual Exchange, even if multiple updates are received in one batch. Only used by the Continuous Query Consumer.|true|boolean|
|pageSize|The page size. Only used by the Continuous Query Consumer. Default value notice: ContinuousQuery.DFLT\_PAGE\_SIZE|1|integer|
|query|The Query to execute, only needed for operations that require it, and for the Continuous Query Consumer.||object|
|remoteFilter|The remote filter, only used by the Continuous Query Consumer.||object|
|timeInterval|The time interval for the Continuous Query Consumer. Default value notice: ContinuousQuery.DFLT\_TIME\_INTERVAL|0|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|cachePeekMode|The CachePeekMode, only needed for operations that require it (IgniteCacheOperation#SIZE).|ALL|object|
|failIfInexistentCache|Whether to fail the initialization if the cache doesn't exist.|false|boolean|
|operation|The cache operation to invoke. Possible values: GET, PUT, REMOVE, SIZE, REBALANCE, QUERY, CLEAR.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
