# Return-address.md

Camel supports the [Return
Address](http://www.enterpriseintegrationpatterns.com/ReturnAddress.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How does a replier know where to send the reply?

<figure>
<img src="eip/ReturnAddressSolution.gif" alt="image" />
</figure>

The request message should contain a Return Address that indicates where
to send the reply message.

Camel supports Return Address by messaging
[Components](#ROOT:index.adoc) that provides this functionality such as
the [JMS](#ROOT:jms-component.adoc) component via the `JMSReplyTo`
header.

# Example

In the example below we send a message to the JMS cheese queue using
`InOut` mode, this means that Camel will automatically configure the
`JMSReplyTo` header with a temporary queue as the Return Address.

Java  
from("direct:foo")
.to(ExchangePattern.InOut, "jms:queue:cheese");

XML  
<route>  
<from uri="direct:foo"/>  
<to pattern="InOut" uri="jms:queue:cheese"/>  
</route>

You can also specify a named reply queue with the `replyTo` option
(instead of a temporary queue). When doing so then `InOut` mode is
implied:

Java  
from("direct:foo")
.to("jms:queue:cheese?replyTo=myReplyQueue");

XML  
<route>  
<from uri="direct:foo"/>  
<to uri="jms:queue:cheese?replyTo=myReplyQueue"/>  
</route>

# See Also

See the related [Request Reply](#requestReply-eip.adoc) EIP.
