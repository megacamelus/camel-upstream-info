# RecipientList-eip.md

Camel supports the [Recipient
List](https://www.enterpriseintegrationpatterns.com/RecipientList.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How do we route a message to a list of dynamically specified recipients?

<figure>
<img src="eip/RecipientList.gif" alt="image" />
</figure>

Define a channel for each recipient. Then use a Recipient List to
inspect an incoming message, determine the list of desired recipients,
and forward the message to all channels associated with the recipients
in the list.

# Options

See the `cacheSize` option for more details on *how much cache* to use
depending on how many or few unique endpoints are used.

# Exchange properties

# Using Recipient List

The Recipient List EIP allows routing **the same** message to a number
of [endpoints](#manual::endpoint.adoc) and process them in a different
way.

There can be one or more destinations, and Camel will execute them
sequentially (by default). However, a parallel mode exists which allows
processing messages concurrently.

The Recipient List EIP has many features and is based on the
[Multicast](#multicast-eip.adoc) EIP. For example, the Recipient List
EIP is capable of aggregating each message into a single *response*
message as the result after the Recipient List EIP.

## Using Static Recipient List

The following example shows how to route a request from an input
`queue:a` endpoint to a static list of destinations, using `constant`:

Java  
from("jms:queue:a")
.recipientList(constant("seda:x,seda:y,seda:z"));

XML  
<route>  
<from uri="jms:queue:a"/>  
<recipientList>  
<constant>seda:x,seda:y,seda:z</constant>  
</recipientList>  
</route>

## Using Dynamic Recipient List

Usually one of the main reasons for using the Recipient List pattern is
that the list of recipients is dynamic and calculated at runtime.

The following example demonstrates how to create a dynamic recipient
list using an [Expression](#manual::expression.adoc) (which in this case
extracts a named header value dynamically) to calculate the list of
endpoints; which are either of type `Endpoint` or are converted to a
`String` and then resolved using the endpoint URIs (separated by comma).

Java  
from("jms:queue:a")
.recipientList(header("foo"));

XML  
<route>  
<from uri="jms:queue:a"/>  
<recipientList>  
<header>foo</constant>  
</recipientList>  
</route>

### How is dynamic destinations evaluated

The dynamic list of recipients that are defined in the header must be
iterable such as:

-   `java.util.Collection`

-   `java.util.Iterator`

-   arrays

-   `org.w3c.dom.NodeList`

-   a single `String` with values separated by comma (the delimiter
    configured)

-   any other type will be regarded as a single value

## Configuring delimiter for dynamic destinations

In XML DSL you can set the delimiter attribute for setting a delimiter
to be used if the header value is a single `String` with multiple
separated endpoints. By default, Camel uses comma as delimiter, but this
option lets you specify a custom delimiter to use instead.

    <route>
      <from uri="direct:a"/>
      <!-- use semicolon as a delimiter for String-based values -->
      <recipientList delimiter=";">
        <header>myHeader</header>
      </recipientList>
    </route>

So if **myHeader** contains a `String` with the value
`"activemq:queue:foo;activemq:topic:hello ; log:bar"` then Camel will
split the `String` using the delimiter given in the XML that was comma,
resulting into three endpoints to send to. You can use spaces between
the endpoints as Camel will trim the value when it looks up the endpoint
to send to.

And in Java DSL, you specify the delimiter as second parameter as shown
below:

    from("direct:a")
        .recipientList(header("myHeader"), ";");

## Using parallel processing

The Recipient List supports `parallelProcessing` similar to what
[Multicast](#multicast-eip.adoc) and [Split](#split-eip.adoc) EIPs have
as well. When using parallel processing, then a thread pool is used to
have concurrent tasks sending the `Exchange` to multiple recipients
concurrently.

You can enable parallel mode using `parallelProcessing` as shown:

Java  
from("direct:a")
.recipientList(header("myHeader")).parallelProcessing();

XML  
<route>  
<from uri="direct:a"/>  
<recipientList parallelProcessing="true">  
<header>myHeader</header>  
</recipientList>  
</route>

When parallel processing is enabled, then the Camel routing engin will
continue processing using last used thread from the parallel thread
pool. However, if you want to use the original thread that called the
recipient list, then make sure to enable the synchronous option as well.

### Using custom thread pool

A thread pool is only used for `parallelProcessing`. You supply your own
custom thread pool via the `ExecutorServiceStrategy` (see Camel’s
Threading Model), the same way you would do it for the
`aggregationStrategy`. By default, Camel uses a thread pool with 10
threads (subject to change in future versions).

The Recipient List EIP will by default continue to process the entire
exchange even in case one of the sub messages will throw an exception
during routing.

For example, if you want to route to three destinations and the second
destination fails by an exception. What Camel does by default is to
process the remainder destinations. You have the chance to deal with the
exception when aggregating using an `AggregationStrategy`.

But sometimes you want the Camel to stop and let the exception be
propagated back, and let the Camel [Error
Handler](#manual::error-handler.adoc) handle it. You can do this by
specifying that it should stop in case of an exception occurred. This is
done by the `stopOnException` option as shown below:

Java  
from("direct:start")
.recipientList(header("whereTo")).stopOnException()
.to("mock:result");

        from("direct:foo").to("mock:foo");
    
        from("direct:bar").process(new MyProcessor()).to("mock:bar");
    
        from("direct:baz").to("mock:baz");

XML  
<routes>  
<route>  
<from uri="direct:start"/>  
<recipientList stopOnException="true">  
<header>whereTo</header>  
</recipientList>  
<to uri="mock:result"/>  
</route>

        <route>
            <from uri="direct:foo"/>
            <to uri="mock:foo"/>
        </route>
    
        <route>
            <from uri="direct:bar"/>
            <process ref="myProcessor"/>
            <to uri="mock:bar"/>
        </route>
    
        <route>
            <from uri="direct:baz"/>
            <to uri="mock:baz"/>
        </route>
    </routes>

In this example suppose a message is sent with the header
`whereTo=direct:foo,direct:bar,direct:baz` that means the recipient list
sends messages to those three endpoints.

Now suppose that the `MyProcessor` is causing a failure and throws an
exception. This means the Recipient List EIP will stop after this, and
not the last route (`direct:baz`).

## Ignore invalid endpoints

The Recipient List supports `ignoreInvalidEndpoints` (like [Routing
Slip](#routingSlip-eip.adoc) EIP). You can use it to skip endpoints
which are invalid.

Java  
from("direct:a")
.recipientList(header("myHeader")).ignoreInvalidEndpoints();

XML  
<route>  
<from uri="direct:a"/>  
<recipientList ignoreInvalidEndpoints="true">  
<header>myHeader</header>  
</recipientList>  
</route>

Then let us say the `myHeader` contains the following two endpoints
`direct:foo,xxx:bar`. The first endpoint is valid and works. However,
the second one is invalid and will just be ignored. Camel logs at DEBUG
level about it, so you can see why the endpoint was invalid.

## Using timeout

If you use `parallelProcessing` then you can configure a total `timeout`
value in millis.

Camel will then process the messages in parallel until the timeout is
hit. This allows you to continue processing if one message consumer is
slow. For example, you can set a timeout value of 20 sec.

If the timeout is reached with running tasks still remaining, certain
tasks for which it is challenging for Camel to shut down in a graceful
manner may continue to run. So use this option with a bit of care.

For example, in the unit test below, you can see that we multicast the
message to three destinations. We have a timeout of 2 seconds, which
means only the last two messages can be completed within the timeframe.
This means we will only aggregate the last two which yields a result
aggregation which outputs "BC".

    from("direct:start")
        .multicast(new AggregationStrategy() {
                public Exchange aggregate(Exchange oldExchange, Exchange newExchange) {
                    if (oldExchange == null) {
                        return newExchange;
                    }
    
                    String body = oldExchange.getIn().getBody(String.class);
                    oldExchange.getIn().setBody(body + newExchange.getIn().getBody(String.class));
                    return oldExchange;
                }
            })
            .parallelProcessing().timeout(250).to("direct:a", "direct:b", "direct:c")
        // use end to indicate end of multicast route
        .end()
        .to("mock:result");
    
    from("direct:a").delay(1000).to("mock:A").setBody(constant("A"));
    
    from("direct:b").to("mock:B").setBody(constant("B"));
    
    from("direct:c").to("mock:C").setBody(constant("C"));

By default, if a timeout occurs the `AggregationStrategy` is not
invoked. However, you can implement the `timeout` method: This allows
you to deal with the timeout in the `AggregationStrategy` if you really
need to.

Timeout is total

The timeout is total, which means that after X time, Camel will
aggregate the messages which have completed within the timeframe. The
remainder will be canceled. Camel will also only invoke the `timeout`
method in the `TimeoutAwareAggregationStrategy` once, for the first
index which caused the timeout.

## Using ExchangePattern in recipients

The recipient list will by default use the current Exchange Pattern.
Though one can imagine use-cases where one wants to send a message to a
recipient using a different exchange pattern. For example, you may have
a route that initiates as an `InOnly` route, but want to use `InOut`
exchange pattern with a recipient list. You can configure the exchange
pattern directly in the recipient endpoints.

For example, in the route below we pick up new files (which will be
started as `InOnly`) and then route to a recipient list. As we want to
use `InOut` with the ActiveMQ (JMS) endpoint we can now specify this
using the `exchangePattern=InOut` option. Then the response from the JMS
request/reply will then be continued routed, and thus the response is
what will be stored in as a file in the outbox directory.

    from("file:inbox")
        // the exchange pattern is InOnly initially when using a file route
        .recipientList().constant("activemq:queue:inbox?exchangePattern=InOut")
        .to("file:outbox");

The recipient list will not alter the original exchange pattern. So in
the example above the exchange pattern will still be `InOnly` when the
message is routed to the `file:outbox endpoint`. If you want to alter
the exchange pattern permanently then use `.setExchangePattern` in the
route.

See more details at [Event Message](#event-message.adoc) and [Request
Reply](#requestReply-eip.adoc) EIPs.

# See Also

Because Recipient List EIP is based on the
[Multicast](#multicast-eip.adoc), then you can find more information in
[Multicast](#multicast-eip.adoc) EIP about features that are also
available with Recipient List EIP.
