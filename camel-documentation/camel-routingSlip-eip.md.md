# RoutingSlip-eip.md

Camel supports the [Routing
Slip](https://www.enterpriseintegrationpatterns.com/patterns/messaging/RoutingTable.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How do we route a message consecutively through a series of processing
steps when the sequence of steps is not known at design-time and may
vary for each message?

<figure>
<img src="eip/RoutingTableSimple.gif" alt="image" />
</figure>

Attach a Routing Slip to each message, specifying the sequence of
processing steps. Wrap each component with a special message router that
reads the Routing Slip and routes the message to the next component in
the list.

# Options

See the `cacheSize` option for more details on *how much cache* to use
depending on how many or few unique endpoints are used.

# Exchange properties

# Using Routing Slip

The Routing Slip EIP allows to route a message through a series of
[endpoints](#manual::endpoint.adoc) (the slip).

There can be 1 or more endpoint [uris](#manual::uris.adoc) in the slip.

A slip can be empty, meaning that the message will not be routed
anywhere.

The following route will take any messages sent to the Apache ActiveMQ
queue cheese and use the header with key "whereTo" that is used to
compute the slip (endpoint [uris](#manual::uris.adoc)).

Java  
from("activemq:cheese")
.routingSlip(header("whereTo"));

XML  
<route>  
<from uri="activemq:cheese"/>  
<routingSlip>  
<header>whereTo</header>  
</routingSlip>  
</route>

The value of the header ("whereTo") should be a comma-delimited string
of endpoint URIs you wish the message to be routed to. The message will
be routed in a [pipeline](#pipeline-eip.adoc) fashion, i.e., one after
the other.

The Routing Slip sets a property, `Exchange.SLIP_ENDPOINT`, on the
`Exchange` which contains the current endpoint as it advanced though the
slip. This allows you to *know* how far we have processed in the slip.

The Routing Slip will compute the slip **beforehand**, which means the
slip is only computed once. If you need to compute the slip
*on-the-fly*, then use the [Dynamic Router](#dynamicRouter-eip.adoc) EIP
instead.

## How is the slip computed

The Routing Slip uses an [Expression](#manual::expression.adoc) to
compute the value for the slip. The result of the expression can be one
of:

-   `String`

-   `Collection`

-   `Iterator` or `Iterable`

-   Array

If the value is a `String` then the `uriDelimiter` is used to split the
string into multiple uris. The default delimiter is comma, but can be
re-configured.

## Ignore Invalid Endpoints

The Routing Slip supports `ignoreInvalidEndpoints` (like [Recipient
List](#recipientList-eip.adoc) EIP). You can use it to skip endpoints
which are invalid.

Java  
from("direct:start")
.routingSlip("myHeader").ignoreInvalidEndpoints();

XML  
<route>  
<from uri="direct:start"/>  
<routingSlip ignoreInvalidEndpoints="true">  
<header>myHeader</header>  
</routingSlip>  
</route>

Then let us say the `myHeader` contains the following two endpoints
`direct:foo,xxx:bar`. The first endpoint is valid and works. However,
the second one is invalid and will just be ignored. Camel logs at DEBUG
level about it, so you can see why the endpoint was invalid.
