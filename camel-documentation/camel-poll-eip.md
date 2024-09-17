# Poll-eip.md

Camel supports the [Content
Enricher](http://www.enterpriseintegrationpatterns.com/DataEnricher.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

<figure>
<img src="eip/DataEnricher.gif" alt="image" />
</figure>

In Camel the Content Enricher can be done in several ways:

-   Using [Enrich](#enrich-eip.adoc) EIP, [Poll
    Enrich](#pollEnrich-eip.adoc), or [Poll](#poll-eip.adoc) EIP

-   Using a [Message Translator](#message-translator.adoc)

-   Using a [Processor](#manual::processor.adoc) with the enrichment
    programmed in Java

-   Using a [Bean](#bean-eip.adoc) EIP with the enrichment programmed in
    Java

The Poll EIP is a simplified [Poll Enrich](#pollEnrich-eip.adoc) which
only supports:

-   Static Endpoints

-   No custom aggregation or other advanced features

-   Uses a 20 seconds timeout (default)

# Options

# Exchange properties

# Polling a message using Poll EIP

`poll` uses a [Polling Consumer](#polling-consumer.adoc) to obtain the
data. It is usually used for [Event Message](#event-message.adoc)
messaging, for instance, to read a file or download a file using FTP.

We have three methods when polling:

-   `receive`: Waits until a message is available and then returns it.
    **Warning** that this method could block indefinitely if no messages
    are available.

-   `receiveNoWait`: Attempts to receive a message exchange immediately
    without waiting and returning `null` if a message exchange is not
    available yet.

-   `receive(timeout)`: Attempts to receive a message exchange, waiting
    up to the given timeout to expire if a message is not yet available.
    Returns the message or `null` if the timeout expired.

## Timeout

By default, Camel will use the `receive(timeout)` which has a 20 seconds
timeout.

You can pass in a timeout value that determines which method to use:

-   if timeout is `-1` or other negative number then `receive` is
    selected (**Important:** the `receive` method may block if there is
    no message)

-   if timeout is `0` then `receiveNoWait` is selected

-   otherwise, `receive(timeout)` is selected

The timeout values are in milliseconds.

## Using Poll

For example to download an FTP file:

    <rest path="/report">
        <description>Report REST API</description>
        <get path="/{id}/payload">
            <route id="report-payload-download">
                <poll uri="ftp:myserver.com/myfolder?fileName=report-file.pdf"/>
            </route>
        </get>
    </rest>

You can use dynamic values using the simple language in the uri, as
shown below:

    <rest path="/report">
        <description>Report REST API</description>
        <get path="/{id}/payload">
            <route id="report-payload-download">
                <poll uri="ftp:myserver.com/myfolder?fileName=report-${header.id}.pdf"/>
            </route>
        </get>
    </rest>

## Using Poll with Rest DSL

You can also use `poll` with [Rest DSL](#manual::rest-dsl.adoc) to, for
example, download a file from [AWS S3](#ROOT:aws2-s3-component.adoc) as
the response of an API call.

    <rest path="/report">
        <description>Report REST API</description>
        <get path="/{id}/payload">
            <route id="report-payload-download">
                <poll uri="aws-s3:xavier-dev?amazonS3Client=#s3client&amp;deleteAfterRead=false&amp;fileName=report-file.pdf"/>
            </route>
        </get>
    </rest>

# See More

-   [Poll EIP](#poll-eip.adoc)

-   [Enrich EIP](#enrich-eip.adoc)
