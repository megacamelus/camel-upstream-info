# Messaging-bridge.md

Camel supports the [Messaging
Bridge](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingBridge.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How can multiple messaging systems be connected so that messages
available on one are also available on the others?

<figure>
<img src="eip/MessagingBridge.gif" alt="image" />
</figure>

Use a Messaging Bridge, a connection between messaging systems, to
replicate messages between systems.

You can use Camel to bridge different systems using Camel
[Components](#ROOT:index.adoc) and bridge the endpoints together in a
[Route](#manual::routes.adoc).

Another alternative is to bridge systems using [Change Data
Capture](#change-data-capture.adoc).

# Example

A basic bridge between two messaging systems (such as WebsphereMQ and
[JMS](#ROOT:jms-component.adoc) broker) can be done with a single Camel
route:

Java  
from("mq:queue:foo")
.to("jms:queue:foo")

XML  
<route>  
<from uri="mq:queue:foo"/>  
<to uri="jms:queue:foo"/>  
</route>
