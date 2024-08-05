# Plc4x

**Since Camel 3.20**

**Both producer and consumer are supported**

The Camel Component for PLC4X allows you to create routes using the
PLC4X API to read from a Programmable Logic Controllers (PLC) device or
write to it.

It supports various protocols by adding the driver dependencies:

-   Allen Bradley ETH

-   Automation Device Specification (ADS)

-   CANopen

-   EtherNet/IP

-   Firmata

-   KNXnet/IP

-   Modbus (TCP/UDP/Serial)

-   Open Platform Communications Unified Architecture (OPC UA)

-   Step7 (S7)

The list of supported protocols is growing in
[PLC4X](https://plc4x.apache.org). There are good chance that they will
work out of the box just by adding the driver dependency. You can check
[here](https://plc4x.apache.org/users/protocols/index.html).

# URI Format

    plc4x://driver[?options]

The bucket will be created if it doesn’t already exist.

You can append query options to the URI in the following format:
`?options=value&option2=value&...`.

# Dependencies

Maven users will need to add the following dependency to their
`pom.xml`.

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-plc4x</artifactId>
        <version>${camel-version}</version>
    </dependency>

where `${camel-version}` must be replaced by the actual version of
Camel.

# Consumer

The consumer supports one-time reading or Triggered Reading. To read
from the PLC, use a `Map<String,String>` containing the Alias and
Queries for the Data you want (tags).

You can configure the *tags* using `tag.key=value` in the URI, and you
can repeat this for multiple tags.

The Body created by the Consumer will be a `Map<String,Object>`
containing the Aliases and their associated value read from the PLC.

# Polling Consumer

The polling consumer supports consecutive reading. The input and output
are the same as for the regular consumer.

# Producer

To write data to the PLC, we also use a `Map`. The difference with the
Producer is that the `Value` of the Map has also to be a `Map`. Also,
this `Map` has to be set into the `Body` of the `Message`

The used `Map` would be a `Map<String,Map<String,Object>` where the
`Map<String,Object>` represent the Query and the data we want to write
to it.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|driver|PLC4X connection string for the connection to the target||string|
|autoReconnect|Whether to reconnect when no connection is present upon doing a request|false|boolean|
|period|Interval on which the Trigger should be checked||integer|
|tags|Tags as key/values from the Map to use in query||object|
|trigger|Query to a trigger. On a rising edge of the trigger, the tags will be read once||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
