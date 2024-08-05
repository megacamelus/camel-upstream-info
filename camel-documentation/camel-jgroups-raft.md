# Jgroups-raft

**Since Camel 2.24**

**Both producer and consumer are supported**

[JGroups-raft](http://belaban.github.io/jgroups-raft/) is a
[Raft](https://raftconsensus.github.io/) implementation in
[JGroups](http://www.jgroups.org/). The **jgroups-raft:** component
provides interoperability between camel and a JGroups-raft clusters.

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jgroups-raft</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

# URI format

    jgroups-raft:clusterName[?options]

Where **clusterName** represents the name of the JGroups-raft cluster,
the component should connect to.

# Options

# Usage

Using `jgroups-raft` component with `enableRoleChangeEvents=true` on the
consumer side of the route will capture change in JGroups-raft role and
forward them to the Camel route. JGroups-raft consumer processes
incoming messages
[asynchronously](http://camel.apache.org/asynchronous-routing-engine.html).

    // Capture raft role changes from cluster named
    // 'clusterName' and send them to Camel route.
    from("jgroups-raft:clusterName?enableRoleChangeEvents=true").to("seda:queue");

Using `jgroups-raft` component on the producer side of the route will
use the body of the camel exchange (which must be a `byte[]`) to perform
a setX() operation on the raftHandle associated with the endpoint.

    // perform a setX() operation to the cluster named 'clusterName' shared state machine
    from("direct:start").to("jgroups-raft:clusterName");

# Examples

## Receive cluster view change notifications

The snippet below demonstrates how to create the consumer endpoint
listening to the change role events. By default, this option is off.

    ...
    from("jgroups-raft:clusterName?enableRoleChangeEvents=true").to(mock:mockEndpoint);
    ...

## Keeping singleton route within the cluster

The snippet below demonstrates how to keep the singleton consumer route
in the cluster of Camel Contexts. As soon as the master node dies, one
of the slaves will be elected as a new master and started. In this
particular example, we want to keep singleton
[jetty](#jetty-component.adoc) instance listening for the requests on
address\` [http://localhost:8080/orders](http://localhost:8080/orders)\`.

    JGroupsRaftClusterService service = new JGroupsRaftClusterService();
    service.setId("raftId");
    service.setRaftId("raftId");
    service.setJgroupsClusterName("clusterName");
    ...
    context.addService(service);
    
    from("master:mycluster:jetty:http://localhost:8080/orders").to("jms:orders");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|channelProperties|Specifies configuration properties of the RaftHandle JChannel used by the endpoint (ignored if raftHandle ref is provided).|raft.xml|string|
|raftHandle|RaftHandle to use.||object|
|raftId|Unique raftId to use.||string|
|stateMachine|StateMachine to use.|NopStateMachine|object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clusterName|The name of the JGroupsraft cluster the component should connect to.||string|
|enableRoleChangeEvents|If set to true, the consumer endpoint will receive roleChange event as well (not just connecting and/or using the state machine). By default it is set to false.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
