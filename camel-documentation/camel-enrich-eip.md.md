# Enrich-eip.md

Camel supports the [Content
Enricher](http://www.enterpriseintegrationpatterns.com/DataEnricher.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

<figure>
<img src="eip/DataEnricher.gif" alt="image" />
</figure>

In Camel the Content Enricher can be done in several ways:

-   Using [Enrich](#enrich-eip.adoc) EIP or [Poll
    Enrich](#pollEnrich-eip.adoc) EIP

-   Using a [Message Translator](#message-translator.adoc)

-   Using a [Processor](#manual::processor.adoc) with the enrichment
    programmed in Java

-   Using a [Bean](#bean-eip.adoc) EIP with the enrichment programmed in
    Java

The most natural Camel approach is using [Enrich](#enrich-eip.adoc) EIP,
which comes as two kinds:

-   [Enrich](#enrich-eip.adoc) EIP: This is the most common content
    enricher that uses a `Producer` to obtain the data. It is usually
    used for [Request Reply](#requestReply-eip.adoc) messaging, for
    instance, to invoke an external web service.

-   [Poll Enrich](#pollEnrich-eip.adoc) EIP: Uses a [Polling
    Consumer](#polling-consumer.adoc) to obtain the additional data. It
    is usually used for [Event Message](#event-message.adoc) messaging,
    for instance, to read a file or download one using
    [FTP](#ROOT:ftp-component.adoc).

This page documents the Enrich EIP.

# Exchange properties

# Content enrichment using Enrich EIP

Enrich EIP is the most common content enricher that uses a `Producer` to
obtain the data.

The content enricher (`enrich`) retrieves additional data from a
*resource endpoint* to enrich an incoming message (contained in the
*original exchange*).

An `AggregationStrategy` is used to combine the original exchange and
the *resource exchange*. The first parameter of the
`AggregationStrategy.aggregate(Exchange, Exchange)` method corresponds
to the original exchange, the second parameter the resource exchange.

Here’s an example for implementing an `AggregationStrategy`, which
merges the two data as a `String` with colon separator:

    public class ExampleAggregationStrategy implements AggregationStrategy {
    
        public Exchange aggregate(Exchange newExchange, Exchange oldExchange) {
            // this is just an example, for real-world use-cases the
            // aggregation strategy would be specific to the use-case
    
            if (newExchange == null) {
                return oldExchange;
            }
            Object oldBody = oldExchange.getIn().getBody();
            Object newBody = newExchange.getIn().getBody();
            oldExchange.getIn().setBody(oldBody + ":" + newBody);
            return oldExchange;
        }
    
    }

In the example Camel will call the http endpoint to collect some data,
that will then be merged with the original message using the
`AggregationStrategy`:

Java  
AggregationStrategy aggregationStrategy = ...

    from("direct:start")
      .enrich("http:remoteserver/foo", aggregationStrategy)
      .to("mock:result");

XML  
<bean id="myStrategy" class="com.foo.ExampleAggregationStrategy"/>

    <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <enrich aggregationStrategy="myStrategy">
          <constant>http:remoteserver/foo</constant>
        </enrich>
        <to uri="mock:result"/>
      </route>
    </camelContext>

YAML  
\- from:
uri: direct:start
steps:
\- enrich:
expression:
constant: "http:remoteserver/foo"
aggregationStrategy: "#myStrategy"
\- to:
uri: mock:result
\- beans:
\- name: myStrategy
type: com.foo.ExampleAggregationStrategy

## Aggregation Strategy is optional

The aggregation strategy is optional. If not provided, then Camel will
just use the result exchange as the result.

The following example:

Java  
from("direct:start")
.enrich("http:remoteserver/foo")
.to("direct:result");

XML  
<route>  
<from uri="direct:start"/>  
<enrich>  
<constant>http:remoteserver/foo</constant>  
</enrich>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: direct:start
steps:
\- enrich:
expression:
constant: "http:remoteserver/foo"
\- to:
uri: mock:result

Would be the same as using `to`:

Java  
from("direct:start")
.to("http:remoteserver/foo")
.to("direct:result");

XML  
<route>  
<from uri="direct:start"/>  
<to uri="http:remoteserver/foo"/>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: direct:start
steps:
\- to:
uri: http:remoteserver/foo
\- to:
uri: mock:result

## Using dynamic uris

Both `enrich` and `pollEnrich` supports using dynamic uris computed
based on information from the current Exchange. For example, to enrich
from a HTTP endpoint where the header with key orderId is used as part
of the content-path of the HTTP url:

Java  
from("direct:start")
.enrich().simple("http:myserver/${header.orderId}/order")
.to("direct:result");

XML  
<route>  
<from uri="direct:start"/>  
<enrich>  
<simple>http:myserver/${header.orderId}/order</simple>  
</enrich>  
<to uri="direct:result"/>  
</route>

YAML  
\- from:
uri: direct:start
steps:
\- enrich:
expression:
simple: "http:myserver/${header.orderId}/order"
\- to:
uri: mock:result

See the `cacheSize` option for more details on *how much cache* to use
depending on how many or few unique endpoints are used.

## Using out-of-the-box Aggregation Strategies

The `org.apache.camel.builder.AggregationStrategies` is a builder that
can be used for creating commonly used aggregation strategies without
having to create a class.

For example, the `ExampleAggregationStrategy` from previously can be
built as follows:

    AggregationStrategy agg = AggregationStrategies.string(":");

There are many other possibilities with the `AggregationStrategies`
builder, and for more details see the [AggregationStrategies
javadoc](https://www.javadoc.io/static/org.apache.camel/camel-core-model/3.12.0/org/apache/camel/builder/AggregationStrategies.html).

# See More

See [Poll Enrich](#pollEnrich-eip.adoc) EIP
