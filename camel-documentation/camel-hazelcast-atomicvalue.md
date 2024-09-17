# Hazelcast-atomicvalue

**Since Camel 2.7**

**Only producer is supported**

The [Hazelcast](http://www.hazelcast.com/) atomic number component is
one of Camel Hazelcast Components which allows you to access Hazelcast
atomic number. An atomic number is an object that simply provides a grid
wide number (long).

# atomic number producer - to("hazelcast-atomicvalue:foo")

The operations for this producer are:

-   setvalue (set the number with a given value)

-   get

-   increment (+1)

-   decrement (-1)

-   destroy

-   compareAndSet

-   getAndAdd

## Example for **set**:

Java DSL  
from("direct:set")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.SET\_VALUE))
.toF("hazelcast-%sfoo", HazelcastConstants.ATOMICNUMBER\_PREFIX);

Spring XML  
<route>  
<from uri="direct:set" />  
<setHeader name="hazelcast.operation.type">  
<constant>setvalue</constant>  
</setHeader>  
<to uri="hazelcast-atomicvalue:foo" />  
</route>

Provide the value to set inside the message body (here the value is 10):
`template.sendBody("direct:set", 10);`

## Example for **get**:

Java DSL  
from("direct:get")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.GET))
.toF("hazelcast-%sfoo", HazelcastConstants.ATOMICNUMBER\_PREFIX);

Spring XML  
<route>  
<from uri="direct:get" />  
<setHeader name="hazelcast.operation.type">  
<constant>get</constant>  
</setHeader>  
<to uri="hazelcast-atomicvalue:foo" />  
</route>

You can get the number with
`long body = template.requestBody("direct:get", null, Long.class);`.

## Example for **increment**:

Java DSL  
from("direct:increment")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.INCREMENT))
.toF("hazelcast-%sfoo", HazelcastConstants.ATOMICNUMBER\_PREFIX);

Spring XML  
<route>  
<from uri="direct:increment" />  
<setHeader name="hazelcast.operation.type">  
<constant>increment</constant>  
</setHeader>  
<to uri="hazelcast-atomicvalue:foo" />  
</route>

The actual value (after increment) will be provided inside the message
body.

## Example for **decrement**:

Java DSL  
from("direct:decrement")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.DECREMENT))
.toF("hazelcast-%sfoo", HazelcastConstants.ATOMICNUMBER\_PREFIX);

Spring XML  
<route>  
<from uri="direct:decrement" />  
<setHeader name="hazelcast.operation.type">  
<constant>decrement</constant>  
</setHeader>  
<to uri="hazelcast-atomicvalue:foo" />  
</route>

The actual value (after decrement) will be provided inside the message
body.

## Example for **destroy**

Java DSL  
from("direct:destroy")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.DESTROY))
.toF("hazelcast-%sfoo", HazelcastConstants.ATOMICNUMBER\_PREFIX);

Spring XML  
<route>  
<from uri="direct:destroy" />  
<setHeader name="hazelcast.operation.type">  
<constant>destroy</constant>  
</setHeader>  
<to uri="hazelcast-atomicvalue:foo" />  
</route>

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
