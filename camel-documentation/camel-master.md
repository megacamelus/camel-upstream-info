# Master

**Since Camel 2.20**

**Only consumer is supported**

The Camel-Master endpoint provides a way to ensure only a single
consumer in a cluster consumes from a given endpoint; with automatic
fail over if that JVM dies.

This can be handy if you need to consume from some legacy back end that
either doesn’t support concurrent consumption or due to commercial or
stability reasons, you can only have a single connection at any point in
time.

# URI format

    master:namespace:endpoint[?options]

Where endpoint is any Camel endpoint, you want to run in master/slave
mode.

# Usage

## Using the master endpoint

Prefix any camel endpoint with **master:someName:** where *someName* is
a logical name and is used to acquire the master lock. For instance:

    from("master:cheese:jms:foo")
      .to("activemq:wine");

In this example, the master component ensures that the route is only
active in one node, at any given time, in the cluster. So if there are 8
nodes in the cluster, then the master component will elect one route to
be the leader, and only this route will be active, and hence only this
route will consume messages from `jms:foo`. In case this route is
stopped or unexpectedly terminated, then the master component will
detect this, and re-elect another node to be active, which will then
become active and start consuming messages from `jms:foo`.

Apache ActiveMQ 5.x has such a feature out of the box called [Exclusive
Consumers](https://activemq.apache.org/exclusive-consumer.html).

# Example

You can protect a clustered Camel application to only consume files from
one active node.

    // the file endpoint we want to consume from
    String url = "file:target/inbox?delete=true";
    
    // use the camel master component in the clustered group named myGroup
    // to run a master/slave mode in the following Camel url
    from("master:myGroup:" + url)
        .log(name + " - Received file: ${file:name}")
        .delay(delay)
        .log(name + " - Done file:     ${file:name}")
        .to("file:target/outbox");

The master component leverages CamelClusterService you can configure
using

-   **Java**
    
        ZooKeeperClusterService service = new ZooKeeperClusterService();
        service.setId("camel-node-1");
        service.setNodes("myzk:2181");
        service.setBasePath("/camel/cluster");
        
        context.addService(service)

-   **Xml (Spring)**
    
        <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
             http://www.springframework.org/schema/beans
             http://www.springframework.org/schema/beans/spring-beans.xsd
             http://camel.apache.org/schema/spring
             http://camel.apache.org/schema/spring/camel-spring.xsd">
        
        
          <bean id="cluster" class="org.apache.camel.component.zookeeper.cluster.ZooKeeperClusterService">
            <property name="id" value="camel-node-1"/>
            <property name="basePath" value="/camel/cluster"/>
            <property name="nodes" value="myzk:2181"/>
          </bean>
        
          <camelContext xmlns="http://camel.apache.org/schema/spring" autoStartup="false">
            ...
          </camelContext>
        
        </beans>

-   **Spring boot**
    
        camel.component.zookeeper.cluster.service.enabled   = true
        camel.component.zookeeper.cluster.service.id        = camel-node-1
        camel.component.zookeeper.cluster.service.base-path = /camel/cluster
        camel.component.zookeeper.cluster.service.nodes     = myzk:2181

# Implementations

Camel provides the following ClusterService implementations:

-   camel-consul

-   camel-file

-   camel-infinispan

-   camel-jgroups-raft

-   camel-jgroups

-   camel-kubernetes

-   camel-zookeeper

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|backOffDelay|When the master becomes leader then backoff is in use to repeat starting the consumer until the consumer is successfully started or max attempts reached. This option is the delay in millis between start attempts.||integer|
|backOffMaxAttempts|When the master becomes leader then backoff is in use to repeat starting the consumer until the consumer is successfully started or max attempts reached. This option is the maximum number of attempts to try.||integer|
|service|Inject the service to use.||object|
|serviceSelector|Inject the service selector used to lookup the CamelClusterService to use.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|namespace|The name of the cluster namespace to use||string|
|delegateUri|The endpoint uri to use in master/slave mode||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
