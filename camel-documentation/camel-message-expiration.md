# Message-expiration.md

Camel supports the [Message
Expiration](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageExpiration.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How can a sender indicate when a message should be considered stale and
thus should not be processed?

<figure>
<img src="eip/MessageExpirationSolution.gif" alt="image" />
</figure>

Set the Message Expiration to specify a time limit how long the message
is viable.

Message expiration is supported by some Camel components such as
[JMS](#ROOT:jms-component.adoc), which uses *time-to-live* to specify
for how long the message is valid.

When using message expiration, then mind about keeping the systems
clocks' synchronized among the systems.

# Example

A message should expire after 5 seconds:

Java  
from("direct:cheese")
.to("jms:queue:cheese?timeToLive=5000");

XML  
<route>  
<from uri="direct:cheese"/>  
<to uri="jms:queue:cheese?timeToLive=5000"/>  
</route>
