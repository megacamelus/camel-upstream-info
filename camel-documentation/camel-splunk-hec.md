# Splunk-hec

**Since Camel 3.3**

**Only producer is supported**

The Splunk HEC component allows sending data to Splunk using the [HTTP
Event
Collector](https://dev.splunk.com/enterprise/docs/dataapps/httpeventcollector/).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-splunk-hec</artifactId>
        <version>${camel-version}</version>
    </dependency>

# URI format

    splunk-hec:[splunkURL]?[options]

# Usage

## Message body

The body must be serializable to JSON, so it may be sent to Splunk.

A `String` or a `java.util.Map` object can be serialized easily.

# Use Cases

The Splunk HEC endpoint may be used to stream data to Splunk for
ingestion.

It is meant for high-volume ingestion of machine data.

## Configuring the index time

By default, the index time for an event is when the event makes it to
the Splunk server.

    from("direct:start")
            .to("splunk-hec://localhost:8080?token=token");

If you are ingesting a large enough dataset with a big enough lag, then
the time the event hits the server and when that event actually happened
could be skewed. If you want to override the index time, you can do so.

    from("kafka:logs")
            .setHeader(SplunkHECConstants.INDEX_TIME, simple("${headers[kafka.HEADERS].lastKey('TIME')}"))
            .to("splunk-hec://localhost:8080?token=token");
    
    from("kafka:logs")
            .toD("splunk-hec://localhost:8080?token=token&time=${headers[kafka.HEADERS].lastKey('TIME')}");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|sslContextParameters|Sets the default SSL configuration to use for all the endpoints. You can also configure it directly at the endpoint level.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|splunkURL|Splunk Host and Port (example: my\_splunk\_server:8089)||string|
|bodyOnly|Send only the message body|false|boolean|
|headersOnly|Send only message headers|false|boolean|
|host|Splunk host field of the event message. This is not the Splunk host to connect to.||string|
|index|Splunk index to write to|camel|string|
|source|Splunk source argument|camel|string|
|sourceType|Splunk sourcetype argument|camel|string|
|splunkEndpoint|Splunk endpoint Defaults to /services/collector/event To write RAW data like JSON use /services/collector/raw For a list of all endpoints refer to splunk documentation (HTTP Event Collector REST API endpoints) Example for Spunk 8.2.x: https://docs.splunk.com/Documentation/SplunkCloud/8.2.2203/Data/HECRESTendpoints To extract timestamps in Splunk8.0 /services/collector/eventauto\_extract\_timestamp=true Remember to utilize RAW{} for questionmarks or slashes in parameters.|/services/collector/event|string|
|sslContextParameters|SSL configuration||object|
|time|Time this even occurred. By default, the time will be when this event hits the splunk server.||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|https|Contact HEC over https.|true|boolean|
|skipTlsVerify|Splunk HEC TLS verification.|false|boolean|
|token|Splunk HEC token (this is the token created for HEC and not the user's token)||string|
