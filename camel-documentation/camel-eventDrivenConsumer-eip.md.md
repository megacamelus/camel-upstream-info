# EventDrivenConsumer-eip.md

Camel supports the [Event Driven
Consumer](http://www.enterpriseintegrationpatterns.com/EventDrivenConsumer.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

The default consumer model is event-based (i.e., asynchronous) as this
means that the Camel container can then manage pooling, threading and
concurrency for you in a declarative manner.

The alternative consumer mode is [Polling
Consumer](#polling-consumer.adoc).

<figure>
<img src="eip/EventDrivenConsumerSolution.gif" alt="image" />
</figure>

The Event Driven Consumer is implemented by consumers implementing the
[Processor](http://javadoc.io/doc/org.apache.camel/camel-api/latest/org/apache/camel/Processor.html)
interface which is invoked by the [Message
Endpoint](#message-endpoint.adoc) when a [Message](#message.adoc) is
available for processing.

# Example

The following demonstrates a [Bean](#bean-eip.adoc) being invoked when
an event occurs from a [JMS](#ROOT:jms-component.adoc) queue.

Java  
from("jms:queue:foo")
.bean(MyBean.class);

XML  
<route>  
<from uri="jms:queue:foo"/>  
<bean beanType="com.foo.MyBean"/>  
</route>

YAML  
\- from:
uri: jms:queue:foo
steps:
\- bean:
beanType: com.foo.MyBean
