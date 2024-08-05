# Messaging-gateway.md

Camel supports the [Messaging
Gateway](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingGateway.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

How do you encapsulate access to the messaging system from the rest of
the application?

<figure>
<img src="eip/MessagingGatewaySolution.gif" alt="image" />
</figure>

Use a Messaging Gateway, a class that wraps messaging-specific method
calls and exposes domain-specific methods to the application.

Camel has several endpoint components that support the Messaging Gateway
from the EIP patterns. Components like [Bean](#ROOT:bean-component.adoc)
provide a way to bind a Java interface to the message exchange.

Another approach is to use `@Produce` annotations ([POJO
Producing](#manual::pojo-producing.adoc)) which also can be used to hide
Camel APIs and thereby encapsulate access, acting as a Messaging Gateway
EIP solution.
