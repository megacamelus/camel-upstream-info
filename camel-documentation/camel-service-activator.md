# Service-activator.md

Camel supports the [Service
Activator](https://www.enterpriseintegrationpatterns.com/patterns/messaging/MessagingAdapter.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

How can an application design a service to be invoked both via various
messaging technologies and via non-messaging techniques?

<figure>
<img src="eip/MessagingAdapterSolution.gif" alt="image" />
</figure>

Design a Service Activator that connects the messages on the channel to
the service being accessed.

Camel has several [Components](#ROOT:index.adoc) that support the
Service Activator EIP.

Components like [Bean](#ROOT:bean-component.adoc) and
[CXF](#ROOT:bean-component.adoc) provide a way to bind the message
[Exchange](#manual::exchange.adoc) to a Java interface/service where the
route defines the endpoints and wires it up to the bean.

In addition, you can use the [Bean
Integration](#manual::bean-integration.adoc) to wire messages to a bean
using Java annotation.

# Example

Here is a simple example of using a
[Direct](#ROOT:direct-component.adoc) endpoint to create a messaging
interface to a POJO [Bean](#ROOT:bean-component.adoc) service.

Java  
from("direct:invokeMyService")
.to("bean:myService");

XML  
<route>  
<from uri="direct:invokeMyService"/>  
<to uri="bean:myService"/>  
</route>
