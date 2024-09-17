# Hazelcast-map

**Since Camel 2.7**

**Both producer and consumer are supported**

The [Hazelcast](http://www.hazelcast.com/) Map component is one of Camel
Hazelcast Components which allows you to access a Hazelcast distributed
map.

# Options

# Map cache producer - to("hazelcast-map:foo")

If you want to store a value in a map, you can use the map cache
producer.

The map cache producer provides follow operations specified by
**CamelHazelcastOperationType** header:

-   put

-   putIfAbsent

-   get

-   getAll

-   keySet

-   containsKey

-   containsValue

-   delete

-   update

-   query

-   clear

-   evict

-   evictAll

You can call the samples with:

    template.sendBodyAndHeader("direct:[put|get|update|delete|query|evict]", "my-foo", HazelcastConstants.OBJECT_ID, "4711");

## Example for **put**:

Java DSL  
from("direct:put")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.PUT))
.toF("hazelcast-%sfoo", HazelcastConstants.MAP\_PREFIX);

Spring XML  
<route>  
<from uri="direct:put" />  
<setHeader name="hazelcast.operation.type">  
<constant>put</constant>  
</setHeader>  
<to uri="hazelcast-map:foo" />  
</route>

Sample for **put** with eviction:

Java DSL  
from("direct:put")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.PUT))
.setHeader(HazelcastConstants.TTL\_VALUE, constant(Long.valueOf(1)))
.setHeader(HazelcastConstants.TTL\_UNIT, constant(TimeUnit.MINUTES))
.toF("hazelcast-%sfoo", HazelcastConstants.MAP\_PREFIX);

Spring XML  
<route>  
<from uri="direct:put" />  
<setHeader name="hazelcast.operation.type">  
<constant>put</constant>  
</setHeader>  
<setHeader name="HazelcastConstants.TTL_VALUE">  
<simple resultType="java.lang.Long">1</simple>  
</setHeader>  
<setHeader name="HazelcastConstants.TTL_UNIT">  
<simple resultType="java.util.concurrent.TimeUnit">TimeUnit.MINUTES</simple>  
</setHeader>  
<to uri="hazelcast-map:foo" />  
</route>

## Example for **get**:

Java DSL  
from("direct:get")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.GET))
.toF("hazelcast-%sfoo", HazelcastConstants.MAP\_PREFIX)
.to("seda:out");

Spring XML  
<route>  
<from uri="direct:get" />  
<setHeader name="hazelcast.operation.type">  
<constant>get</constant>  
</setHeader>  
<to uri="hazelcast-map:foo" />  
<to uri="seda:out" />  
</route>

## Example for **update**:

Java DSL  
from("direct:update")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.UPDATE))
.toF("hazelcast-%sfoo", HazelcastConstants.MAP\_PREFIX);

Spring XML  
<route>  
<from uri="direct:update" />  
<setHeader name="hazelcast.operation.type">  
<constant>update</constant>  
</setHeader>  
<to uri="hazelcast-map:foo" />  
</route>

## Example for **delete**:

Java DSL  
from("direct:delete")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.DELETE))
.toF("hazelcast-%sfoo", HazelcastConstants.MAP\_PREFIX);

Spring XML  
<route>  
<from uri="direct:delete" />  
<setHeader name="hazelcast.operation.type">  
<constant>delete</constant>  
</setHeader>  
<to uri="hazelcast-map:foo" />  
</route>

## Example for **query**

Java DSL  
from("direct:query")
.setHeader(HazelcastConstants.OPERATION, constant(HazelcastOperation.QUERY))
.toF("hazelcast-%sfoo", HazelcastConstants.MAP\_PREFIX)
.to("seda:out");

Spring XML  
<route>  
<from uri="direct:query" />  
<setHeader name="hazelcast.operation.type">  
<constant>query</constant>  
</setHeader>  
<to uri="hazelcast-map:foo" />  
<to uri="seda:out" />  
</route>

For the query operation Hazelcast offers an SQL like syntax to query
your distributed map.

    String q1 = "bar > 1000";
    template.sendBodyAndHeader("direct:query", null, HazelcastConstants.QUERY, q1);

# Map cache consumer - from("hazelcast-map:foo")

Hazelcast provides event listeners on their data grid. If you want to be
notified if a cache is manipulated, you can use the map consumer. There
are four events: **put**, **update**, **delete** and **envict**. The
event type will be stored in the "**hazelcast.listener.action**" header
variable. The map consumer provides some additional information inside
these variables:

Header Variables inside the response message:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHazelcastListenerTime</code></p></td>
<td style="text-align: left;"><p><code>Long</code></p></td>
<td style="text-align: left;"><p>time of the event in millis</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHazelcastListenerType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>the map consumer sets here
"cachelistener"</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHazelcastListenerAction</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>type of event (<strong>added</strong>,
<strong>updated</strong>, <strong>envicted</strong> and
<strong>removed</strong>).</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHazelcastObjectId</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>the oid of the object</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelHazelcastCacheName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>the name of the cache (e.g.,
"foo")</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelHazelcastCacheType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>the type of the cache (e.g.,
map)</p></td>
</tr>
</tbody>
</table>

The object value will be stored within **put** and **update** actions
inside the message body.

Here’s a sample:

    fromF("hazelcast-%sfoo", HazelcastConstants.MAP_PREFIX)
    .log("object...")
    .choice()
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.ADDED))
             .log("...added")
             .to("mock:added")
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.ENVICTED))
             .log("...envicted")
             .to("mock:envicted")
        .when(header(HazelcastConstants.LISTENER_ACTION).isEqualTo(HazelcastConstants.UPDATED))
             .log("...updated")
             .to("mock:updated")
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
