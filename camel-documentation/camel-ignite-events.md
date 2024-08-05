# Ignite-events

**Since Camel 2.17**

**Only consumer is supported**

The Ignite Events endpoint is one of camel-ignite endpoints which allows
you to [receive events](https://apacheignite.readme.io/docs/events) from
the Ignite cluster by creating a local event listener.

The Exchanges created by this consumer put the received Event object
into the body of the *IN* message.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|configurationResource|The resource from where to load the configuration. It can be a: URL, String or InputStream type.||object|
|ignite|To use an existing Ignite instance.||object|
|igniteConfiguration|Allows the user to set a programmatic ignite configuration.||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|endpointId|The endpoint ID (not used).||string|
|clusterGroupExpression|The cluster group expression.||object|
|events|The event types to subscribe to as a comma-separated string of event constants as defined in EventType. For example: EVT\_CACHE\_ENTRY\_CREATED,EVT\_CACHE\_OBJECT\_REMOVED,EVT\_IGFS\_DIR\_CREATED.|EVTS\_ALL|string|
|propagateIncomingBodyIfNoReturnValue|Sets whether to propagate the incoming body if the return type of the underlying Ignite operation is void.|true|boolean|
|treatCollectionsAsCacheObjects|Sets whether to treat Collections as cache objects or as Collections of items to insert/update/compute, etc.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
