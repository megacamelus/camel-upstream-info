# Jgroups

**Since Camel 2.13**

**Both producer and consumer are supported**

[JGroups](http://www.jgroups.org) is a toolkit for reliable multicast
communication. The **jgroups:** component provides exchange of messages
between Camel infrastructure and [JGroups](http://jgroups.org) clusters.

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jgroups</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

# URI format

    jgroups:clusterName[?options]

Where **clusterName** represents the name of the JGroups cluster, the
component should connect to.

# Usage

Using `jgroups` component on the consumer side of the route will capture
messages received by the `JChannel` associated with the endpoint and
forward them to the Camel route. JGroups consumer processes incoming
messages
[asynchronously](http://camel.apache.org/asynchronous-routing-engine.html).

    // Capture messages from cluster named
    // 'clusterName' and send them to Camel route.
    from("jgroups:clusterName").to("seda:queue");

Using `jgroups` component on the producer side of the route will forward
body of the Camel exchanges to the `JChannel` instance managed by the
endpoint.

    // Send a message to the cluster named 'clusterName'
    from("direct:start").to("jgroups:clusterName");

# Predefined filters

JGroups component comes with predefined filters factory class named
`JGroupsFilters.`

If you would like to consume only view changes notifications sent to
coordinator of the cluster (and ignore these sent to the "slave" nodes),
use the `JGroupsFilters.dropNonCoordinatorViews()` filter. This filter
is particularly useful when you want a single Camel node to become the
master in the cluster, because messages passing this filter notifies you
when a given node has become a coordinator of the cluster. The snippet
below demonstrates how to collect only messages received by the master
node.

    import static org.apache.camel.component.jgroups.JGroupsFilters.dropNonCoordinatorViews;
    ...
    from("jgroups:clusterName?enableViewMessages=true").
      filter(dropNonCoordinatorViews()).
      to("seda:masterNodeEventsQueue");

# Predefined expressions

JGroups component comes with predefined expressions factory class named
`JGroupsExpressions.`

If you would like to create delayer that would affect the route only if
the Camel context has not been started yet, use the
`JGroupsExpressions.delayIfContextNotStarted(long delay)` factory
method. The expression created by this factory method will return given
delay value only if the Camel context is in the state different from
`started`. This expression is particularly useful if you would like to
use JGroups component for keeping singleton (master) route within the
cluster. [Control Bus](#controlbus-component.adoc) `start` command won’t
initialize the singleton route if the Camel Context hasn’t been yet
started. So you need to delay a startup of the master route, to be sure
that it has been initialized after the Camel Context startup. Because
such a scenario can happen only during the initialization of the
cluster, we don’t want to delay startup of the slave node becoming the
new master - that’s why we need a conditional delay expression.

The snippet below demonstrates how to use conditional delaying with the
JGroups component to delay the initial startup of master node in the
cluster.

    import static java.util.concurrent.TimeUnit.SECONDS;
    import static org.apache.camel.component.jgroups.JGroupsExpressions.delayIfContextNotStarted;
    import static org.apache.camel.component.jgroups.JGroupsFilters.dropNonCoordinatorViews;
    ...
    from("jgroups:clusterName?enableViewMessages=true").
      filter(dropNonCoordinatorViews()).
      threads().delay(delayIfContextNotStarted(SECONDS.toMillis(5))). // run in separated and delayed thread. Delay only if the context hasn't been started already.
      to("controlbus:route?routeId=masterRoute&action=start&async=true");
    
    from("timer://master?repeatCount=1").routeId("masterRoute").autoStartup(false).to(masterMockUri);

# Examples

## Sending (receiving) messages to (from) the JGroups cluster

To send a message to the JGroups cluster, use producer endpoint, just as
demonstrated in the snippet below.

    from("direct:start").to("jgroups:myCluster");
    ...
    producerTemplate.sendBody("direct:start", "msg")

To receive the message from the snippet above (on the same, or the other
physical machine), listen to the messages coming from the given cluster,
just as demonstrated on the code fragment below.

    mockEndpoint.setExpectedMessageCount(1);
    mockEndpoint.message(0).body().isEqualTo("msg");
    ...
    from("jgroups:myCluster").to("mock:messagesFromTheCluster");
    ...
    mockEndpoint.assertIsSatisfied();

## Receive cluster view change notifications

The snippet below demonstrates how to create the consumer endpoint
listening to the notifications regarding cluster membership changes. By
default, the endpoint consumes only regular messages.

    mockEndpoint.setExpectedMessageCount(1);
    mockEndpoint.message(0).body().isInstanceOf(org.jgroups.View.class);
    ...
    from("jgroups:clusterName?enableViewMessages=true").to(mockEndpoint);
    ...
    mockEndpoint.assertIsSatisfied();

## Keeping singleton route within the cluster

The snippet below demonstrates how to keep the singleton consumer route
in the cluster of Camel Contexts. As soon as the master node dies, one
of the slaves will be elected as a new master and started. In this
particular example, we want to keep singleton
[jetty](#jetty-component.adoc) instance listening for the requests on
address\` [http://localhost:8080/orders](http://localhost:8080/orders)\`.

    JGroupsLockClusterService service = new JGroupsLockClusterService();
    service.setId("uniqueNodeId");
    ...
    context.addService(service);
    
    from("master:mycluster:jetty:http://localhost:8080/orders").to("jms:orders");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|channel|Channel to use||object|
|channelProperties|Specifies configuration properties of the JChannel used by the endpoint.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|enableViewMessages|If set to true, the consumer endpoint will receive org.jgroups.View messages as well (not only org.jgroups.Message instances). By default only regular messages are consumed by the endpoint.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clusterName|The name of the JGroups cluster the component should connect to.||string|
|channelProperties|Specifies configuration properties of the JChannel used by the endpoint.||string|
|enableViewMessages|If set to true, the consumer endpoint will receive org.jgroups.View messages as well (not only org.jgroups.Message instances). By default only regular messages are consumed by the endpoint.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
