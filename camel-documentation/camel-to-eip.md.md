# To-eip.md

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

In Camel the To EIP is used for sending [messages](#message.adoc) to
static [endpoints](#message-endpoint.adoc).

The To and [ToD](#toD-eip.adoc) EIPs are the most common patterns to use
in Camel [routes](#manual:ROOT:routes.adoc).

# Options

# Exchange properties

# Different between To and ToD

The `to` is used for sending messages to a static
[endpoint](#message-endpoint.adoc). In other words `to` sends messages
only to the **same** endpoint.

The `toD` is used for sending messages to a dynamic
[endpoint](#message-endpoint.adoc). The dynamic endpoint is evaluated
*on-demand* by an [Expression](#manual:ROOT:expression.adoc). By
default, the [Simple](#components:languages:simple-language.adoc)
expression is used to compute the dynamic endpoint URI.

the Java DSL also provides a `toF` EIP, which can be used to avoid
concatenating route parameters and making the code harder to read.

# Using To

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

YAML  
\- from:
uri: file:messages/foo
steps:
\- to:
uri: jms:queue:foo
