# Point-to-point-channel.md

Camel supports the [Point to Point
Channel](http://www.enterpriseintegrationpatterns.com/PointToPointChannel.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

An application is using Messaging to make remote procedure calls (RPC)
or transfer documents.

How can the caller be sure that exactly one receiver will receive the
document or perform the call?

<figure>
<img src="eip/PointToPointSolution.gif" alt="image" />
</figure>

Send the message on a Point-to-Point Channel, which ensures that only
one receiver will receive a particular message.

The Point to Point Channel is supported in Camel by messaging based
[Components](#ROOT:index.adoc), such as:

-   [AMQP](#ROOT:amqp-component.adoc) for working with AMQP Queues

-   [ActiveMQ](#ROOT:jms-component.adoc), or
    [JMS](#ROOT:jms-component.adoc) for working with JMS Queues

-   [SEDA](#ROOT:seda-component.adoc) for internal Camel seda queue
    based messaging

-   [Spring RabbitMQ](#ROOT:spring-rabbitmq-component.adoc) for working
    with AMQP Queues (RabbitMQ)

There is also messaging based in the cloud from cloud providers such as
Amazon, Google and Azure.

See also the related [Publish Scribe
Channel](#publish-subscribe-channel.adoc) EIP

# Example

The following example demonstrates point to point messaging using the
[JMS](#ROOT:jms-component.adoc) component:

Java  
from("direct:start")
.to("jms:queue:foo");

    from("jms:queue:foo")
        .to("bean:foo");

XML  
<routes>  
<route>  
<from uri="direct:start"/>  
<to uri="jms:queue:foo"/>  
</route>  
<route>  
<from uri="jms:queue:foo"/>  
<to uri="bean:foo"/>  
</route>  
</routes>
