# Zookeeper-master

**Since Camel 2.19**

**Only consumer is supported**

The **zookeeper-master:** endpoint provides a way to ensure only a
single consumer in a cluster consumes from a given endpoint; with
automatic fails over if that JVM dies.

This can be beneficial if you need to consume from some legacy back end
that either doesn’t support concurrent consumption or due to commercial
or stability reasons, you can only have a single connection at any point
in time.

# Using the master endpoint

Prefix any camel endpoint with **zookeeper-master:someName:** where
*someName* is a logical name and is used to acquire the master lock.
e.g.

    from("zookeeper-master:cheese:jms:foo").to("activemq:wine");

The above simulates the \[Exclusive
Consumers\]([http://activemq.apache.org/exclusive-consumer.html](http://activemq.apache.org/exclusive-consumer.html)) type
feature in ActiveMQ; but on any third party JMS provider that maybe
doesn’t support exclusive consumers.

# URI format

    zookeeper-master:name:endpoint[?options]

Where endpoint is any Camel endpoint, you want to run in master/slave
mode.

# Example

You can protect a clustered Camel application to only consume files from
one active node.

        // the file endpoint we want to consume from
        String url = "file:target/inbox?delete=true";
    
        // use the zookeeper master component in the clustered group named myGroup
        // to run a master/slave mode in the following Camel url
        from("zookeeper-master:myGroup:" + url)
            .log(name + " - Received file: ${file:name}")
            .delay(delay)
            .log(name + " - Done file:     ${file:name}")
            .to("file:target/outbox");

ZooKeeper will by default connect to `localhost:2181`, but you can
configure this on the component level.

        MasterComponent master = new MasterComponent();
        master.setZooKeeperUrl("myzookeeper:2181");

However, you can also configure the url of the ZooKeeper ensemble using
environment variables.

    export ZOOKEEPER_URL = "myzookeeper:2181"

# Master RoutePolicy

You can also use a `RoutePolicy` to control routes in master/slave mode.

When doing so, you must configure the route policy with

-   url to zookeeper ensemble

-   name of the cluster group

-   **important** and set the route to not auto startup

A little example

        MasterRoutePolicy master = new MasterRoutePolicy();
        master.setZooKeeperUrl("localhost:2181");
        master.setGroupName("myGroup");
    
        // its import to set the route to not auto startup
        // as we let the route policy start/stop the routes when it becomes a master/slave, etc.
        from("file:target/inbox?delete=true").noAutoStartup()
            // use the zookeeper master route policy in the clustered group
            // to run this route in master/slave mode
            .routePolicy(master)
            .log(name + " - Received file: ${file:name}")
            .delay(delay)
            .log(name + " - Done file:     ${file:name}")
            .to("file:target/outbox");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|maximumConnectionTimeout|Timeout in millis to use when connecting to the zookeeper ensemble|10000|integer|
|zkRoot|The root path to use in zookeeper where information is stored which nodes are master/slave etc. Will by default use: /camel/zookeepermaster/clusters/master|/camel/zookeepermaster/clusters/master|string|
|zooKeeperUrl|The url for the zookeeper ensemble|localhost:2181|string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|containerIdFactory|To use a custom ContainerIdFactory for creating container ids.||object|
|curator|To use a custom configured CuratorFramework as connection to zookeeper ensemble.||object|
|zooKeeperPassword|The password to use when connecting to the zookeeper ensemble||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|groupName|The name of the cluster group to use||string|
|consumerEndpointUri|The consumer endpoint to use in master/slave mode||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
