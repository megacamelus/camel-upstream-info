# Kudu

**Since Camel 3.0**

**Only producer is supported**

The Kudu component supports storing and retrieving data from/to [Apache
Kudu](https://kudu.apache.org/), a free and open source column-oriented
data store of the Apache Hadoop ecosystem.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-kudu</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Prerequisites

You must have a valid Kudu instance running. More information is
available at [Apache Kudu](https://kudu.apache.org/).

# Usage

## Input Body formats

### Insert, delete, update, and upsert

The input body format has to be a `java.util.Map<String, Object>`. This
map will represent a row of the table whose elements are columns, where
the key is the column name and the value is the value of the column.

## Output Body formats

### Scan

The output body format will be a
`java.util.List<java.util.Map<String, Object>>`. Each element of the
list will be a different row of the table. Each row is a
`Map<String, Object>` whose elements will be each pair of column name
and column value for that row.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|kuduClient|To use an existing Kudu client instance, instead of creating a client per endpoint. This allows you to customize various aspects to the client configuration.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Host of the server to connect to||string|
|port|Port of the server to connect to||string|
|tableName|Table to connect to||string|
|operation|Operation to perform||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
