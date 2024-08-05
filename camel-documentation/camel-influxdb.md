# Influxdb

**Since Camel 2.18**

**Only producer is supported**

This component allows you to interact with
[InfluxDB](https://influxdata.com/time-series-platform/influxdb/) v1, a
time series database.

The native body type for this component is `Point` (the native influxdb
class). However, it can also accept `Map<String, Object>` as message
body, and it will get converted to `Point.class`, please note that the
map must contain an element with `InfluxDbConstants.MEASUREMENT_NAME` as
key.

Additionally, you may register your own Converters to your data type to
`Point`, or use the (un)marshalling tools provided by Camel.

For InfluxDB v2 check the [InfluxDB2
component](#influxdb2-component.adoc).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-influxdb</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    influxdb://beanName?[options]

The producer allows sending messages to an InfluxDB configured in the
registry, using the native java driver.

# Example

Below is an example route that stores a point into the db (taking the db
name from the URI) specific key:

    from("direct:start")
            .setHeader(InfluxDbConstants.DBNAME_HEADER, constant("myTimeSeriesDB"))
            .to("influxdb://connectionBean);
    
    from("direct:start")
            .to("influxdb://connectionBean?databaseName=myTimeSeriesDB");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|influxDB|The shared Influx DB to use for all endpoints||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionBean|Connection to the influx database, of class InfluxDB.class||string|
|autoCreateDatabase|Define if we want to auto create the database if it's not present|false|boolean|
|batch|Define if this operation is a batch operation or not|false|boolean|
|checkDatabaseExistence|Define if we want to check the database existence while starting the endpoint|false|boolean|
|databaseName|The name of the database where the time series will be stored||string|
|operation|Define if this operation is an insert or a query|insert|string|
|query|Define the query in case of operation query||string|
|retentionPolicy|The string that defines the retention policy to the data created by the endpoint|default|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
