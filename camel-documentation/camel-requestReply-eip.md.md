# RequestReply-eip.md

Camel supports the [Request
Reply](http://www.enterpriseintegrationpatterns.com/RequestReply.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

When an application sends a message, how can it get a response from the
receiver?

<figure>
<img src="eip/RequestReply.gif" alt="image" />
</figure>

Send a pair of Request-Reply messages, each on its own channel.

Camel supports Request Reply by the [Exchange
Pattern](#manual::exchange-pattern.adoc) on a [Message](#message.adoc)
which can be set to `InOut` to indicate a request/reply message. Camel
[Components](#ROOT:index.adoc) then implement this pattern using the
underlying transport or protocols.

For example, when using [JMS](#ROOT:jms-component.adoc) with `InOut` the
component will by default perform these actions:

-   create by default a temporary inbound queue

-   set the `JMSReplyTo` destination on the request message

-   set the `JMSCorrelationID` on the request message

-   send the request message

-   consume the response and associate the inbound message to the
    belonging request using the `JMSCorrelationID` (as you may be
    performing many concurrent request/responses).

-   continue routing when the reply is received and populated on the
    [Exchange](#manual::exchange.adoc)

See the related [Event Message](#eips:event-message.adoc).

# Using endpoint URI

If you are using a component which defaults to `InOnly` you can override
the [Exchange Pattern](#manual::exchange-pattern.adoc) for a
**consumer** endpoint using the pattern property.

    foo:bar?exchangePattern=InOut

This is only possible on endpoints used by consumers (i.e., in
`<from>`).

In the example below the message will be forced as a request reply
message as the consumer is in `InOut` mode.

Java  
from("jms:someQueue?exchangePattern=InOut")
.to("bean:processMessage");

XML  
<route>  
<from uri="jms:someQueue?exchangePattern=InOut"/>  
<to uri="bean:processMessage"/>  
</route>

# Using setExchangePattern EIP

You can specify the [Exchange Pattern](#manual::exchange-pattern.adoc)
using `setExchangePattern` in the DSL.

Java  
from("direct:foo")
.setExchangePattern(ExchangePattern.InOut)
.to("jms:queue:cheese");

XML  
<route>  
<from uri="direct:foo"/>  
<setExchangePattern pattern="InOut"/>  
<to uri="jms:queue:cheese"/>  
</route>

When using `setExchangePattern` then the [Exchange
Pattern](#manual::exchange-pattern.adoc) on the
[Exchange](#manual::exchange.adoc) is changed from this point onwards in
the route.

This means you can change the pattern back again at a later point:

    from("direct:foo")
      .setExchangePattern(ExchangePattern.InOnly)
      .to("jms:queue:one-way");
      .setExchangePattern(ExchangePattern.InOut)
      .to("jms:queue:in-and-out")
      .log("InOut MEP received ${body}")

Using `setExchangePattern` to change the [Exchange
Pattern](#manual::exchange-pattern.adoc) is often only used in special
use-cases where you must force to be using either `InOnly` or `InOut`
mode when using components that support both modes (such as messaging
components like ActiveMQ, JMS, RabbitMQ etc.)

# JMS component and InOnly vs. InOut

When consuming messages from [JMS](#ROOT:jms-component.adoc) a Request
Reply is indicated by the presence of the `JMSReplyTo` header. This
means the JMS component automatic detects whether to use `InOnly` or
`InOut` in the consumer.

Likewise, the JMS producer will check the current [Exchange
Pattern](#manual::exchange-pattern.adoc) on the
[Exchange](#manual::exchange.adoc) to know whether to use `InOnly` or
`InOut` mode (i.e., one-way vs. request/reply messaging)
