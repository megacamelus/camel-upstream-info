# Correlation-identifier.md

Camel supports the [Correlation
Identifier](http://www.enterpriseintegrationpatterns.com/CorrelationIdentifier.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) by
getting or setting a header on the [Message](#message.adoc).

When working with the [JMS](#ROOT:jms-component.adoc) components, the
correlation identifier header is called **JMSCorrelationID**, and they
handle the correlation automatically.

Other messaging systems, such as [Spring
RabbitMQ](#ROOT:spring-rabbitmq-component.adoc), also handle this
automatically. In general, you should not have a need for using custom
correlation IDs with these systems.

<figure>
<img src="eip/CorrelationIdentifierSolution.gif" alt="image" />
</figure>

You can use your own correlation identifier to any message exchange to
help correlate messages together to a single conversation (or business
process). For example, if you need to correlation messages when using
web services.

The use of a correlation identifier is key to working with [Distributed
Tracing](#others:tracing.adoc) and be useful when using
[Tracer](#manual::tracer.adoc) messages to log, or testing with
simulation or canned data such as with the
[Mock](#ROOT:mock-component.adoc) testing framework.

# EIPs using correlation identifiers

Some [EIP](#enterprise-integration-patterns.adoc) patterns will spin off
a sub message. In those cases, Camel will add a correlation id on the
[Exchange](#manual::exchange.adoc) as a property with they key
`Exchange.CORRELATION_ID`, which links back to the source
[Exchange](#manual::exchange.adoc) and its exchange id.

The following EIPs does this:

-   [Enrich](#enrich-eip.adoc)

-   [Multicast](#multicast-eip.adoc)

-   [Recipient List](#recipientList-eip.adoc)

-   [Split](#split-eip.adoc)

-   [Wire Tap](#wireTap-eip.adoc)

# Example

The following example uses a request/reply pattern in the
[JMS](#ROOT:jms-component.adoc) component, where correlation identifiers
are automatically handled:

Java  
from("direct:start")
.to(ExchangePattern.InOut, "jms:queue:foo")
.to("mock:result");

XML  
<route>  
<from uri="direct:start"/>  
<to pattern="InOut" uri="jms:queue:foo"/>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: direct:start
steps:
\- to:
uri: jms:queue:foo
pattern: InOut
\- to:
uri: mock:result
