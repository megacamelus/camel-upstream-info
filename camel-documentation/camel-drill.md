# Drill

**Since Camel 2.19**

**Only producer is supported**

The Drill component gives you the ability to query the [Apache Drill
Cluster](https://drill.apache.org/).

Drill is an Apache open-source SQL query engine for Big Data
exploration. Drill is designed from the ground up to support
high-performance analysis on the semi-structured and rapidly evolving
data coming from modern Big Data applications, while still providing the
familiarity and ecosystem of ANSI SQL, the industry-standard query
language

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-drill</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    drill://host[?options]

# Options

# Usage

## Drill Producer

The producer executes a query using the **CamelDrillQuery** header and
puts the results into the body.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Host name or IP address||string|
|clusterId|Cluster ID https://drill.apache.org/docs/using-the-jdbc-driver/#determining-the-cluster-id||string|
|directory|Drill directory||string|
|mode|Connection mode: zk: Zookeeper drillbit: Drillbit direct connection https://drill.apache.org/docs/using-the-jdbc-driver/|ZK|object|
|port|Port number|2181|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
