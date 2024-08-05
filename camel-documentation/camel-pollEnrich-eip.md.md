# PollEnrich-eip.md

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
    for instance, to read a file or download a file using
    [FTP](#ROOT:ftp-component.adoc).

This page documents the Poll Enrich EIP.

# Options

# Exchange properties

# Content enrichment using Poll Enrich EIP

`pollEnrich` uses a [Polling Consumer](#polling-consumer.adoc) to obtain
the additional data. It is usually used for [Event
Message](#event-message.adoc) messaging, for instance, to read a file or
download a file using FTP.

The `pollEnrich` works just the same as `enrich`, however, as it uses a
[Polling Consumer](#polling-consumer.adoc), we have three methods when
polling:

-   `receive`: Waits until a message is available and then returns it.
    **Warning** that this method could block indefinitely if no messages
    are available.

-   `receiveNoWait`: Attempts to receive a message exchange immediately
    without waiting and returning `null` if a message exchange is not
    available yet.

-   `receive(timeout)`: Attempts to receive a message exchange, waiting
    up to the given timeout to expire if a message is not yet available.
    Returns the message or `null` if the timeout expired.

## Poll Enrich with timeout

It is good practice to use timeout value.

By default, Camel will use the `receive` which may block until there is
a message available. It is therefore recommended to always provide a
timeout value, to make this clear that we may wait for a message until
the timeout is hit.

You can pass in a timeout value that determines which method to use:

-   if timeout is `-1` or other negative number then `receive` is
    selected (**Important:** the `receive` method may block if there is
    no message)

-   if timeout is `0` then `receiveNoWait` is selected

-   otherwise, `receive(timeout)` is selected

The timeout values are in milliseconds.

## Using Poll Enrich

The content enricher (`pollEnrich`) retrieves additional data from a
*resource endpoint* in order to enrich an incoming message (contained in
the *original exchange*).

An `AggregationStrategy` is used to combine the original exchange and
the *resource exchange*. The first parameter of the
`AggregationStrategy.aggregate(Exchange, Exchange)` method corresponds
to the original exchange, the second parameter the resource exchange.

Here’s an example for implementing an `AggregationStrategy`, which
merges the two data together as a `String` with colon separator:

    public class ExampleAggregationStrategy implements AggregationStrategy {
    
        public Exchange aggregate(Exchange original, Exchange resource) {
            // this is just an example, for real-world use-cases the
            // aggregation strategy would be specific to the use-case
    
            if (resource == null) {
                return original;
            }
            Object oldBody = original.getIn().getBody();
            Object newBody = resource.getIn().getBody();
            original.getIn().setBody(oldBody + ":" + newBody);
            return original;
        }
    
    }

You then use the `AggregationStrategy` with the `pollEnrich` in the Java
DSL as shown:

    AggregationStrategy aggregationStrategy = ...
    
    from("direct:start")
      .pollEnrich("file:inbox?fileName=data.txt", 10000, aggregationStrategy)
      .to("mock:result");

In the example, Camel will poll a file (timeout 10 seconds). The
`AggregationStrategy` is then used to merge the file with the existing
`Exchange`.

In XML DSL you use `pollEnrich` as follows:

    <bean id="myStrategy" class="com.foo.ExampleAggregationStrategy"/>
    
    <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
      <route>
        <from uri="direct:start"/>
        <pollEnrich timeout="10000" aggregationStrategy="myStrategy">
          <constant>file:inbox?fileName=data.txt</constant>
        </pollEnrich>
        <to uri="mock:result"/>
      </route>
    </camelContext>

## Using Poll Enrich with Rest DSL

You can also use `pollEnrich` with [Rest DSL](#manual::rest-dsl.adoc)
to, for example, download a file from [AWS
S3](#ROOT:aws2-s3-component.adoc) as the response of an API call.

    <rest path="/report">
        <description>Report REST API</description>
        <get path="/{id}/payload">
            <route id="report-payload-download">
                <pollEnrich>
                    <constant>aws-s3:xavier-dev?amazonS3Client=#s3client&amp;deleteAfterRead=false&amp;fileName=report-file.pdf</constant>
                </pollEnrich>
            </route>
        </get>
    </rest>

Notice that the enriched endpoint is a constant, however, Camel also
supports dynamic endpoints which is covered next.

## Poll Enrich with Dynamic Endpoints

Both `enrich` and `pollEnrich` supports using dynamic uris computed
based on information from the current `Exchange`.

For example to `pollEnrich` from an endpoint that uses a header to
indicate a SEDA queue name:

Java  
from("direct:start")
.pollEnrich().simple("seda:${header.queueName}")
.to("direct:result");

XML  
<route>  
<from uri="direct:start"/>  
<pollEnrich>  
<simple>seda:${header.queueName}</simple>  
</pollEnrich>  
<to uri="direct:result"/>  
</route>

See the `cacheSize` option for more details on *how much cache* to use
depending on how many or few unique endpoints are used.

# See More

See [Enrich](#enrich-eip.adoc) EIP
