# Messaging-mapper.md

Camel supports the [Messaging
Mapper](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingMapper.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

How do you move data between domain objects and the messaging
infrastructure while keeping the two independent of each other?

<figure>
<img src="eip/MessagingMapperClassDiagram.gif" alt="image" />
</figure>

Create a separate Messaging Mapper that contains the mapping logic
between the messaging infrastructure and the domain objects. Neither the
objects nor the infrastructure has knowledge of the Messaging Mapper’s
existence.

The Messaging Mapper accesses one or more domain objects and converts
them into a message as required by the messaging channel. It also
performs the opposite function, creating or updating domain objects
based on incoming messages. Since the Messaging Mapper is implemented as
a separate class that references the domain object(s) and the messaging
layer, neither layer is aware of the other. The layers don’t even know
about the Messaging Mapper.

With Camel, this pattern is often implemented directly via Camel
components that provide [Type Converters](#manual::type-converter.adoc)
from the messaging infrastructure to common Java types or Java Objects
representing the data model of the component in question. Combining this
with the [Message Translator](#message-translator.adoc) to have the
Messaging Mapper EIP pattern.
