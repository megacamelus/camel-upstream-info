# Message-endpoint.md

Camel supports the [Message
Endpoint](http://www.enterpriseintegrationpatterns.com/MessageEndpoint.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) using the
[Endpoint](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html)
interface.

How does an application connect to a messaging channel to send and
receive messages?

<figure>
<img src="eip/MessageEndpointSolution.gif" alt="image" />
</figure>

Connect an application to a messaging channel using a Message Endpoint,
a client of the messaging system that the application can then use to
send or receive messages.

When using the [DSL](#manual::dsl.adoc) to create
[Routes](#manual::routes.adoc), you typically refer to Message Endpoints
by their [URIs](#manual::uris.adoc) rather than directly using the
[Endpoint](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html)
interface. It’s then a responsibility of the
[CamelContext](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/CamelContext.html)
to create and activate the necessary `Endpoint` instances using the
available [Components](#ROOT:index.adoc).

# Example

The following example route demonstrates the use of a
[File](#ROOT:file-component.adoc) consumer endpoint and a
[JMS](#ROOT:jms-component.adoc) producer endpoint, by their
[URIs](#manual::uris.adoc):

Java  
from("file:messages/foo")
.to("jms:queue:foo");

XML  
<route>  
<from uri="file:messages/foo"/>  
<to uri="jms:queue:foo"/>  
</route>
