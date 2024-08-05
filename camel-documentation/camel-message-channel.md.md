# Message-channel.md

Camel supports the [Message
Channel](http://www.enterpriseintegrationpatterns.com/MessageChannel.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

The Message Channel is an internal implementation detail of the
`Endpoint` interface, where all interactions of the channel is via the
[Endpoint](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html).

<figure>
<img src="eip/MessageChannelSolution.gif" alt="image" />
</figure>

# Example

In [JMS](#ROOT:jms-component.adoc), Message Channels are represented by
topics and queues such as the following:

    jms:queue:foo

The following shows a little route snippet:

Java  
from("file:foo")
.to("jms:queue:foo")

XML  
<route>  
<from uri="file:foo"/>  
<to uri="jms:queue:foo"/>  
</route>
