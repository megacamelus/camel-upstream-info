# Hazelcast-ringbuffer

**Since Camel 2.16**

**Only producer is supported**

The [Hazelcast](http://www.hazelcast.com/) ringbuffer component is one
of Camel Hazelcast Components which allows you to access Hazelcast
ringbuffer. Ringbuffer is a distributed data structure where the data is
stored in a ring-like structure. You can think of it as a circular array
with a certain capacity.

# ringbuffer cache producer

The ringbuffer producer provides 5 operations:

-   add

-   readOnceHead

-   readOnceTail

-   remainingCapacity

-   capacity

## Sample for **put**:

Java DSL  
from("direct:put")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.ADD))
.to(String.format("hazelcast-%sbar", HazelcastConstants.RINGBUFFER\_PREFIX));

Spring XML  
<route>  
<from uri="direct:put" />  
<log message="put.."/>  
<setHeader name="hazelcast.operation.type">  
<constant>add</constant>  
</setHeader>  
<to uri="hazelcast-ringbuffer:foo" />  
</route>

## Sample for **readonce from head**:

Java DSL:

    from("direct:get")
    .setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.READ_ONCE_HEAD))
    .toF("hazelcast-%sbar", HazelcastConstants.RINGBUFFER_PREFIX)
    .to("seda:out");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
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
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
