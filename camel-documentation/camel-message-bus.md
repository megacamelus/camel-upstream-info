# Message-bus.md

Camel supports the [Message
Bus](https://www.enterpriseintegrationpatterns.com/MessageBus.html) from
the [EIP patterns](#enterprise-integration-patterns.adoc). You could
view Camel as a Message Bus itself as it allows producers and consumers
to be decoupled.

<figure>
<img src="eip/MessageBusSolution.gif" alt="image" />
</figure>

A messaging system such as Apache ActiveMQ can be used as a Message Bus.

# Example

The following demonstrates how the Camel message bus can be used to
ingest a message into the bus with the [JMS](#ROOT:jms-component.adoc)
component.

Java  
from("file:inbox")
.to("jms:inbox");

XML  
<route>  
<from uri="file:inbox"/>  
<to uri="jms:inbox"/>  
</route>
