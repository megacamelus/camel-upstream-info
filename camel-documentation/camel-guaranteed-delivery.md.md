# Guaranteed-delivery.md

Camel supports the [Guaranteed
Delivery](http://www.enterpriseintegrationpatterns.com/GuaranteedMessaging.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) using
among others the following components:

-   [File](#ROOT:file-component.adoc) for using file systems as a
    persistent store of messages

-   [JMS](#ROOT:jms-component.adoc) when using persistent delivery, the
    default, for working with JMS queues and topics for high
    performance, clustering and load balancing

-   [Kafka](#ROOT:kafka-component.adoc) when using persistent delivery
    for working with streaming events for high performance, clustering
    and load balancing

-   [JPA](#ROOT:jpa-component.adoc) for using a database as a
    persistence layer, or use any of the other database components such
    as [SQL](#ROOT:sql-component.adoc),
    [JDBC](#ROOT:jdbc-component.adoc), or
    [MyBatis](#ROOT:mybatis-component.adoc)

<figure>
<img src="eip/GuaranteedMessagingSolution.gif" alt="image" />
</figure>

# Example

The following example demonstrates illustrates the use of [Guaranteed
Delivery](http://www.enterpriseintegrationpatterns.com/GuaranteedMessaging.html)
within the [JMS](#ROOT:jms-component.adoc) component.

By default, a message is not considered successfully delivered until the
recipient has persisted the message locally guaranteeing its receipt in
the event the destination becomes unavailable.

Java  
from("direct:start")
.to("jms:queue:foo");

XML  
<route>  
<from uri="direct:start"/>  
<to uri="jms:queue:foo"/>  
</route>
