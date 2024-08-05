# Multicast-eip.md

The Multicast EIP allows routing **the same** message to a number of
[endpoints](#manual::endpoint.adoc) and process them in a different way.

<figure>
<img src="eip/RecipientListIcon.gif" alt="image" />
</figure>

The Multicast EIP has many features and is also used as a baseline for
the [Recipient List](#recipientList-eip.adoc) and
[Split](#split-eip.adoc) EIPs. For example, the Multicast EIP is capable
of aggregating each multicasted message into a single *response* message
as the result after the Multicast EIP.

# Options

# Exchange properties

# Using Multicast

The following example shows how to take a request from the `direct:a`
endpoint, then multicast these requests to `direct:x`, `direct:y`, and
`direct:z`.

Java  
from("direct:a")
.multicast()
.to("direct:x")
.to("direct:y")
.to("direct:z");

XML  
<route>  
<from uri="direct:a"/>  
<multicast>  
<to uri="direct:b"/>  
<to uri="direct:c"/>  
<to uri="direct:d"/>  
</multicast>  
</route>

By default, Multicast EIP runs in single threaded mode, which means that
the next multicasted message is processed only when the previous is
finished. This means that `direct:b` must be done before Camel will call
`direct:c` and so on.

## Multicasting with parallel processing

You can enable parallel processing with Multicast EIP so each
multicasted message is processed by its own thread in parallel.

The example below enabled parallel mode:

Java  
from("direct:a")
.multicast().parallelProcessing()
.to("direct:x")
.to("direct:y")
.to("direct:z");

XML  
<route>  
<from uri="direct:a"/>  
<multicast parallelProcessing="true">  
<to uri="direct:b"/>  
<to uri="direct:c"/>  
<to uri="direct:d"/>  
</multicast>  
</route>

When parallel processing is enabled, then the Camel routing engin will
continue processing using last used thread from the parallel thread
pool. However, if you want to use the original thread that called the
multicast, then make sure to enable the synchronous option as well.

## Ending a Multicast block

You may want to continue routing the exchange after the Multicast EIP.

In the example below, then sending to `mock:result` happens after the
Multicast EIP has finished. In other words, `direct:x`, `direct:y`, and
`direct:z` should be completed first, before the message continues.

Java  
from("direct:a")
.multicast().parallelProcessing()
.to("direct:x")
.to("direct:y")
.to("direct:z")
.end()
.to("mock:result");

Note that you need to use `end()` to mark where multicast ends, and
where other EIPs can be added to continue the route.

XML  
<route>  
<from uri="direct:a"/>  
<multicast parallelProcessing="true">  
<to uri="direct:b"/>  
<to uri="direct:c"/>  
<to uri="direct:d"/>  
</multicast>  
<to uri="mock:result"/>  
</route>

## Aggregating

The `AggregationStrategy` is used for aggregating all the multicasted
exchanges together as a single response exchange, that becomes the
outgoing exchange after the Multicast EIP block.

The example now aggregates with the `MyAggregationStrategy` class:

Java  
from("direct:start")
.multicast(new MyAggregationStrategy()).parallelProcessing().timeout(500)
.to("direct:x")
.to("direct:y")
.to("direct:z")
.end()
.to("mock:result");

XML  
We can refer to the FQN class name with `#class:` syntax as shown below:

    <route>
        <from uri="direct:a"/>
        <multicast parallelProcessing="true" timeout="5000"
                   aggreationStrategy="#class:com.foo.MyAggregationStrategy">
            <to uri="direct:b"/>
            <to uri="direct:c"/>
            <to uri="direct:d"/>
        </multicast>
        <to uri="mock:result"/>
    </route>

The Multicast, Recipient List, and Splitter EIPs have special support
for using `AggregationStrategy` with access to the original input
exchange. You may want to use this when you aggregate messages and there
has been a failure in one of the messages, which you then want to enrich
on the original input message and return as response; it’s the aggregate
method with three exchange parameters.

## Stop processing in case of exception

The Multicast EIP will by default continue to process the entire
exchange even in case one of the multicasted messages will throw an
exception during routing.

For example, if you want to multicast to three destinations and the
second destination fails by an exception. What Camel does by default is
to process the remainder destinations. You have the chance to deal with
the exception when aggregating using an `AggregationStrategy`.

But sometimes you want Camel to stop and let the exception be propagated
back, and let the Camel [Error Handler](#manual::error-handler.adoc)
handle it. You can do this by specifying that it should stop in case of
an exception occurred. This is done by the `stopOnException` option as
shown below:

Java  
from("direct:start")
.multicast()
.stopOnException().to("direct:foo", "direct:bar", "direct:baz")
.end()
.to("mock:result");

        from("direct:foo").to("mock:foo");
    
        from("direct:bar").process(new MyProcessor()).to("mock:bar");
    
        from("direct:baz").to("mock:baz");

XML  
<routes>  
<route>  
<from uri="direct:start"/>  
<multicast stopOnException="true">  
<to uri="direct:foo"/>  
<to uri="direct:bar"/>  
<to uri="direct:baz"/>  
</multicast>  
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

In the example above, then `MyProcessor` is causing a failure and throws
an exception. This means the Multicast EIP will stop after this, and not
the last route (`direct:baz`).

## Preparing the message by deep copying before multicasting

The multicast EIP will copy the source exchange and multicast each copy.
However, the copy is a shallow copy, so in case you have mutable message
bodies, then any changes will be visible by the other copied messages.
If you want to use a deep clone copy, then you need to use a custom
`onPrepare` which allows you to create a deep copy of the message body
in the `Processor`.

Notice the `onPrepare` can be used for any kind of custom logic that you
would like to execute before the [Exchange](#manual::exchange.adoc) is
being multicasted.

# See Also

Because Multicast EIP is a baseline for the [Recipient
List](#recipientList-eip.adoc) and [Split](#split-eip.adoc) EIPs, then
you can find more information in those EIPs about features that are also
available with Multicast EIP.
