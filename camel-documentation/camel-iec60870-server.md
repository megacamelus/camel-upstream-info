# Iec60870-server

**Since Camel 2.20**

**Both producer and consumer are supported**

The **IEC 60870-5-104 Server** component provides access to IEC 60870
servers using the [Eclipse NeoSCADA](http://eclipse.org/eclipsescada)
implementation.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-iec60870</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

The URI syntax of the endpoint is:

    iec60870-server:host:port/00-01-02-03-04

The information object address is encoded in the path in the syntax
above. Please note that always the full, 5-octet address format is being
used. Unused octets have to be filled with zero.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|defaultConnectionOptions|Default connection options||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|uriPath|The object information address||object|
|dataModuleOptions|Data module options||object|
|filterNonExecute|Filter out all requests which don't have the execute bit set|true|boolean|
|protocolOptions|Protocol options||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|acknowledgeWindow|Parameter W - Acknowledgment window.|10|integer|
|adsuAddressType|The common ASDU address size. May be either SIZE\_1 or SIZE\_2.||object|
|causeOfTransmissionType|The cause of transmission type. May be either SIZE\_1 or SIZE\_2.||object|
|informationObjectAddressType|The information address size. May be either SIZE\_1, SIZE\_2 or SIZE\_3.||object|
|maxUnacknowledged|Parameter K - Maximum number of un-acknowledged messages.|15|integer|
|timeout1|Timeout T1 in milliseconds.|15000|integer|
|timeout2|Timeout T2 in milliseconds.|10000|integer|
|timeout3|Timeout T3 in milliseconds.|20000|integer|
|causeSourceAddress|Whether to include the source address||integer|
|connectionTimeout|Timeout in millis to wait for client to establish a connected connection.|10000|integer|
|ignoreBackgroundScan|Whether background scan transmissions should be ignored.|true|boolean|
|ignoreDaylightSavingTime|Whether to ignore or respect DST|false|boolean|
|timeZone|The timezone to use. May be any Java time zone string|UTC|object|
|connectionId|An identifier grouping connection instances||string|
