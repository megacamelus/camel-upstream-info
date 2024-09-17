# Content-filter-eip.md

Camel supports the [Content
Filter](http://www.enterpriseintegrationpatterns.com/ContentFilter.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) using one
of the following mechanisms in the routing logic to transform content
from the inbound message.

<figure>
<img src="eip/ContentFilter.gif" alt="image" />
</figure>

-   Using a [Message Translator](#message-translator.adoc)

-   Invoking a [Bean](#bean-eip.adoc) with the filtering programmed in
    Java

-   Using a [Processor](#manual::processor.adoc) with the filtering
    programmed in Java

-   Using an [Expression](#manual::expression.adoc)

# Message Content filtering using a Processor

In this example, we add our own [Processor](#manual::processor.adoc)
using explicit Java to filter the message:

    from("direct:start")
        .process(new Processor() {
            public void process(Exchange exchange) {
                String body = exchange.getMessage().getBody(String.class);
                // do something with the body
                // and replace it back
                exchange.getMessage().setBody(body);
            }
        })
        .to("mock:result");

# Message Content filtering using a Bean EIP

We can use [Bean EIP](#bean-eip.adoc) to use any Java method on any bean
to act as a content filter:

Java  
from("activemq:My.Queue")
.bean("myBeanName", "doFilter")
.to("activemq:Another.Queue");

XML  
<route>  
<from uri="activemq:Input"/>  
<bean ref="myBeanName" method="doFilter"/>  
<to uri="activemq:Output"/>  
</route>

YAML  
\- from:
uri: activemq:Input
steps:
\- bean:
ref: myBeanName
method: doFilter
\- to:
uri: activemq:Output

# Message Content filtering using expression

Some languages like [XPath](#languages:xpath-language.adoc), and
[XQuery](#languages:xquery-language.adoc) can be used to transform and
filter content from messages.

In the example we use xpath to filter a XML message to select all the
`<foo><bar>` elements:

Java  
from("activemq:Input")
.setBody().xpath("//foo:bar")
.to("activemq:Output");

XML  
<route>  
<from uri="activemq:Input"/>  
<setBody>  
<xpath>//foo:bar</xpath>  
</setBody>  
<to uri="activemq:Output"/>  
</route>

YAML  
\- from:
uri: activemq:Input
steps:
\- setBody:
expression:
xpath: //foo:bar
\- to:
uri: activemq:Output
