# Polling-consumer.md

Camel supports implementing the [Polling
Consumer](http://www.enterpriseintegrationpatterns.com/PollingConsumer.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc).

An application needs to consume Messages, but it wants to control when
it consumes each message.

How can an application consume a message when the application is ready?

<figure>
<img src="eip/PollingConsumerSolution.gif" alt="image" />
</figure>

The application should use a Polling Consumer, one that explicitly makes
a call when it wants to receive a message.

In Camel the `PollingConsumer` is represented by the
[PollingConsumer](https://github.com/apache/camel/blob/main/core/camel-api/src/main/java/org/apache/camel/PollingConsumer.java)
interface.

You can get hold of a `PollingConsumer` in several ways in Camel:

-   Use [Poll Enrich](#pollEnrich-eip.adoc) EIP

-   Create a `PollingConsumer` instance via the
    [Endpoint.createPollingConsumer()](https://github.com/apache/camel/blob/main/core/camel-api/src/main/java/org/apache/camel/Endpoint.java)
    method.

-   Use the [ConsumerTemplate](#manual::consumertemplate.adoc) to poll
    on demand.

# Using Polling Consumer

If you need to use Polling Consumer from within a route, then the [Poll
Enrich](#pollEnrich-eip.adoc) EIP can be used.

On the other hand, if you need to use Polling Consumer programmatically,
then using [ConsumerTemplate](#manual::consumertemplate.adoc) is a good
choice.

And if you want to use the lower level Camel APIs, then you can create
the `PollingConsumer` instance to be used.

## Using Polling Consumer from Java

You can programmatically create an instance of `PollingConsumer` from
any endpoint as shown below:

    Endpoint endpoint = context.getEndpoint("activemq:my.queue");
    PollingConsumer consumer = endpoint.createPollingConsumer();
    Exchange exchange = consumer.receive();

## PollingConsumer API

There are three main polling methods on
[PollingConsumer](https://github.com/apache/camel/blob/main/core/camel-api/src/main/java/org/apache/camel/PollingConsumer.java):

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Method name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><a
href="https://github.com/apache/camel/blob/main/core/camel-api/src/main/java/org/apache/camel/PollingConsumer.java">PollingConsumer.receive()</a></p></td>
<td style="text-align: left;"><p>Waits until a message is available and
then returns it; potentially blocking forever</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><a
href="https://github.com/apache/camel/blob/main/core/camel-api/src/main/java/org/apache/camel/PollingConsumer.java">PollingConsumer.receive(long)</a></p></td>
<td style="text-align: left;"><p>Attempts to receive a message exchange,
waiting up to the given timeout and returning null if no message
exchange could be received within the time available</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><a
href="https://github.com/apache/camel/blob/main/core/camel-api/src/main/java/org/apache/camel/PollingConsumer.java">PollingConsumer.receiveNoWait()</a></p></td>
<td style="text-align: left;"><p>Attempts to receive a message exchange
immediately without waiting and returning null if a message exchange is
not available yet</p></td>
</tr>
</tbody>
</table>

## Two kinds of Polling Consumer implementations

In Camel there are two kinds of `PollingConsumer` implementations:

-   *Custom*: Some components have their own custom implementation of
    `PollingConsumer` which is optimized for the given component.

-   *Default*: `EventDrivenPollingConsumer` is the default
    implementation otherwise.

The `EventDrivenPollingConsumer` supports the following options:

<table>
<colgroup>
<col style="width: 34%" />
<col style="width: 32%" />
<col style="width: 32%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>pollingConsumerQueueSize</code></p></td>
<td style="text-align: left;"><p><code>1000</code></p></td>
<td style="text-align: left;"><p>The queue size for the internal
hand-off queue between the polling consumer and producers sending data
into the queue.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>pollingConsumerBlockWhenFull</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Whether to block any producer if the
internal queue is full.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>pollingConsumerBlockTimeout</code></p></td>
<td style="text-align: left;"><p>0</p></td>
<td style="text-align: left;"><p>To use a timeout (in milliseconds) when
the producer is blocked if the internal queue is full. If the value is
<code>0</code> or negative then no timeout is in use. If a timeout is
triggered then a <code>ExchangeTimedOutException</code> is
thrown.</p></td>
</tr>
</tbody>
</table>

You can configure these options in endpoints [URIs](#manual::uris.adoc),
such as shown below:

    Endpoint endpoint =
    context.getEndpoint("file:inbox?pollingConsumerQueueSize=50");
    PollingConsumer consumer = endpoint.createPollingConsumer();
    Exchange exchange = consumer.receive(5000);
