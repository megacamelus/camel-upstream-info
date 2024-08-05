# Message-dispatcher.md

Camel supports the [Message
Dispatcher](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessageDispatcher.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

<figure>
<img src="eip/MessageDispatcher.gif" alt="image" />
</figure>

In Apache Camel, the Message Dispatcher can be achieved in different
ways such as:

-   You can use a component like [JMS](#ROOT:jms-component.adoc) with
    selectors to implement a [Selective
    Consumer](#selective-consumer.adoc) as the Message Dispatcher
    implementation.

-   Or you can use a [Message Endpoint](#message-endpoint.adoc) as the
    Message Dispatcher itself, or combine this with the [Content-Based
    Router](#choice-eip.adoc) as the Message Dispatcher.
