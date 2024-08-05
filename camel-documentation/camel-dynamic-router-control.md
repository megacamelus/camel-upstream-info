# Dynamic-router-control

**Since Camel 4.4**

**Only producer is supported**

The Dynamic Router Control endpoint is a special type of endpoint in the
Dynamic Router component where routing participants can subscribe or
unsubscribe dynamically at runtime. By sending control messages to this
endpoint, participants can specify their own routing rules and alter the
dynamic rule base of the Dynamic Router component in real-time.
Participants can choose between using URI query parameters, and sending
a control message as the exchange message body.

# URI format

    dynamic-router-control:controlAction[?options]

# Subscribing

Subscribing can be achieved by using query parameters in the control
endpoint URI, or by sending a `DynamicRouterControlMessage` to the
control endpoint URI.

## URI examples

**Example Java URI `RouteBuilder` Subscription**

    // Send a subscribe request to the dynamic router that will match every exchange and route messages to the URI: "direct:myDestination"
    from("direct:subscribe").to("dynamic-router-control:subscribe?subscribeChannel=myChannel&subscriptionId=mySubId&destinationUri=direct:myDestination&priority=5&predicate=true&expressionLanguage=simple");

**Example Java URI `ProducerTemplate` Subscription**

    CamelContext context = new DefaultCamelContext();
    context.start();
    ProducerTemplate template = context.createProducerTemplate();
    RouteBuilder.addRoutes(context, rb -> {
        // Route for subscriber destination
        rb.from("direct:myDestination")
                .to("log:dynamicRouterExample?showAll=true&multiline=true");
        // Route for subscribing
        rb.from("direct://subscribe")
                .toD("dynamic-router-control://subscribe" +
                        "?subscribeChannel=${header.subscribeChannel}" +
                        "&subscriptionId=${header.subscriptionId}" +
                        "&destinationUri=${header.destinationUri}" +
                        "&priority=${header.priority}" +
                        "&predicateBean=${header.predicateBean}");
    });
    Predicate predicate = PredicateBuilder.constant(true);
    context.getRegistry().bind("predicate", predicate);
    template.sendBodyAndHeaders("direct:subscribe", "",
            Map.of("subscribeChannel", "test",
                    "subscriptionId", "testSubscription1",
                    "destinationUri", "direct:myDestination",
                    "priority", "1",
                    "predicateBean", "predicate"));

Above, because the control URI is dynamic, and since a
`ProducerTemplate` does not have a built-in way to send to a dynamic
URI, we have to send subscription parameters from a `ProducerTemplate`
in a different way. The dynamic-aware endpoint uses headers "under the
hood", because the URI params are converted to headers, so we can set
the headers deliberately.

## DynamicRouterControlMessage example

**Example Java `DynamicRouterControlMessage` Subscription**

    DynamicRouterControlMessage controlMessage = DynamicRouterControlMessage.newBuilder()
        .subscribeChannel("myChannel")
        .subscriptionId("mySubId")
        .destinationUri("direct:myDestination")
        .priority(5)
        .predicate("true")
        .expressionLanguage("simple")
        .build();
    producerTemplate.sendBody("dynamic-router-control:subscribe", controlMessage);

# Unsubscribing

Like subscribing, unsubscribing can also be achieved by using query
parameters in the control endpoint URI, or by sending a
`DynamicRouterControlMessage` to the control endpoint URI. The
difference is that unsubscribing can be achieved by using either one or
two parameters.

## URI examples

**Example Java URI `RouteBuilder` Unsubscribe**

    from("direct:subscribe").to("dynamic-router-control:unsubscribe?subscribeChannel=myChannel&subscriptionId=mySubId");

**Example Java URI `ProducerTemplate` Unsubscribe**

    CamelContext context = new DefaultCamelContext();
    context.start();
    ProducerTemplate template = context.createProducerTemplate();
    RouteBuilder.addRoutes(context, rb -> {
        // Route for unsubscribing
        rb.from("direct://unsubscribe")
                .toD("dynamic-router-control://unsubscribe" +
                        "?subscribeChannel=${header.subscribeChannel}" +
                        "&subscriptionId=${header.subscriptionId}");
    });
    template.sendBodyAndHeaders("direct:unsubscribe", "",
            Map.of("subscribeChannel", "test",
                    "subscriptionId", "testSubscription1"));

Above, because the control URI is dynamic, we have to send it from a
`ProducerTemplate` in a different way. The dynamic-aware endpoint uses
headers, rather than URI params, so we set the headers deliberately.

## DynamicRouterControlMessage example

**Example Java `DynamicRouterControlMessage` Unsubscribe**

    DynamicRouterControlMessage controlMessage = DynamicRouterControlMessage.newBuilder()
        .subscribeChannel("myChannel")
        .subscriptionId("mySubId")
        .build();
    producerTemplate.sendBody("dynamic-router-control:unsubscribe", controlMessage);

# The Dynamic Rule Base

To determine if an exchange is suitable for any of the participants, all
predicates for the participants that are subscribed to the channel are
evaluated until the first result of "true" is found, by default. If the
Dynamic Router is configured with the `recipientMode` set to `allMatch`,
then all recipients with matching predicates will be selected. The
exchange will be routed to the corresponding endpoint(s). The rule base
contains a default filter registered at the least priority (which is the
highest integer number). Like the "default" case of a switch statement
in Java, any message that is not appropriate for any registered
participants will be processed by this filter. The filter logs
information about the dropped message at **debug** level, by default. To
turn the level up to **warn**, include `warnDroppedMessage=true` in the
component URI.

Rules are registered in a channel, and they are logically separate from
rules in another channel. Subscription IDs must be unique within a
channel, although multiple subscriptions of the same name may coexist in
a dynamic router instance if they are in separate channels.

The Dynamic Router employs the use of
[Predicate](#manual::predicate.adoc) as rules. Any valid predicate may
be used to determine the suitability of exchanges for a participating
recipient, whether they are simple or compound predicates. Although it
is advised to view the complete documentation, an example simple
predicate might look like the following:

**Example simple predicate**

    // The "messageType" must be "payment"
    Predicate msgType = header("messageType").isEqualTo("payment");

# JMX Control and Monitoring Operations

The Dynamic Router Control component supports some JMX operations that
allow you to control and monitor the component. It is beyond the scope
of this document to go into detail about JMX, so this is a list of the
operations that are supported. For more information about JMX, see the
[JMX](#manual::jmx.adoc) documentation.

**Subscribing with a predicate expression**

    String subscribeWithPredicateExpression(String, String, String, int, String, String, boolean)

This operation provides the ability to subscribe to a channel with a
predicate expression. The parameters, in order, are as follows:

-   subscription ID

-   channel name

-   destination URI

-   priority

-   predicate expression

-   expression language

-   update the subscription (true), or add a new one (false)

**Subscribing with a predicate bean**

    String subscribeWithPredicateBean(String, String, String, int, String, boolean)

This operation provides the ability to subscribe to a channel with the
name of a Predicate that has been bound in the registry. The parameters,
in order, are as follows:

-   subscription ID

-   channel name

-   destination URI

-   priority

-   predicate bean name

-   update the subscription (true), or add a new one (false)

**Subscribing with a predicate instance**

    String subscribeWithPredicateInstance(String, String, String, int, Object, boolean)

This operation provides the ability to subscribe to a channel with an
instance of a Predicate. The parameters, in order, are as follows:

-   subscription ID

-   channel name

-   destination URI

-   priority

-   predicate instance

-   update the subscription (true), or add a new one (false)

**Unsubscribing**

    boolean removeSubscription(String, String)

This operation provides the ability to unsubscribe from a channel. The
parameters, in order, are as follows:

-   subscription ID

-   channel name

**Getting the subscriptions map**

    Map<String, ConcurrentSkipListSet<PrioritizedFilter>> getSubscriptionsMap()

This operation provides the ability to get the subscriptions map. The
map is keyed by channel name, and the values are a set of prioritized
filters.

**Getting the subscriptions statistics map**

    Map<String, List<PrioritizedFilterStatistics>> getSubscriptionsStatisticsMap()

This operation provides the ability to get the subscriptions statistics
map. The map is keyed by channel name, and the values are a list of
prioritized filter statistics, including the number of messages that
have matched the filter, and had the exchange sent to the destination
URI.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|controlAction|Control action||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|destinationUri|The destination URI for exchanges that match.||string|
|expressionLanguage|The subscription predicate language.|simple|string|
|predicate|The subscription predicate.||string|
|predicateBean|A Predicate instance in the registry.||object|
|priority|The subscription priority.||integer|
|subscribeChannel|The channel to subscribe to||string|
|subscriptionId|The subscription ID; if unspecified, one will be assigned and returned.||string|
