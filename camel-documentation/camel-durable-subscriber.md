# Durable-subscriber.md

Camel supports the [Durable
Subscriber](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DurableSubscription.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

Camel supports the Durable Subscriber from the EIP patterns using
components, such as the [JMS](#ROOT:jms-component.adoc) or
[Kafka](#ROOT:kafka-component.adoc) component, which supports publish \&
subscribe using topics with support for non-durable and durable
subscribers.

<figure>
<img src="eip/DurableSubscriptionSolution.gif" alt="image" />
</figure>

# Example

Here is a simple example of creating durable subscribers to a JMS topic:

Java  
from("direct:start")
.to("activemq:topic:foo");

    from("activemq:topic:foo?clientId=1&durableSubscriptionName=bar1")
      .to("mock:result1");
    
    from("activemq:topic:foo?clientId=2&durableSubscriptionName=bar2")
      .to("mock:result2");

XML  
<routes>  
<route>  
<from uri="direct:start"/>  
<to uri="activemq:topic:foo"/>  
</route>

        <route>
            <from uri="activemq:topic:foo?clientId=1&amp;durableSubscriptionName=bar1"/>
            <to uri="mock:result1"/>
        </route>
    
        <route>
            <from uri="activemq:topic:foo?clientId=2&amp;durableSubscriptionName=bar2"/>
            <to uri="mock:result2"/>
        </route>
    </routes>
