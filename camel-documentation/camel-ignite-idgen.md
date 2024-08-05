# Ignite-idgen

**Since Camel 2.17**

**Only producer is supported**

The Ignite ID Generator endpoint is one of camel-ignite endpoints that
allow you to interact with [Ignite Atomic Sequences and ID
Generators](https://apacheignite.readme.io/docs/id-generator).

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configurationResource|The resource from where to load the configuration. It can be a: URL, String or InputStream type.||object|
|ignite|To use an existing Ignite instance.||object|
|igniteConfiguration|Allows the user to set a programmatic ignite configuration.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|The sequence name.||string|
|batchSize|The batch size.||integer|
|initialValue|The initial value.|0|integer|
|operation|The operation to invoke on the Ignite ID Generator. Superseded by the IgniteConstants.IGNITE\_IDGEN\_OPERATION header in the IN message. Possible values: ADD\_AND\_GET, GET, GET\_AND\_ADD, GET\_AND\_INCREMENT, INCREMENT\_AND\_GET.||object|
|propagateIncomingBodyIfNoReturnValue|Sets whether to propagate the incoming body if the return type of the underlying Ignite operation is void.|true|boolean|
|treatCollectionsAsCacheObjects|Sets whether to treat Collections as cache objects or as Collections of items to insert/update/compute, etc.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
