# Hazelcast-multimap

**Since Camel 2.7**

**Both producer and consumer are supported**

The [Hazelcast](http://www.hazelcast.com/) Multimap component is one of
Camel Hazelcast Components which allows you to access Hazelcast
distributed multimap.

# Options

# multimap cache producer - to("hazelcast-multimap:foo")

A multimap is a cache where you can store n values to one key.

The multimap producer provides eight operations:

-   put

-   get

-   removevalue

-   delete

-   containsKey

-   containsValue

-   clear

-   valueCount

## Sample for **put**:

Java DSL  
from("direct:put")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.PUT))
.to(String.format("hazelcast-%sbar", HazelcastConstants.MULTIMAP\_PREFIX));

Spring XML  
<route>  
<from uri="direct:put" />  
<log message="put.."/>  
<setHeader name="hazelcast.operation.type">  
<constant>put</constant>  
</setHeader>  
<to uri="hazelcast-multimap:foo" />  
</route>

## Sample for **removevalue**:

Java DSL  
from("direct:removevalue")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.REMOVE\_VALUE))
.toF("hazelcast-%sbar", HazelcastConstants.MULTIMAP\_PREFIX);

Spring XML  
<route>  
<from uri="direct:removevalue" />  
<log message="removevalue..."/>  
<setHeader name="hazelcast.operation.type">  
<constant>removevalue</constant>  
</setHeader>  
<to uri="hazelcast-multimap:foo" />  
</route>

To remove a value you have to provide the value you want to remove
inside the message body. If you have a multimap object
``\{`key: "4711" values: { "my-foo", "my-bar"``}}\` you have to put
`my-foo` inside the message body to remove the `my-foo` value.

## Sample for **get**:

Java DSL  
from("direct:get")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.GET))
.toF("hazelcast-%sbar", HazelcastConstants.MULTIMAP\_PREFIX)
.to("seda:out");

Spring XML  
<route>  
<from uri="direct:get" />  
<log message="get.."/>  
<setHeader name="hazelcast.operation.type">  
<constant>get</constant>  
</setHeader>  
<to uri="hazelcast-multimap:foo" />  
<to uri="seda:out" />  
</route>

## Sample for **delete**:

Java DSL  
from("direct:delete")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.DELETE))
.toF("hazelcast-%sbar", HazelcastConstants.MULTIMAP\_PREFIX);

Spring XML  
<route>  
<from uri="direct:delete" />  
<log message="delete.."/>  
<setHeader name="hazelcast.operation.type">  
<constant>delete</constant>  
</setHeader>  
<to uri="hazelcast-multimap:foo" />  
</route>

You can call them in your test class with:

    template.sendBodyAndHeader("direct:[put|get|removevalue|delete]", "my-foo", HazelcastConstants.OBJECT_ID, "4711");

# multimap cache consumer - from("hazelcast-multimap:foo")

For the multimap cache this component provides the same listeners /
variables as for the map cache consumer (except the update and eviction
listener). The only difference is the **multimap** prefix inside the
URI. Here is a sample:

    fromF("hazelcast-%sbar", HazelcastConstants.MULTIMAP_PREFIX)
    .log("object...")
    .choice()
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.ADDED))
            .log("...added")
                    .to("mock:added")
            //.when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.ENVICTED))
            //        .log("...envicted")
            //        .to("mock:envicted")
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
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
