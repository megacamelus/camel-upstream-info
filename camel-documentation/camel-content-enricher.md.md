# Content-enricher.md

Camel supports the [Content
Enricher](http://www.enterpriseintegrationpatterns.com/DataEnricher.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

<figure>
<img src="eip/DataEnricher.gif" alt="image" />
</figure>

In Camel the Content Enricher can be done in several ways:

-   Using [Enrich](#enrich-eip.adoc) EIP

-   Using a [Message Translator](#message-translator.adoc)

-   Using a [Processor](#manual::processor.adoc) with the enrichment
    programmed in Java

-   Using a [Bean](#bean-eip.adoc) EIP with the enrichment programmed in
    Java

The most natural Camel approach is using [Enrich](#enrich-eip.adoc) EIP.

# Content enrichment using a Message Translator

You can consume a message from one destination, transform it with
something like [Velocity](#ROOT:velocity-component.adoc) or
[XQuery](#ROOT:xquery-component.adoc), and then send it on to another
destination.

Java  
from("activemq:My.Queue")
.to("velocity:com/acme/MyResponse.vm")
.to("activemq:Another.Queue");

XML  
<route>  
<from uri="activemq:My.Queue"/>  
<to uri="velocity:com/acme/MyResponse.vm"/>  
<to uri="activemq:Another.Queue"/>  
</route>

YAML  
\- from:
uri: activemq:My.Queue
steps:
\- to:
uri: velocity:com/acme/MyResponse.vm
\- to:
uri: activemq:Another.Queue

You can also enrich the message in Java DSL directly (using fluent
builder) as an [Expression](#manual::expression.adoc). In the example
below, the message is enriched by appending \` World!\` to the message
body:

    from("direct:start")
        .setBody(body().append(" World!"))
        .to("mock:result");

The fluent builder is not available in XML or YAML DSL, instead you can
use [Simple](#languages:simple-language.adoc) language:

    <route>
      <from uri="direct:start"/>
      <setBody>
        <simple>${body} World!</simple>
      </setBody>
      <to uri="mock:result"/>
    </route>

# Content enrichment using a Processor

In this example, we add our own [Processor](#manual::processor.adoc)
using explicit Java to enrich the message:

    from("direct:start")
        .process(new Processor() {
            public void process(Exchange exchange) {
                Message msg = exchange.getMessage();
                msg.setBody(msg.getBody(String.class) + " World!");
            }
        })
        .to("mock:result");

# Content enrichment using a Bean EIP

We can use [Bean EIP](#bean-eip.adoc) to use any Java method on any bean
to act as content enricher:

Java  
from("activemq:My.Queue")
.bean("myBeanName", "doTransform")
.to("activemq:Another.Queue");

XML  
<route>  
<from uri="activemq:Input"/>  
<bean ref="myBeanName" method="doTransform"/>  
<to uri="activemq:Output"/>  
</route>

YAML  
\- from:
uri: activemq:Input
steps:
\- bean:
ref: myBeanName
method: doTransform
\- to:
uri: activemq:Output

# Content enrichment using Enrich EIP

Camel comes with two kinds of Content Enricher EIPs:

-   [Enrich](#enrich-eip.adoc) EIP: This is the most common content
    enricher that uses a `Producer` to obtain the data. It is usually
    used for [Request Reply](#requestReply-eip.adoc) messaging, for
    instance, to invoke an external web service.

-   [Poll Enrich](#pollEnrich-eip.adoc) EIP: Uses a [Polling
    Consumer](#polling-consumer.adoc) to obtain the additional data. It
    is usually used for [Event Message](#event-message.adoc) messaging,
    for instance, to read a file or download one using
    [FTP](#ROOT:ftp-component.adoc).

For more details, see [Enrich](#enrich-eip.adoc) EIP and [Poll
Enrich](#pollEnrich-eip.adoc) EIP.
