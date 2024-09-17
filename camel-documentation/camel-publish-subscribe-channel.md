# Publish-subscribe-channel.md

Camel supports the [Publish-Subscribe
Channel](http://www.enterpriseintegrationpatterns.com/PublishSubscribeChannel.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

How can the sender broadcast an event to all interested receivers?

<figure>
<img src="eip/PublishSubscribeSolution.gif" alt="image" />
</figure>

Send the event on a Publish-Subscribe Channel, which delivers a copy of
a particular event to each receiver.

The Publish-Subscribe Channel is supported in Camel by messaging based
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

See also the related [Point to Point
Channel](#point-to-point-channel.adoc) EIP

# Example

The following example demonstrates publish subscriber messaging using
the [JMS](#ROOT:jms-component.adoc) component with JMS topics:

Java  
from("direct:start")
.to("jms:topic:cheese");

    from("jms:topic:cheese")
        .to("bean:foo");
    
    from("jms:topic:cheese")
        .to("bean:bar");

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
