# Jms

**Since Camel 1.0**

**Both producer and consumer are supported**

This component allows messages to be sent to (or consumed from) a
[JMS](http://java.sun.com/products/jms/) Queue or Topic. It uses
Spring’s JMS support for declarative transactions, including Spring’s
`JmsTemplate` for sending and a `MessageListenerContainer` for
consuming.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jms</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

**Using ActiveMQ**

If you are using [Apache ActiveMQ](http://activemq.apache.org/), you
should prefer the ActiveMQ component as it has been optimized for
ActiveMQ. All the options and samples on this page are also valid for
the ActiveMQ component.

**Transacted and caching**

See section *Transactions and Cache Levels* below if you are using
transactions with [JMS](#jms-component.adoc) as it can impact
performance.

**Request/Reply over JMS**

Make sure to read the section *Request-reply over JMS* further below on
this page for important notes about request/reply, as Camel offers a
number of options to configure for performance, and clustered
environments.

# URI format

    jms:[queue:|topic:]destinationName[?options]

Where `destinationName` is a JMS queue or topic name. By default, the
`destinationName` is interpreted as a queue name. For example, to
connect to the queue, `FOO.BAR` use:

    jms:FOO.BAR

You can include the optional `queue:` prefix, if you prefer:

    jms:queue:FOO.BAR

To connect to a topic, you *must* include the `topic:` prefix. For
example, to  
connect to the topic, `Stocks.Prices`, use:

    jms:topic:Stocks.Prices

You append query options to the URI by using the following format,
`?option=value&option=value&...`

# Notes

## Using ActiveMQ

The JMS component reuses Spring 2’s `JmsTemplate` for sending messages.
This is not ideal for use in a non-J2EE container and typically requires
some caching in the JMS provider to avoid [poor
performance](http://activemq.apache.org/jmstemplate-gotchas.html).

If you intend to use [Apache ActiveMQ](http://activemq.apache.org/) as
your message broker, the recommendation is that you do one of the
following:

-   Use the ActiveMQ component, which is already optimized to use
    ActiveMQ efficiently

-   Use the `PoolingConnectionFactory` in ActiveMQ.

## Transactions and Cache Levels

If you are consuming messages and using transactions (`transacted=true`)
then the default settings for cache level can impact performance.

If you are using XA transactions, then you cannot cache as it can cause
the XA transaction to not work properly.

If you are **not** using XA, then you should consider caching as it
speeds up performance, such as setting `cacheLevelName=CACHE_CONSUMER`.

The default setting for `cacheLevelName` is `CACHE_AUTO`. This default
auto-detects the mode and sets the cache level accordingly to:

-   `CACHE_CONSUMER` if `transacted=false`

-   `CACHE_NONE` if `transacted=true`

So you can say the default setting is conservative. Consider using
`cacheLevelName=CACHE_CONSUMER` if you are using non-XA transactions.

## Durable Subscriptions

### Durable Subscriptions with JMS 2.0

If you wish to use durable topic subscriptions, you need to specify the
`durableSubscriptionName`.

### Durable Subscriptions with JMS 1.1

If you wish to use durable topic subscriptions, you need to specify both
`clientId` and `durableSubscriptionName`. The value of the `clientId`
must be unique and can only be used by a single JMS connection instance
in your entire network.

If you are using the [Apache ActiveMQ
Classic](https://activemq.apache.org/components/classic/) or [Apache
ActiveMQ Artemis](https://activemq.apache.org/components/artemis/), you
may prefer to use a feature called Virtual Topic. This should remove the
necessity of having a unique `clientId`.

You can consult the specific documentation for
[Artemis](https://activemq.apache.org/components/artemis/migration-documentation/VirtualTopics.html)
or for [ActiveMQ
Classic](https://activemq.apache.org/virtual-destinations.html) for
details about how to leverage this feature.

You can find more details about durable messaging for ActiveMQ Classic
[here](http://activemq.apache.org/how-do-durable-queues-and-topics-work.html).

## Message Header Mapping

When using message headers, the JMS specification states that header
names must be valid Java identifiers. So try to name your headers to be
valid Java identifiers. One benefit of doing this is that you can then
use your headers inside a JMS Selector (whose SQL92 syntax mandates Java
identifier syntax for headers).

The current header name strategy for accepting header names in Camel is
as follows:

-   Dots are replaced by `\_DOT_` and the replacement is reversed when
    Camel consume the message

-   Hyphen is replaced by `\_HYPHEN_` and the replacement is reversed
    when Camel consumes the message

Camel comes with two implementations of `HeaderFilterStrategy`:

-   `org.apache.camel.component.jms.ClassicJmsHeaderFilterStrategy` -
    classic strategy used until Camel 4.8.

-   `org.apache.camel.component.jms.JmsHeaderFilterStrategy` - newer
    default strategy from Camel 4.9 onwards.

### ClassicJmsHeaderFilterStrategy

A classic strategy for mapping header names is used in Camel 4.8 or
older.

This strategy also includes Camel internal headers such as
`CamelFileName` and `CamelBeanMethodName` which means that you can send
Camel messages over JMS to another Camel instance and preserve this
information. However, this also means that JMS messages contains
properties with `Camel...` keys. This is not desirable always, and
therefore we changed default from Camel 4.9 onwards.

You can always configure a custom `HeaderFilterStrategy` to remove all
`Camel...` headers in Camel 4.8 or older.

### JmsHeaderFilterStrategy

The new default strategy from Camel 4.9 onwards behaves similar to other
components, where `Camel...` headers are removed, and only allowing
explicit end user headers.

**Mapping to Spring JMS**

Many of these properties map to properties on Spring JMS, which Camel
uses for sending and receiving messages. So you can get more information
about these properties by consulting the relevant Spring documentation.

# Examples

JMS is used in many examples for other components as well. But we
provide a few samples below to get started.

## Receiving from JMS

In the following sample, we configure a route that receives JMS messages
and routes the message to a POJO:

    from("jms:queue:foo").
       to("bean:myBusinessLogic");

You can use any of the EIP patterns so the route can be context based.
For example, here’s how to filter an order topic for the big spenders:

    from("jms:topic:OrdersTopic").
      filter().method("myBean", "isGoldCustomer").
      to("jms:queue:BigSpendersQueue");

## Sending to JMS

In the sample below, we poll a file folder and send the file content to
a JMS topic. As we want the content of the file as a `TextMessage`
instead of a `BytesMessage`, we need to convert the body to a `String`:

    from("file://orders").
      convertBodyTo(String.class).
      to("jms:topic:OrdersTopic");

## Using Annotations

Camel also has annotations, so you can use [POJO
Consuming](#manual::pojo-consuming.adoc) and [POJO
Producing](#manual::pojo-producing.adoc).

## Spring DSL Example

The preceding examples use the Java DSL. Camel also supports Spring XML
DSL. Here is the big spender sample using Spring DSL:

    <route>
      <from uri="jms:topic:OrdersTopic"/>
      <filter>
        <method ref="myBean" method="isGoldCustomer"/>
        <to uri="jms:queue:BigSpendersQueue"/>
      </filter>
    </route>

## Other Examples

JMS appears in many of the examples for other components and EIP
patterns, as well in this Camel documentation. So feel free to browse
the documentation.

## Using JMS as a Dead Letter Queue storing Exchange

Normally, when using [JMS](#jms-component.adoc) as the transport, it
only transfers the body and headers as the payload. If you want to use
[JMS](#jms-component.adoc) with a [Dead Letter
Channel](#eips:dead-letter-channel.adoc), using a JMS queue as the Dead
Letter Queue, then normally the caused Exception is not stored in the
JMS message. You can, however, use the `transferExchange` option on the
JMS dead letter queue to instruct Camel to store the entire Exchange in
the queue as a `javax.jms.ObjectMessage` that holds a
`org.apache.camel.support.DefaultExchangeHolder`. This allows you to
consume from the Dead Letter Queue and retrieve the caused exception
from the Exchange property with the key `Exchange.EXCEPTION_CAUGHT`. The
demo below illustrates this:

    // setup error handler to use JMS as queue and store the entire Exchange
    errorHandler(deadLetterChannel("jms:queue:dead?transferExchange=true"));

Then you can consume from the JMS queue and analyze the problem:

    from("jms:queue:dead").to("bean:myErrorAnalyzer");
    
    // and in our bean
    String body = exchange.getIn().getBody();
    Exception cause = exchange.getProperty(Exchange.EXCEPTION_CAUGHT, Exception.class);
    // the cause message is
    String problem = cause.getMessage();

## Using JMS as a Dead Letter Channel storing error only

You can use JMS to store the cause error message or to store a custom
body, which you can initialize yourself. The following example uses the
Message Translator EIP to do a transformation on the failed exchange
before it is moved to the [JMS](#jms-component.adoc) dead letter queue:

    // we sent it to a seda dead queue first
    errorHandler(deadLetterChannel("seda:dead"));
    
    // and on the seda dead queue we can do the custom transformation before its sent to the JMS queue
    from("seda:dead").transform(exceptionMessage()).to("jms:queue:dead");

Here we only store the original cause error message in the transform.
You can, however, use any Expression to send whatever you like. For
example, you can invoke a method on a Bean or use a custom processor.

# Usage

## Message Mapping between JMS and Camel

Camel automatically maps messages between `javax.jms.Message` and
`org.apache.camel.Message`.

When sending a JMS message, Camel converts the message body to the
following JMS message types:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Body Type</th>
<th style="text-align: left;">JMS Message</th>
<th style="text-align: left;">Comment</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>String</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.TextMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>org.w3c.dom.Node</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.TextMessage</code></p></td>
<td style="text-align: left;"><p>The DOM will be converted to
<code>String</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>Map</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.MapMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>java.io.Serializable</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.ObjectMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>byte[]</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.BytesMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>java.io.File</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.BytesMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>java.io.Reader</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.BytesMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>java.io.InputStream</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.BytesMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>java.nio.ByteBuffer</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.BytesMessage</code></p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

When receiving a JMS message, Camel converts the JMS message to the
following body type:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">JMS Message</th>
<th style="text-align: left;">Body Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>javax.jms.TextMessage</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>javax.jms.BytesMessage</code></p></td>
<td style="text-align: left;"><p><code>byte[]</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>javax.jms.MapMessage</code></p></td>
<td
style="text-align: left;"><p><code>Map&lt;String, Object&gt;</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>javax.jms.ObjectMessage</code></p></td>
<td style="text-align: left;"><p><code>Object</code></p></td>
</tr>
</tbody>
</table>

## Disabling auto-mapping of JMS messages

You can use the `mapJmsMessage` option to disable the auto-mapping
above. If disabled, Camel will not try to map the received JMS message,
but instead uses it directly as the payload. This allows you to avoid
the overhead of mapping and let Camel just pass through the JMS message.
For instance, it even allows you to route `javax.jms.ObjectMessage` JMS
messages with classes you do **not** have on the classpath.

## Using a custom MessageConverter

You can use the `messageConverter` option to do the mapping yourself in
a Spring `org.springframework.jms.support.converter.MessageConverter`
class.

For example, in the route below, we use a custom message converter when
sending a message to the JMS order queue:

    from("file://inbox/order").to("jms:queue:order?messageConverter=#myMessageConverter");

You can also use a custom message converter when consuming from a JMS
destination.

## Controlling the mapping strategy selected

You can use the `jmsMessageType` option on the endpoint URL to force a
specific message type for all messages.

In the route below, we poll files from a folder and send them as
`javax.jms.TextMessage` as we have forced the JMS producer endpoint to
use text messages:

    from("file://inbox/order").to("jms:queue:order?jmsMessageType=Text");

You can also specify the message type to use for each message by setting
the header with the key `CamelJmsMessageType`. For example:

    from("file://inbox/order").setHeader("CamelJmsMessageType", JmsMessageType.Text).to("jms:queue:order");

The possible values are defined in the `enum` class,
`org.apache.camel.jms.JmsMessageType`.

## Message format when sending

The exchange sent over the JMS wire must conform to the [JMS Message
spec](http://java.sun.com/j2ee/1.4/docs/api/javax/jms/Message.html).

For the `exchange.in.header` the following rules apply for the header
**keys**:

-   Keys starting with `JMS` or `JMSX` are reserved.

-   `exchange.in.headers` keys must be literals and all be valid Java
    identifiers (do not use dots in the key name).

-   Camel replaces dots \& hyphens and the reverse when consuming JMS
    messages:  
    `.` is replaced by `_DOT_` and the reverse replacement when Camel
    consumes the message.  
    `-` is replaced by `_HYPHEN_` and the reverse replacement when Camel
    consumes the message.

-   See also the option `jmsKeyFormatStrategy`, which allows use of your
    own custom strategy for formatting keys.

For the `exchange.in.header`, the following rules apply for the header
**values**:

-   The values must be primitives or their counter-objects (such as
    `Integer`, `Long`, `Character`). The types, `String`,
    `CharSequence`, `Date`, `BigDecimal` and `BigInteger` are all
    converted to their `toString()` representation. All other types are
    dropped.

Camel will log with category `org.apache.camel.component.jms.JmsBinding`
at **DEBUG** level if it drops a given header value. For example:

    2008-07-09 06:43:04,046 [main           ] DEBUG JmsBinding
      - Ignoring non primitive header: order of class: org.apache.camel.component.jms.issues.DummyOrder with value: DummyOrder{orderId=333, itemId=4444, quantity=2}

## Message format when receiving

Camel adds the following properties to the `Exchange` when it receives a
message:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>org.apache.camel.jms.replyDestination</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.Destination</code></p></td>
<td style="text-align: left;"><p>The reply destination.</p></td>
</tr>
</tbody>
</table>

Camel adds the following JMS properties to the In message headers when
it receives a JMS message:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>JMSCorrelationID</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The JMS correlation ID.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>JMSDeliveryMode</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The JMS delivery mode.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>JMSDestination</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.Destination</code></p></td>
<td style="text-align: left;"><p>The JMS destination.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>JMSExpiration</code></p></td>
<td style="text-align: left;"><p><code>long</code></p></td>
<td style="text-align: left;"><p>The JMS expiration.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>JMSMessageID</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The JMS unique message ID.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>JMSPriority</code></p></td>
<td style="text-align: left;"><p><code>int</code></p></td>
<td style="text-align: left;"><p>The JMS priority (with 0 as the lowest
priority and 9 as the highest).</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>JMSRedelivered</code></p></td>
<td style="text-align: left;"><p><code>boolean</code></p></td>
<td style="text-align: left;"><p>Whether the JMS message is
redelivered.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>JMSReplyTo</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.Destination</code></p></td>
<td style="text-align: left;"><p>The JMS reply-to destination.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>JMSTimestamp</code></p></td>
<td style="text-align: left;"><p><code>long</code></p></td>
<td style="text-align: left;"><p>The JMS timestamp.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>JMSType</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The JMS type.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>JMSXGroupID</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The JMS group ID.</p></td>
</tr>
</tbody>
</table>

As all the above information is standard JMS, you can check the [JMS
documentation](http://java.sun.com/javaee/5/docs/api/javax/jms/Message.html)
for further details.

## About using Camel to send and receive messages and JMSReplyTo

The JMS component is complex, and you have to pay close attention to how
it works in some cases. So this is a short summary of some
areas/pitfalls to look for.

When Camel sends a message using its `JMSProducer`, it checks the
following conditions:

-   The message exchange pattern.

-   Whether a `JMSReplyTo` was set in the endpoint or in the message
    headers.

-   Whether any of the following options have been set on the JMS
    endpoint: `disableReplyTo`, `preserveMessageQos`,
    `explicitQosEnabled`.

All this can be a tad complex to understand and configure to support
your use case.

### JmsProducer

The `JmsProducer` behaves as follows, depending on configuration:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Exchange Pattern</th>
<th style="text-align: left;">Other options</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><em>InOut</em></p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Camel will expect a reply, set a
temporary <code>JMSReplyTo</code>, and after sending the message, it
will start to listen for the reply message on the temporary
queue.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><em>InOut</em></p></td>
<td style="text-align: left;"><p><code>JMSReplyTo</code> is set</p></td>
<td style="text-align: left;"><p>Camel will expect a reply and, after
sending the message, it will start to listen for the reply message on
the specified <code>JMSReplyTo</code> queue.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><em>InOnly</em></p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Camel will send the message and
<strong>not</strong> expect a reply.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><em>InOnly</em></p></td>
<td style="text-align: left;"><p><code>JMSReplyTo</code> is set</p></td>
<td style="text-align: left;"><p>By default, Camel discards the
<code>JMSReplyTo</code> destination and clears the
<code>JMSReplyTo</code> header before sending the message. Camel then
sends the message and does <strong>not</strong> expect a reply. Camel
logs this in the log at <code>WARN</code> level (changed to
<code>DEBUG</code> level from <strong>Camel 2.6</strong> onwards. You
can use <code>preserveMessageQuo=true</code> to instruct Camel to keep
the <code>JMSReplyTo</code>. In all situations the
<code>JmsProducer</code> does <strong>not</strong> expect any reply and
thus continue after sending the message.</p></td>
</tr>
</tbody>
</table>

### JmsConsumer

The `JmsConsumer` behaves as follows, depending on configuration:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Exchange Pattern</th>
<th style="text-align: left;">Other options</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><em>InOut</em></p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Camel will send the reply back to the
<code>JMSReplyTo</code> queue.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><em>InOnly</em></p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Camel will not send a reply back, as
the pattern is <em>InOnly</em>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>-</p></td>
<td
style="text-align: left;"><p><code>disableReplyTo=true</code></p></td>
<td style="text-align: left;"><p>This option suppress replies.</p></td>
</tr>
</tbody>
</table>

So pay attention to the message exchange pattern set on your exchanges.

If you send a message to a JMS destination in the middle of your route,
you can specify the exchange pattern to use, see more at Request
Reply.  
This is useful if you want to send an `InOnly` message to a JMS topic:

    from("activemq:queue:in")
       .to("bean:validateOrder")
       .to(ExchangePattern.InOnly, "activemq:topic:order")
       .to("bean:handleOrder");

## Reuse endpoint and send to different destinations computed at runtime

If you need to send messages to a lot of different JMS destinations, it
makes sense to reuse a JMS endpoint and specify the real destination in
a message header. This allows Camel to reuse the same endpoint, but send
to different destinations. This greatly reduces the number of endpoints
created and economizes on memory and thread resources.

You can specify the destination in the following headers:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelJmsDestination</code></p></td>
<td
style="text-align: left;"><p><code>javax.jms.Destination</code></p></td>
<td style="text-align: left;"><p>A destination object.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelJmsDestinationName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The destination name.</p></td>
</tr>
</tbody>
</table>

For example, the following route shows how you can compute a destination
at run time and use it to override the destination appearing in the JMS
URL:

    from("file://inbox")
      .to("bean:computeDestination")
      .to("activemq:queue:dummy");

The queue name, `dummy`, is just a placeholder. It must be provided as
part of the JMS endpoint URL, but it will be ignored in this example.

In the `computeDestination` bean, specify the real destination by
setting the `CamelJmsDestinationName` header as follows:

    public void setJmsHeader(Exchange exchange) {
       String id = ....
       exchange.getIn().setHeader("CamelJmsDestinationName", "order:" + id");
    }

Then Camel will read this header and use it as the destination instead
of the one configured on the endpoint. So, in this example Camel sends
the message to `activemq:queue:order:2`, assuming the `id` value was 2.

If both the `CamelJmsDestination` and the `CamelJmsDestinationName`
headers are set, `CamelJmsDestination` takes priority. Keep in mind that
the JMS producer removes both `CamelJmsDestination` and
`CamelJmsDestinationName` headers from the exchange and do not propagate
them to the created JMS message to avoid the accidental loops in the
routes (in scenarios when the message will be forwarded to another JMS
endpoint).

## Configuring different JMS providers

You can configure your JMS provider in Spring XML as follows:

You can configure as many JMS component instances as you wish and give
them **a unique name using the** `id` **attribute**. The preceding
example configures an `activemq` component. You could do the same to
configure MQSeries, TibCo, BEA, Sonic and so on.

Once you have a named JMS component, you can then refer to endpoints
within that component using URIs. For example, for the component name,
`activemq`, you can then refer to destinations using the URI format,
`activemq:[queue:|topic:]destinationName`. You can use the same approach
for all other JMS providers.

This works by the SpringCamelContext lazily fetching components from the
spring context for the scheme name you use for Endpoint URIs and having
the Component resolve the endpoint URIs.

### Using JNDI to find the ConnectionFactory

If you are using a J2EE container, you might need to look up JNDI to
find the JMS `ConnectionFactory` rather than use the usual `<bean>`
mechanism in Spring. You can do this using Spring’s factory bean or the
new Spring XML namespace. For example:

    <bean id="weblogic" class="org.apache.camel.component.jms.JmsComponent">
      <property name="connectionFactory" ref="myConnectionFactory"/>
    </bean>
    
    <jee:jndi-lookup id="myConnectionFactory" jndi-name="jms/connectionFactory"/>

See [The jee
schema](http://static.springsource.org/spring/docs/3.0.x/spring-framework-reference/html/xsd-config.html#xsd-config-body-schemas-jee)
in the Spring reference documentation for more details about JNDI
lookup.

## Concurrent Consuming

A common requirement with JMS is to consume messages concurrently in
multiple threads to make an application more responsive. You can set the
`concurrentConsumers` option to specify the number of threads servicing
the JMS endpoint, as follows:

    from("jms:SomeQueue?concurrentConsumers=20").
      bean(MyClass.class);

You can configure this option in one of the following ways:

-   On the `JmsComponent`,

-   On the endpoint URI or,

-   By invoking `setConcurrentConsumers()` directly on the
    `JmsEndpoint`.

### Concurrent Consuming with async consumer

Notice that each concurrent consumer will only pick up the next
available message from the JMS broker, when the current message has been
fully processed. You can set the option `asyncConsumer=true` to let the
consumer pick up the next message from the JMS queue, while the previous
message is being processed asynchronously (by the Asynchronous Routing
Engine). See more details in the table on top of the page about the
`asyncConsumer` option.

    from("jms:SomeQueue?concurrentConsumers=20&asyncConsumer=true").
      bean(MyClass.class);

## Request-reply over JMS

Camel supports Request Reply over JMS. In essence the MEP of the
Exchange should be `InOut` when you send a message to a JMS queue.

Camel offers a number of options to configure request/reply over JMS
that influence performance and clustered environments. The table below
summaries the options.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Performance</th>
<th style="text-align: left;">Cluster</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>Temporary</code></p></td>
<td style="text-align: left;"><p>Fast</p></td>
<td style="text-align: left;"><p>Yes</p></td>
<td style="text-align: left;"><p>A temporary queue is used as reply
queue, and automatic created by Camel. To use this, do
<strong>not</strong> specify a <code>replyTo</code> queue name. And you
can optionally configure <code>replyToType=Temporary</code> to make it
stand out that temporary queues are in use.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>Shared</code></p></td>
<td style="text-align: left;"><p>Slow</p></td>
<td style="text-align: left;"><p>Yes</p></td>
<td style="text-align: left;"><p>A shared persistent queue is used as
reply queue. The queue must be created beforehand, although some brokers
can create them on the fly, such as Apache ActiveMQ. To use this, you
must specify the replyTo queue name. And you can optionally configure
<code>replyToType=Shared</code> to make it stand out that shared queues
are in use. A shared queue can be used in a clustered environment with
multiple nodes running this Camel application at the same time. All of
them using the same shared reply queue. This is possible because JMS
Message selectors are used to correlate expected reply messages; this
impacts performance though. JMS Message selectors are slower, and
therefore not as fast as <code>Temporary</code> or
<code>Exclusive</code> queues. See further below how to tweak this for
better performance.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>Exclusive</code></p></td>
<td style="text-align: left;"><p>Fast</p></td>
<td style="text-align: left;"><p>No (*Yes)</p></td>
<td style="text-align: left;"><p>An exclusive persistent queue is used
as reply queue. The queue must be created beforehand, although some
brokers can create them on the fly, such as Apache ActiveMQ. To use
this, you must specify the replyTo queue name. And you
<strong>must</strong> configure <code>replyToType=Exclusive</code> to
instruct Camel to use exclusive queues, as <code>Shared</code> is used
by default, if a <code>replyTo</code> queue name was configured. When
using exclusive reply queues, then JMS Message selectors are
<strong>not</strong> in use, and therefore other applications must not
use this queue as well. An exclusive queue <strong>cannot</strong> be
used in a clustered environment with multiple nodes running this Camel
application at the same time; as we do not have control if the reply
queue comes back to the same node that sent the request message; that is
why shared queues use JMS Message selectors to make sure of this.
<strong>Though</strong> if you configure each Exclusive reply queue with
a unique name per node, then you can run this in a clustered
environment. As then the reply message will be sent back to that queue
for the given node that awaits the reply message.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>concurrentConsumers</code></p></td>
<td style="text-align: left;"><p>Fast</p></td>
<td style="text-align: left;"><p>Yes</p></td>
<td style="text-align: left;"><p>Allows processing reply messages
concurrently using concurrent message listeners in use. You can specify
a range using the <code>concurrentConsumers</code> and
<code>maxConcurrentConsumers</code> options. <strong>Notice:</strong>
That using <code>Shared</code> reply queues may not work as well with
concurrent listeners, so use this option with care.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>maxConcurrentConsumers</code></p></td>
<td style="text-align: left;"><p>Fast</p></td>
<td style="text-align: left;"><p>Yes</p></td>
<td style="text-align: left;"><p>Allows processing reply messages
concurrently using concurrent message listeners in use. You can specify
a range using the <code>concurrentConsumers</code> and
<code>maxConcurrentConsumers</code> options. <strong>Notice:</strong>
That using <code>Shared</code> reply queues may not work as well with
concurrent listeners, so use this option with care.</p></td>
</tr>
</tbody>
</table>

The `JmsProducer` detects the `InOut` and provides a `JMSReplyTo` header
with the reply destination to be used. By default, Camel uses a
temporary queue, but you can use the `replyTo` option on the endpoint to
specify a fixed reply queue (see more below about fixed reply queue).

Camel will automatically set up a consumer that listens to on the reply
queue, so you should **not** do anything.  
This consumer is a Spring `DefaultMessageListenerContainer` which listen
for replies. However, it’s fixed to one concurrent consumer.  
That means replies will be processed in sequence as there is only one
thread to process the replies. You can configure the listener to use
concurrent threads using the `concurrentConsumers` and
`maxConcurrentConsumers` options. This allows you to easier configure
this in Camel as shown below:

    from(xxx)
    .inOut().to("activemq:queue:foo?concurrentConsumers=5")
    .to(yyy)
    .to(zzz);

In this route, we instruct Camel to route replies asynchronously using a
thread pool with five threads.

### Request-reply over JMS and using a shared fixed reply queue

If you use a fixed reply queue when doing Request Reply over JMS as
shown in the example below, then pay attention.

    from(xxx)
    .inOut().to("activemq:queue:foo?replyTo=bar")
    .to(yyy)

In this example, the fixed reply queue named "bar" is used. By default,
Camel assumes the queue is shared when using fixed reply queues, and
therefore it uses a `JMSSelector` to only pick up the expected reply
messages (e.g., based on the `JMSCorrelationID`). See the next section
for exclusive fixed reply queues. That means it’s not as fast as
temporary queues. You can speed up how often Camel will pull for reply
messages using the `receiveTimeout` option. By default, its 1000
milliseconds. So to make it faster, you can set it to 250 millis to pull
4 times per second as shown:

    from(xxx)
    .inOut().to("activemq:queue:foo?replyTo=bar&receiveTimeout=250")
    .to(yyy)

Notice this will cause the Camel to send pull requests to the message
broker more frequently, and thus require more network traffic.  
It is generally recommended to use temporary queues if possible.

### Request-reply over JMS and using an exclusive fixed reply queue

In the previous example, Camel would anticipate the fixed reply queue
named "bar" was shared, and thus it uses a `JMSSelector` to only consume
reply messages which it expects. However, there is a drawback to doing
this as the JMS selector is slower. Also, the consumer on the reply
queue is slower to update with new JMS selector ids. In fact, it only
updates when the `receiveTimeout` option times out, which by default is
1 second. So in theory, the reply messages could take up till about 1
sec to be detected. On the other hand, if the fixed reply queue is
exclusive to the Camel reply consumer, then we can avoid using the JMS
selectors, and thus be more performant. In fact, as fast as using
temporary queues. There is the `ReplyToType` option which you can
configure to `Exclusive`  
to tell Camel that the reply queue is exclusive as shown in the example
below:

    from(xxx)
    .inOut().to("activemq:queue:foo?replyTo=bar&replyToType=Exclusive")
    .to(yyy)

Mind that the queue must be exclusive to each and every endpoint. So if
you have two routes, then they each need a unique reply queue as shown
in the next example:

    from(xxx)
    .inOut().to("activemq:queue:foo?replyTo=bar&replyToType=Exclusive")
    .to(yyy)
    
    from(aaa)
    .inOut().to("activemq:queue:order?replyTo=order.reply&replyToType=Exclusive")
    .to(bbb)

The same applies if you run in a clustered environment. Then each node
in the cluster must use a unique reply queue name. As otherwise, each
node in the cluster may pick up messages intended as a reply on another
node. For clustered environments, it’s recommended to use shared reply
queues instead.

## Synchronizing clocks between senders and receivers

When doing messaging between systems, it is desirable that the systems
have synchronized clocks. For example, when sending a
[JMS](#jms-component.adoc) message, then you can set a time to live
value on the message. Then the receiver can inspect this value and
determine if the message is already expired, and thus drop the message
instead of consume and process it. However, this requires that both
sender and receiver have synchronized clocks.

If you are using [ActiveMQ](http://activemq.apache.org/), then you can
use the [timestamp
plugin](http://activemq.apache.org/timestampplugin.html) to synchronize
clocks.

## About time to live

Read first above about synchronized clocks.

When you do request/reply (InOut) over [JMS](#jms-component.adoc) with
Camel, then Camel uses a timeout on the sender side, which is default 20
seconds from the `requestTimeout` option. You can control this by
setting a higher/lower value. However, the time to live value is still
set on the [JMS](#jms-component.adoc) message being sent. So that
requires the clocks to be synchronized between the systems. If they are
not, then you may want to disable the time to live value being set. This
is now possible using the `disableTimeToLive` option from **Camel 2.8**
onwards. So if you set this option to `disableTimeToLive=true`, then
Camel does **not** set any time to live value when sending
[JMS](#jms-component.adoc) messages. **But** the request timeout is
still active. So for example, if you do request/reply over
[JMS](#jms-component.adoc) and have disabled time to live, then Camel
will still use a timeout by 20 seconds (the `requestTimeout` option).
That option can also be configured. So the two options `requestTimeout`
and `disableTimeToLive` gives you Fine-grained control when doing
request/reply.

You can provide a header in the message to override and use as the
request timeout value instead of the endpoint configured value. For
example:

       from("direct:someWhere")
         .to("jms:queue:foo?replyTo=bar&requestTimeout=30s")
         .to("bean:processReply");

In the route above we have an endpoint configured `requestTimeout` of 30
seconds. So Camel will wait up till 30 seconds for that reply message to
come back on the bar queue. If no reply message is received then a
`org.apache.camel.ExchangeTimedOutException` is set on the Exchange, and
Camel continues routing the message, which would then fail due the
exception, and Camel’s error handler reacts.

If you want to use a per message timeout value, you can set the header
with key
`org.apache.camel.component.jms.JmsConstants#JMS_REQUEST_TIMEOUT` which
has constant value `"CamelJmsRequestTimeout"` with a timeout value as a
long type.

For example, we can use a bean to compute the timeout value per
individual message, such as calling the `"whatIsTheTimeout"` method on
the service bean as shown below:

    from("direct:someWhere")
      .setHeader("CamelJmsRequestTimeout", method(ServiceBean.class, "whatIsTheTimeout"))
      .to("jms:queue:foo?replyTo=bar&requestTimeout=30s")
      .to("bean:processReply");

When you do fire and forget (InOut) over [JMS](#jms-component.adoc) with
Camel, then Camel by default does **not** set any time to live value on
the message. You can configure a value by using the `timeToLive` option.
For example, to indicate a 5 sec., you set `timeToLive=5000`. The option
`disableTimeToLive` can be used to force disabling the time to live,
also for InOnly messaging. The `requestTimeout` option is not being used
for InOnly messaging.

## Enabling Transacted Consumption

A common requirement is to consume from a queue in a transaction and
then process the message using the Camel route. To do this, just ensure
that you set the following properties on the component/endpoint:

-   `transacted` = true

-   `transactionManager` = a *Transsaction Manager* - typically the
    `JmsTransactionManager`

See the Transactional Client EIP pattern for further details.

Transactions and \[Request Reply\] over JMS

When using Request Reply over JMS, you cannot use a single transaction;
JMS will not send any messages until a commit is performed, so the
server side won’t receive anything at all until the transaction commits.
Therefore, to use [Request Reply](#eips:requestReply-eip.adoc), you must
commit a transaction after sending the request and then use a separate
transaction for receiving the response.

To address this issue, the JMS component uses different properties to
specify transaction use for oneway messaging and request reply
messaging:

The `transacted` property applies **only** to the InOnly message
Exchange Pattern (MEP).

You can leverage the [DMLC transacted session
API](<http://static.springsource.org/spring/docs/3.0.x/javadoc-api/org/springframework/jms/listener/AbstractPollingMessageListenerContainer.html#setSessionTransacted(boolean)>)
using the following properties on component/endpoint:

-   `transacted` = true

-   `lazyCreateTransactionManager` = false

The benefit of doing so is that the cacheLevel setting will be honored
when using local transactions without a configured TransactionManager.
When a TransactionManager is configured, no caching happens at DMLC
level, and it is necessary to rely on a pooled connection factory. For
more details about this kind of setup, see
[here](http://tmielke.blogspot.com/2012/03/camel-jms-with-transactions-lessons.html)
and
[here](http://forum.springsource.org/showthread.php?123631-JMS-DMLC-not-caching%20connection-when-using-TX-despite-cacheLevel-CACHE_CONSUMER&p=403530&posted=1#post403530).

## Using JMSReplyTo for late replies

When using Camel as a JMS listener, it sets an Exchange property with
the value of the ReplyTo `javax.jms.Destination` object, having the key
`ReplyTo`. You can obtain this `Destination` as follows:

    Destination replyDestination = exchange.getIn().getHeader(JmsConstants.JMS_REPLY_DESTINATION, Destination.class);

And then later use it to send a reply using regular JMS or Camel.

    // we need to pass in the JMS component, and in this sample we use ActiveMQ
    JmsEndpoint endpoint = JmsEndpoint.newInstance(replyDestination, activeMQComponent);
    // now we have the endpoint we can use regular Camel API to send a message to it
    template.sendBody(endpoint, "Here is the late reply.");

A different solution to sending a reply is to provide the
`replyDestination` object in the same Exchange property when sending.
Camel will then pick up this property and use it for the real
destination. The endpoint URI must include a dummy destination, however.
For example:

    // we pretend to send it to some non-existing dummy queue
    template.send("activemq:queue:dummy, new Processor() {
       public void process(Exchange exchange) throws Exception {
          // and here we override the destination with the ReplyTo destination object so the message is sent to there instead of dummy
          exchange.getIn().setHeader(JmsConstants.JMS_DESTINATION, replyDestination);
          exchange.getIn().setBody("Here is the late reply.");
        }
    }

## Using a request timeout

In the sample below we send a Request Reply style message Exchange (we
use the `requestBody` method = `InOut`) to the slow queue for further
processing in Camel, and we wait for a return reply:

## Sending an InOnly message and keeping the JMSReplyTo header

When sending to a [JMS](#jms-component.adoc) destination using
**camel-jms**, the producer will use the MEP to detect if it is `InOnly`
or `InOut` messaging. However, there can be times when you want to send
an `InOnly` message but keeping the `JMSReplyTo` header. To do so, you
have to instruct Camel to keep it, otherwise the `JMSReplyTo` header
will be dropped.

For example, to send an `InOnly` message to the foo queue, but with a
`JMSReplyTo` with bar queue you can do as follows:

    template.send("activemq:queue:foo?preserveMessageQos=true", new Processor() {
       public void process(Exchange exchange) throws Exception {
          exchange.getIn().setBody("World");
          exchange.getIn().setHeader("JMSReplyTo", "bar");
        }
    });

Notice we use `preserveMessageQos=true` to instruct Camel to keep the
`JMSReplyTo` header.

## Setting JMS provider options on the destination

Some JMS providers, like IBM’s WebSphere MQ, need options to be set on
the JMS destination. For example, you may need to specify the
`targetClient` option. Since `targetClient` is a WebSphere MQ option and
not a Camel URI option, you need to set that on the JMS destination name
like so:

    // ...
    .setHeader("CamelJmsDestinationName", constant("queue:///MY_QUEUE?targetClient=1"))
    .to("wmq:queue:MY_QUEUE?useMessageIDAsCorrelationID=true");

Some versions of WMQ won’t accept this option on the destination name,
and you will get an exception like:

    com.ibm.msg.client.jms.DetailedJMSException: JMSCC0005: The specified
    value 'MY_QUEUE?targetClient=1' is not allowed for
    'XMSC_DESTINATION_NAME'

A workaround is to use a custom DestinationResolver:

    JmsComponent wmq = new JmsComponent(connectionFactory);
    
    wmq.setDestinationResolver(new DestinationResolver() {
        public Destination resolveDestinationName(Session session, String destinationName, boolean pubSubDomain) throws JMSException {
            MQQueueSession wmqSession = (MQQueueSession) session;
            return wmqSession.createQueue("queue:///" + destinationName + "?targetClient=1");
        }
    });

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clientId|Sets the JMS client ID to use. Note that this value, if specified, must be unique and can only be used by a single JMS connection instance. It is typically only required for durable topic subscriptions with JMS 1.1.||string|
|connectionFactory|The connection factory to be use. A connection factory must be configured either on the component or endpoint.||object|
|disableReplyTo|Specifies whether Camel ignores the JMSReplyTo header in messages. If true, Camel does not send a reply back to the destination specified in the JMSReplyTo header. You can use this option if you want Camel to consume from a route and you do not want Camel to automatically send back a reply message because another component in your code handles the reply message. You can also use this option if you want to use Camel as a proxy between different message brokers and you want to route message from one system to another.|false|boolean|
|durableSubscriptionName|The durable subscriber name for specifying durable topic subscriptions. The clientId option must be configured as well.||string|
|jmsMessageType|Allows you to force the use of a specific jakarta.jms.Message implementation for sending JMS messages. Possible values are: Bytes, Map, Object, Stream, Text. By default, Camel would determine which JMS message type to use from the In body type. This option allows you to specify it.||object|
|replyTo|Provides an explicit ReplyTo destination (overrides any incoming value of Message.getJMSReplyTo() in consumer).||string|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This ensures that when Camel starts that all the JMS consumers have a valid connection to the JMS broker. If a connection cannot be granted then Camel throws an exception on startup. This ensures that Camel is not started with failed connections. The JMS producers is tested as well.|false|boolean|
|acknowledgementModeName|The JMS acknowledgement name, which is one of: SESSION\_TRANSACTED, CLIENT\_ACKNOWLEDGE, AUTO\_ACKNOWLEDGE, DUPS\_OK\_ACKNOWLEDGE|AUTO\_ACKNOWLEDGE|string|
|artemisConsumerPriority|Consumer priorities allow you to ensure that high priority consumers receive messages while they are active. Normally, active consumers connected to a queue receive messages from it in a round-robin fashion. When consumer priorities are in use, messages are delivered round-robin if multiple active consumers exist with the same high priority. Messages will only going to lower priority consumers when the high priority consumers do not have credit available to consume the message, or those high priority consumers have declined to accept the message (for instance because it does not meet the criteria of any selectors associated with the consumer).||integer|
|asyncConsumer|Whether the JmsConsumer processes the Exchange asynchronously. If enabled then the JmsConsumer may pickup the next message from the JMS queue, while the previous message is being processed asynchronously (by the Asynchronous Routing Engine). This means that messages may be processed not 100% strictly in order. If disabled (as default) then the Exchange is fully processed before the JmsConsumer will pickup the next message from the JMS queue. Note if transacted has been enabled, then asyncConsumer=true does not run asynchronously, as transaction must be executed synchronously (Camel 3.0 may support async transactions).|false|boolean|
|autoStartup|Specifies whether the consumer container should auto-startup.|true|boolean|
|cacheLevel|Sets the cache level by ID for the underlying JMS resources. See cacheLevelName option for more details.||integer|
|cacheLevelName|Sets the cache level by name for the underlying JMS resources. Possible values are: CACHE\_AUTO, CACHE\_CONNECTION, CACHE\_CONSUMER, CACHE\_NONE, and CACHE\_SESSION. The default setting is CACHE\_AUTO. See the Spring documentation and Transactions Cache Levels for more information.|CACHE\_AUTO|string|
|concurrentConsumers|Specifies the default number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.|1|integer|
|maxConcurrentConsumers|Specifies the maximum number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToMaxConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.||integer|
|replyToDeliveryPersistent|Specifies whether to use persistent delivery by default for replies.|true|boolean|
|selector|Sets the JMS selector to use||string|
|subscriptionDurable|Set whether to make the subscription durable. The durable subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a durable subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well.|false|boolean|
|subscriptionName|Set the name of a subscription to create. To be applied in case of a topic (pub-sub domain) with a shared or durable subscription. The subscription name needs to be unique within this client's JMS client id. Default is the class name of the specified message listener. Note: Only 1 concurrent consumer (which is the default of this message listener container) is allowed for each subscription, except for a shared subscription (which requires JMS 2.0).||string|
|subscriptionShared|Set whether to make the subscription shared. The shared subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a shared subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Note that shared subscriptions may also be durable, so this flag can (and often will) be combined with subscriptionDurable as well. Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well. Requires a JMS 2.0 compatible message broker.|false|boolean|
|acceptMessagesWhileStopping|Specifies whether the consumer accept messages while it is stopping. You may consider enabling this option, if you start and stop JMS routes at runtime, while there are still messages enqueued on the queue. If this option is false, and you stop the JMS route, then messages may be rejected, and the JMS broker would have to attempt redeliveries, which yet again may be rejected, and eventually the message may be moved at a dead letter queue on the JMS broker. To avoid this its recommended to enable this option.|false|boolean|
|allowReplyManagerQuickStop|Whether the DefaultMessageListenerContainer used in the reply managers for request-reply messaging allow the DefaultMessageListenerContainer.runningAllowed flag to quick stop in case JmsConfiguration#isAcceptMessagesWhileStopping is enabled, and org.apache.camel.CamelContext is currently being stopped. This quick stop ability is enabled by default in the regular JMS consumers but to enable for reply managers you must enable this flag.|false|boolean|
|consumerType|The consumer type to use, which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|defaultTaskExecutorType|Specifies what default TaskExecutor type to use in the DefaultMessageListenerContainer, for both consumer endpoints and the ReplyTo consumer of producer endpoints. Possible values: SimpleAsync (uses Spring's SimpleAsyncTaskExecutor) or ThreadPool (uses Spring's ThreadPoolTaskExecutor with optimal values - cached thread-pool-like). If not set, it defaults to the previous behaviour, which uses a cached thread pool for consumer endpoints and SimpleAsync for reply consumers. The use of ThreadPool is recommended to reduce thread trash in elastic configurations with dynamically increasing and decreasing concurrent consumers.||object|
|eagerLoadingOfProperties|Enables eager loading of JMS properties and payload as soon as a message is loaded which generally is inefficient as the JMS properties may not be required but sometimes can catch early any issues with the underlying JMS provider and the use of JMS properties. See also the option eagerPoisonBody.|false|boolean|
|eagerPoisonBody|If eagerLoadingOfProperties is enabled and the JMS message payload (JMS body or JMS properties) is poison (cannot be read/mapped), then set this text as the message body instead so the message can be processed (the cause of the poison are already stored as exception on the Exchange). This can be turned off by setting eagerPoisonBody=false. See also the option eagerLoadingOfProperties.|Poison JMS message due to ${exception.message}|string|
|exposeListenerSession|Specifies whether the listener session should be exposed when consuming messages.|false|boolean|
|replyToConsumerType|The consumer type of the reply consumer (when doing request/reply), which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|replyToSameDestinationAllowed|Whether a JMS consumer is allowed to send a reply message to the same destination that the consumer is using to consume from. This prevents an endless loop by consuming and sending back the same message to itself.|false|boolean|
|taskExecutor|Allows you to specify a custom task executor for consuming messages.||object|
|deliveryDelay|Sets delivery delay to use for send calls for JMS. This option requires JMS 2.0 compliant broker.|-1|integer|
|deliveryMode|Specifies the delivery mode to be used. Possible values are those defined by jakarta.jms.DeliveryMode. NON\_PERSISTENT = 1 and PERSISTENT = 2.||integer|
|deliveryPersistent|Specifies whether persistent delivery is used by default.|true|boolean|
|explicitQosEnabled|Set if the deliveryMode, priority or timeToLive qualities of service should be used when sending messages. This option is based on Spring's JmsTemplate. The deliveryMode, priority and timeToLive options are applied to the current endpoint. This contrasts with the preserveMessageQos option, which operates at message granularity, reading QoS properties exclusively from the Camel In message headers.|false|boolean|
|formatDateHeadersToIso8601|Sets whether JMS date properties should be formatted according to the ISO 8601 standard.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|preserveMessageQos|Set to true, if you want to send message using the QoS settings specified on the message, instead of the QoS settings on the JMS endpoint. The following three headers are considered JMSPriority, JMSDeliveryMode, and JMSExpiration. You can provide all or only some of them. If not provided, Camel will fall back to use the values from the endpoint instead. So, when using this option, the headers override the values from the endpoint. The explicitQosEnabled option, by contrast, will only use options set on the endpoint, and not values from the message header.|false|boolean|
|priority|Values greater than 1 specify the message priority when sending (where 1 is the lowest priority and 9 is the highest). The explicitQosEnabled option must also be enabled in order for this option to have any effect.|4|integer|
|replyToConcurrentConsumers|Specifies the default number of concurrent consumers when doing request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.|1|integer|
|replyToMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers when using request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.||integer|
|replyToOnTimeoutMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers for continue routing when timeout occurred when using request/reply over JMS.|1|integer|
|replyToOverride|Provides an explicit ReplyTo destination in the JMS message, which overrides the setting of replyTo. It is useful if you want to forward the message to a remote Queue and receive the reply message from the ReplyTo destination.||string|
|replyToType|Allows for explicitly specifying which kind of strategy to use for replyTo queues when doing request/reply over JMS. Possible values are: Temporary, Shared, or Exclusive. By default Camel will use temporary queues. However if replyTo has been configured, then Shared is used by default. This option allows you to use exclusive queues instead of shared ones. See Camel JMS documentation for more details, and especially the notes about the implications if running in a clustered environment, and the fact that Shared reply queues has lower performance than its alternatives Temporary and Exclusive.||object|
|requestTimeout|The timeout for waiting for a reply when using the InOut Exchange Pattern (in milliseconds). The default is 20 seconds. You can include the header CamelJmsRequestTimeout to override this endpoint configured timeout value, and thus have per message individual timeout values. See also the requestTimeoutCheckerInterval option.|20000|duration|
|timeToLive|When sending messages, specifies the time-to-live of the message (in milliseconds).|-1|integer|
|allowAdditionalHeaders|This option is used to allow additional headers which may have values that are invalid according to JMS specification. For example, some message systems, such as WMQ, do this with header names using prefix JMS\_IBM\_MQMD\_ containing values with byte array or other invalid types. You can specify multiple header names separated by comma, and use as suffix for wildcard matching.||string|
|allowNullBody|Whether to allow sending messages with no body. If this option is false and the message body is null, then an JMSException is thrown.|true|boolean|
|alwaysCopyMessage|If true, Camel will always make a JMS message copy of the message when it is passed to the producer for sending. Copying the message is needed in some situations, such as when a replyToDestinationSelectorName is set (incidentally, Camel will set the alwaysCopyMessage option to true, if a replyToDestinationSelectorName is set)|false|boolean|
|correlationProperty|When using InOut exchange pattern use this JMS property instead of JMSCorrelationID JMS property to correlate messages. If set messages will be correlated solely on the value of this property JMSCorrelationID property will be ignored and not set by Camel.||string|
|disableTimeToLive|Use this option to force disabling time to live. For example when you do request/reply over JMS, then Camel will by default use the requestTimeout value as time to live on the message being sent. The problem is that the sender and receiver systems have to have their clocks synchronized, so they are in sync. This is not always so easy to archive. So you can use disableTimeToLive=true to not set a time to live value on the sent message. Then the message will not expire on the receiver system. See below in section About time to live for more details.|false|boolean|
|forceSendOriginalMessage|When using mapJmsMessage=false Camel will create a new JMS message to send to a new JMS destination if you touch the headers (get or set) during the route. Set this option to true to force Camel to send the original JMS message that was received.|false|boolean|
|includeSentJMSMessageID|Only applicable when sending to JMS destination using InOnly (eg fire and forget). Enabling this option will enrich the Camel Exchange with the actual JMSMessageID that was used by the JMS client when the message was sent to the JMS destination.|false|boolean|
|replyToCacheLevelName|Sets the cache level by name for the reply consumer when doing request/reply over JMS. This option only applies when using fixed reply queues (not temporary). Camel will by default use: CACHE\_CONSUMER for exclusive or shared w/ replyToSelectorName. And CACHE\_SESSION for shared without replyToSelectorName. Some JMS brokers such as IBM WebSphere may require to set the replyToCacheLevelName=CACHE\_NONE to work. Note: If using temporary queues then CACHE\_NONE is not allowed, and you must use a higher value such as CACHE\_CONSUMER or CACHE\_SESSION.||string|
|replyToDestinationSelectorName|Sets the JMS Selector using the fixed name to be used so you can filter out your own replies from the others when using a shared queue (that is, if you are not using a temporary reply queue).||string|
|streamMessageTypeEnabled|Sets whether StreamMessage type is enabled or not. Message payloads of streaming kind such as files, InputStream, etc will either by sent as BytesMessage or StreamMessage. This option controls which kind will be used. By default BytesMessage is used which enforces the entire message payload to be read into memory. By enabling this option the message payload is read into memory in chunks and each chunk is then written to the StreamMessage until no more data.|false|boolean|
|allowAutoWiredConnectionFactory|Whether to auto-discover ConnectionFactory from the registry, if no connection factory has been configured. If only one instance of ConnectionFactory is found then it will be used. This is enabled by default.|true|boolean|
|allowAutoWiredDestinationResolver|Whether to auto-discover DestinationResolver from the registry, if no destination resolver has been configured. If only one instance of DestinationResolver is found then it will be used. This is enabled by default.|true|boolean|
|allowSerializedHeaders|Controls whether or not to include serialized headers. Applies only when transferExchange is true. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level.|false|boolean|
|artemisStreamingEnabled|Whether optimizing for Apache Artemis streaming mode. This can reduce memory overhead when using Artemis with JMS StreamMessage types. This option must only be enabled if Apache Artemis is being used.|false|boolean|
|asyncStartListener|Whether to startup the JmsConsumer message listener asynchronously, when starting a route. For example if a JmsConsumer cannot get a connection to a remote JMS broker, then it may block while retrying and/or fail-over. This will cause Camel to block while starting routes. By setting this option to true, you will let routes startup, while the JmsConsumer connects to the JMS broker using a dedicated thread in asynchronous mode. If this option is used, then beware that if the connection could not be established, then an exception is logged at WARN level, and the consumer will not be able to receive messages; You can then restart the route to retry.|false|boolean|
|asyncStopListener|Whether to stop the JmsConsumer message listener asynchronously, when stopping a route.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a shared JMS configuration||object|
|destinationResolver|A pluggable org.springframework.jms.support.destination.DestinationResolver that allows you to use your own resolver (for example, to lookup the real destination in a JNDI registry).||object|
|errorHandler|Specifies a org.springframework.util.ErrorHandler to be invoked in case of any uncaught exceptions thrown while processing a Message. By default these exceptions will be logged at the WARN level, if no errorHandler has been configured. You can configure logging level and whether stack traces should be logged using errorHandlerLoggingLevel and errorHandlerLogStackTrace options. This makes it much easier to configure, than having to code a custom errorHandler.||object|
|exceptionListener|Specifies the JMS Exception Listener that is to be notified of any underlying JMS exceptions.||object|
|idleConsumerLimit|Specify the limit for the number of consumers that are allowed to be idle at any given time.|1|integer|
|idleTaskExecutionLimit|Specifies the limit for idle executions of a receive task, not having received any message within its execution. If this limit is reached, the task will shut down and leave receiving to other executing tasks (in the case of dynamic scheduling; see the maxConcurrentConsumers setting). There is additional doc available from Spring.|1|integer|
|includeAllJMSXProperties|Whether to include all JMSX prefixed properties when mapping from JMS to Camel Message. Setting this to true will include properties such as JMSXAppID, and JMSXUserID etc. Note: If you are using a custom headerFilterStrategy then this option does not apply.|false|boolean|
|includeCorrelationIDAsBytes|Whether the JMS consumer should include JMSCorrelationIDAsBytes as a header on the Camel Message.|true|boolean|
|jmsKeyFormatStrategy|Pluggable strategy for encoding and decoding JMS keys so they can be compliant with the JMS specification. Camel provides two implementations out of the box: default and passthrough. The default strategy will safely marshal dots and hyphens (. and -). The passthrough strategy leaves the key as is. Can be used for JMS brokers which do not care whether JMS header keys contain illegal characters. You can provide your own implementation of the org.apache.camel.component.jms.JmsKeyFormatStrategy and refer to it using the # notation.||object|
|mapJmsMessage|Specifies whether Camel should auto map the received JMS message to a suited payload type, such as jakarta.jms.TextMessage to a String etc.|true|boolean|
|maxMessagesPerTask|The number of messages per task. -1 is unlimited. If you use a range for concurrent consumers (eg min max), then this option can be used to set a value to eg 100 to control how fast the consumers will shrink when less work is required.|-1|integer|
|messageConverter|To use a custom Spring org.springframework.jms.support.converter.MessageConverter so you can be in control how to map to/from a jakarta.jms.Message.||object|
|messageCreatedStrategy|To use the given MessageCreatedStrategy which are invoked when Camel creates new instances of jakarta.jms.Message objects when Camel is sending a JMS message.||object|
|messageIdEnabled|When sending, specifies whether message IDs should be added. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the message ID set to null; if the provider ignores the hint, the message ID must be set to its normal unique value.|true|boolean|
|messageListenerContainerFactory|Registry ID of the MessageListenerContainerFactory used to determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use to consume messages. Setting this will automatically set consumerType to Custom.||object|
|messageTimestampEnabled|Specifies whether timestamps should be enabled by default on sending messages. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the timestamp set to zero; if the provider ignores the hint the timestamp must be set to its normal value.|true|boolean|
|pubSubNoLocal|Specifies whether to inhibit the delivery of messages published by its own connection.|false|boolean|
|queueBrowseStrategy|To use a custom QueueBrowseStrategy when browsing queues||object|
|receiveTimeout|The timeout for receiving messages (in milliseconds).|1000|duration|
|recoveryInterval|Specifies the interval between recovery attempts, i.e. when a connection is being refreshed, in milliseconds. The default is 5000 ms, that is, 5 seconds.|5000|duration|
|requestTimeoutCheckerInterval|Configures how often Camel should check for timed out Exchanges when doing request/reply over JMS. By default Camel checks once per second. But if you must react faster when a timeout occurs, then you can lower this interval, to check more frequently. The timeout is determined by the option requestTimeout.|1000|duration|
|serviceLocationEnabled|Whether to detect the network address location of the JMS broker on startup. This information is gathered via reflection on the ConnectionFactory, and is vendor specific. This option can be used to turn this off.|true|boolean|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|temporaryQueueResolver|A pluggable TemporaryQueueResolver that allows you to use your own resolver for creating temporary queues (some messaging systems has special requirements for creating temporary queues).||object|
|transferException|If enabled and you are using Request Reply messaging (InOut) and an Exchange failed on the consumer side, then the caused Exception will be send back in response as a jakarta.jms.ObjectMessage. If the client is Camel, the returned Exception is rethrown. This allows you to use Camel JMS as a bridge in your routing - for example, using persistent queues to enable robust routing. Notice that if you also have transferExchange enabled, this option takes precedence. The caught exception is required to be serializable. The original Exception on the consumer side can be wrapped in an outer exception such as org.apache.camel.RuntimeCamelException when returned to the producer. Use this with caution as the data is using Java Object serialization and requires the received to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumer!|false|boolean|
|transferExchange|You can transfer the exchange over the wire instead of just the body and headers. The following fields are transferred: In body, Out body, Fault body, In headers, Out headers, Fault headers, exchange properties, exchange exception. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level. You must enable this option on both the producer and consumer side, so Camel knows the payloads is an Exchange and not a regular payload. Use this with caution as the data is using Java Object serialization and requires the receiver to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumers having to use compatible Camel versions!|false|boolean|
|useMessageIDAsCorrelationID|Specifies whether JMSMessageID should always be used as JMSCorrelationID for InOut messages.|false|boolean|
|waitForProvisionCorrelationToBeUpdatedCounter|Number of times to wait for provisional correlation id to be updated to the actual correlation id when doing request/reply over JMS and when the option useMessageIDAsCorrelationID is enabled.|50|integer|
|waitForProvisionCorrelationToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for provisional correlation id to be updated.|100|duration|
|waitForTemporaryReplyToToBeUpdatedCounter|Number of times to wait for temporary replyTo queue to be created and ready when doing request/reply over JMS.|200|integer|
|waitForTemporaryReplyToToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for temporary replyTo queue to be ready.|100|duration|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|errorHandlerLoggingLevel|Allows to configure the default errorHandler logging level for logging uncaught exceptions.|WARN|object|
|errorHandlerLogStackTrace|Allows to control whether stack-traces should be logged or not, by the default errorHandler.|true|boolean|
|password|Password to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|username|Username to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|transacted|Specifies whether to use transacted mode|false|boolean|
|transactedInOut|Specifies whether InOut operations (request reply) default to using transacted mode If this flag is set to true, then Spring JmsTemplate will have sessionTransacted set to true, and the acknowledgeMode as transacted on the JmsTemplate used for InOut operations. Note from Spring JMS: that within a JTA transaction, the parameters passed to createQueue, createTopic methods are not taken into account. Depending on the Java EE transaction context, the container makes its own decisions on these values. Analogously, these parameters are not taken into account within a locally managed transaction either, since Spring JMS operates on an existing JMS Session in this case. Setting this flag to true will use a short local JMS transaction when running outside of a managed transaction, and a synchronized local JMS transaction in case of a managed transaction (other than an XA transaction) being present. This has the effect of a local JMS transaction being managed alongside the main transaction (which might be a native JDBC transaction), with the JMS transaction committing right after the main transaction.|false|boolean|
|lazyCreateTransactionManager|If true, Camel will create a JmsTransactionManager, if there is no transactionManager injected when option transacted=true.|true|boolean|
|transactionManager|The Spring transaction manager to use.||object|
|transactionName|The name of the transaction to use.||string|
|transactionTimeout|The timeout value of the transaction (in seconds), if using transacted mode.|-1|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|destinationType|The kind of destination to use|queue|string|
|destinationName|Name of the queue or topic to use as destination||string|
|clientId|Sets the JMS client ID to use. Note that this value, if specified, must be unique and can only be used by a single JMS connection instance. It is typically only required for durable topic subscriptions with JMS 1.1.||string|
|connectionFactory|The connection factory to be use. A connection factory must be configured either on the component or endpoint.||object|
|disableReplyTo|Specifies whether Camel ignores the JMSReplyTo header in messages. If true, Camel does not send a reply back to the destination specified in the JMSReplyTo header. You can use this option if you want Camel to consume from a route and you do not want Camel to automatically send back a reply message because another component in your code handles the reply message. You can also use this option if you want to use Camel as a proxy between different message brokers and you want to route message from one system to another.|false|boolean|
|durableSubscriptionName|The durable subscriber name for specifying durable topic subscriptions. The clientId option must be configured as well.||string|
|jmsMessageType|Allows you to force the use of a specific jakarta.jms.Message implementation for sending JMS messages. Possible values are: Bytes, Map, Object, Stream, Text. By default, Camel would determine which JMS message type to use from the In body type. This option allows you to specify it.||object|
|replyTo|Provides an explicit ReplyTo destination (overrides any incoming value of Message.getJMSReplyTo() in consumer).||string|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This ensures that when Camel starts that all the JMS consumers have a valid connection to the JMS broker. If a connection cannot be granted then Camel throws an exception on startup. This ensures that Camel is not started with failed connections. The JMS producers is tested as well.|false|boolean|
|acknowledgementModeName|The JMS acknowledgement name, which is one of: SESSION\_TRANSACTED, CLIENT\_ACKNOWLEDGE, AUTO\_ACKNOWLEDGE, DUPS\_OK\_ACKNOWLEDGE|AUTO\_ACKNOWLEDGE|string|
|artemisConsumerPriority|Consumer priorities allow you to ensure that high priority consumers receive messages while they are active. Normally, active consumers connected to a queue receive messages from it in a round-robin fashion. When consumer priorities are in use, messages are delivered round-robin if multiple active consumers exist with the same high priority. Messages will only going to lower priority consumers when the high priority consumers do not have credit available to consume the message, or those high priority consumers have declined to accept the message (for instance because it does not meet the criteria of any selectors associated with the consumer).||integer|
|asyncConsumer|Whether the JmsConsumer processes the Exchange asynchronously. If enabled then the JmsConsumer may pickup the next message from the JMS queue, while the previous message is being processed asynchronously (by the Asynchronous Routing Engine). This means that messages may be processed not 100% strictly in order. If disabled (as default) then the Exchange is fully processed before the JmsConsumer will pickup the next message from the JMS queue. Note if transacted has been enabled, then asyncConsumer=true does not run asynchronously, as transaction must be executed synchronously (Camel 3.0 may support async transactions).|false|boolean|
|autoStartup|Specifies whether the consumer container should auto-startup.|true|boolean|
|cacheLevel|Sets the cache level by ID for the underlying JMS resources. See cacheLevelName option for more details.||integer|
|cacheLevelName|Sets the cache level by name for the underlying JMS resources. Possible values are: CACHE\_AUTO, CACHE\_CONNECTION, CACHE\_CONSUMER, CACHE\_NONE, and CACHE\_SESSION. The default setting is CACHE\_AUTO. See the Spring documentation and Transactions Cache Levels for more information.|CACHE\_AUTO|string|
|concurrentConsumers|Specifies the default number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.|1|integer|
|maxConcurrentConsumers|Specifies the maximum number of concurrent consumers when consuming from JMS (not for request/reply over JMS). See also the maxMessagesPerTask option to control dynamic scaling up/down of threads. When doing request/reply over JMS then the option replyToMaxConcurrentConsumers is used to control number of concurrent consumers on the reply message listener.||integer|
|replyToDeliveryPersistent|Specifies whether to use persistent delivery by default for replies.|true|boolean|
|selector|Sets the JMS selector to use||string|
|subscriptionDurable|Set whether to make the subscription durable. The durable subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a durable subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well.|false|boolean|
|subscriptionName|Set the name of a subscription to create. To be applied in case of a topic (pub-sub domain) with a shared or durable subscription. The subscription name needs to be unique within this client's JMS client id. Default is the class name of the specified message listener. Note: Only 1 concurrent consumer (which is the default of this message listener container) is allowed for each subscription, except for a shared subscription (which requires JMS 2.0).||string|
|subscriptionShared|Set whether to make the subscription shared. The shared subscription name to be used can be specified through the subscriptionName property. Default is false. Set this to true to register a shared subscription, typically in combination with a subscriptionName value (unless your message listener class name is good enough as subscription name). Note that shared subscriptions may also be durable, so this flag can (and often will) be combined with subscriptionDurable as well. Only makes sense when listening to a topic (pub-sub domain), therefore this method switches the pubSubDomain flag as well. Requires a JMS 2.0 compatible message broker.|false|boolean|
|acceptMessagesWhileStopping|Specifies whether the consumer accept messages while it is stopping. You may consider enabling this option, if you start and stop JMS routes at runtime, while there are still messages enqueued on the queue. If this option is false, and you stop the JMS route, then messages may be rejected, and the JMS broker would have to attempt redeliveries, which yet again may be rejected, and eventually the message may be moved at a dead letter queue on the JMS broker. To avoid this its recommended to enable this option.|false|boolean|
|allowReplyManagerQuickStop|Whether the DefaultMessageListenerContainer used in the reply managers for request-reply messaging allow the DefaultMessageListenerContainer.runningAllowed flag to quick stop in case JmsConfiguration#isAcceptMessagesWhileStopping is enabled, and org.apache.camel.CamelContext is currently being stopped. This quick stop ability is enabled by default in the regular JMS consumers but to enable for reply managers you must enable this flag.|false|boolean|
|consumerType|The consumer type to use, which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|defaultTaskExecutorType|Specifies what default TaskExecutor type to use in the DefaultMessageListenerContainer, for both consumer endpoints and the ReplyTo consumer of producer endpoints. Possible values: SimpleAsync (uses Spring's SimpleAsyncTaskExecutor) or ThreadPool (uses Spring's ThreadPoolTaskExecutor with optimal values - cached thread-pool-like). If not set, it defaults to the previous behaviour, which uses a cached thread pool for consumer endpoints and SimpleAsync for reply consumers. The use of ThreadPool is recommended to reduce thread trash in elastic configurations with dynamically increasing and decreasing concurrent consumers.||object|
|eagerLoadingOfProperties|Enables eager loading of JMS properties and payload as soon as a message is loaded which generally is inefficient as the JMS properties may not be required but sometimes can catch early any issues with the underlying JMS provider and the use of JMS properties. See also the option eagerPoisonBody.|false|boolean|
|eagerPoisonBody|If eagerLoadingOfProperties is enabled and the JMS message payload (JMS body or JMS properties) is poison (cannot be read/mapped), then set this text as the message body instead so the message can be processed (the cause of the poison are already stored as exception on the Exchange). This can be turned off by setting eagerPoisonBody=false. See also the option eagerLoadingOfProperties.|Poison JMS message due to ${exception.message}|string|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|exposeListenerSession|Specifies whether the listener session should be exposed when consuming messages.|false|boolean|
|replyToConsumerType|The consumer type of the reply consumer (when doing request/reply), which can be one of: Simple, Default, or Custom. The consumer type determines which Spring JMS listener to use. Default will use org.springframework.jms.listener.DefaultMessageListenerContainer, Simple will use org.springframework.jms.listener.SimpleMessageListenerContainer. When Custom is specified, the MessageListenerContainerFactory defined by the messageListenerContainerFactory option will determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use.|Default|object|
|replyToSameDestinationAllowed|Whether a JMS consumer is allowed to send a reply message to the same destination that the consumer is using to consume from. This prevents an endless loop by consuming and sending back the same message to itself.|false|boolean|
|taskExecutor|Allows you to specify a custom task executor for consuming messages.||object|
|deliveryDelay|Sets delivery delay to use for send calls for JMS. This option requires JMS 2.0 compliant broker.|-1|integer|
|deliveryMode|Specifies the delivery mode to be used. Possible values are those defined by jakarta.jms.DeliveryMode. NON\_PERSISTENT = 1 and PERSISTENT = 2.||integer|
|deliveryPersistent|Specifies whether persistent delivery is used by default.|true|boolean|
|explicitQosEnabled|Set if the deliveryMode, priority or timeToLive qualities of service should be used when sending messages. This option is based on Spring's JmsTemplate. The deliveryMode, priority and timeToLive options are applied to the current endpoint. This contrasts with the preserveMessageQos option, which operates at message granularity, reading QoS properties exclusively from the Camel In message headers.|false|boolean|
|formatDateHeadersToIso8601|Sets whether JMS date properties should be formatted according to the ISO 8601 standard.|false|boolean|
|preserveMessageQos|Set to true, if you want to send message using the QoS settings specified on the message, instead of the QoS settings on the JMS endpoint. The following three headers are considered JMSPriority, JMSDeliveryMode, and JMSExpiration. You can provide all or only some of them. If not provided, Camel will fall back to use the values from the endpoint instead. So, when using this option, the headers override the values from the endpoint. The explicitQosEnabled option, by contrast, will only use options set on the endpoint, and not values from the message header.|false|boolean|
|priority|Values greater than 1 specify the message priority when sending (where 1 is the lowest priority and 9 is the highest). The explicitQosEnabled option must also be enabled in order for this option to have any effect.|4|integer|
|replyToConcurrentConsumers|Specifies the default number of concurrent consumers when doing request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.|1|integer|
|replyToMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers when using request/reply over JMS. See also the maxMessagesPerTask option to control dynamic scaling up/down of threads.||integer|
|replyToOnTimeoutMaxConcurrentConsumers|Specifies the maximum number of concurrent consumers for continue routing when timeout occurred when using request/reply over JMS.|1|integer|
|replyToOverride|Provides an explicit ReplyTo destination in the JMS message, which overrides the setting of replyTo. It is useful if you want to forward the message to a remote Queue and receive the reply message from the ReplyTo destination.||string|
|replyToType|Allows for explicitly specifying which kind of strategy to use for replyTo queues when doing request/reply over JMS. Possible values are: Temporary, Shared, or Exclusive. By default Camel will use temporary queues. However if replyTo has been configured, then Shared is used by default. This option allows you to use exclusive queues instead of shared ones. See Camel JMS documentation for more details, and especially the notes about the implications if running in a clustered environment, and the fact that Shared reply queues has lower performance than its alternatives Temporary and Exclusive.||object|
|requestTimeout|The timeout for waiting for a reply when using the InOut Exchange Pattern (in milliseconds). The default is 20 seconds. You can include the header CamelJmsRequestTimeout to override this endpoint configured timeout value, and thus have per message individual timeout values. See also the requestTimeoutCheckerInterval option.|20000|duration|
|timeToLive|When sending messages, specifies the time-to-live of the message (in milliseconds).|-1|integer|
|allowAdditionalHeaders|This option is used to allow additional headers which may have values that are invalid according to JMS specification. For example, some message systems, such as WMQ, do this with header names using prefix JMS\_IBM\_MQMD\_ containing values with byte array or other invalid types. You can specify multiple header names separated by comma, and use as suffix for wildcard matching.||string|
|allowNullBody|Whether to allow sending messages with no body. If this option is false and the message body is null, then an JMSException is thrown.|true|boolean|
|alwaysCopyMessage|If true, Camel will always make a JMS message copy of the message when it is passed to the producer for sending. Copying the message is needed in some situations, such as when a replyToDestinationSelectorName is set (incidentally, Camel will set the alwaysCopyMessage option to true, if a replyToDestinationSelectorName is set)|false|boolean|
|correlationProperty|When using InOut exchange pattern use this JMS property instead of JMSCorrelationID JMS property to correlate messages. If set messages will be correlated solely on the value of this property JMSCorrelationID property will be ignored and not set by Camel.||string|
|disableTimeToLive|Use this option to force disabling time to live. For example when you do request/reply over JMS, then Camel will by default use the requestTimeout value as time to live on the message being sent. The problem is that the sender and receiver systems have to have their clocks synchronized, so they are in sync. This is not always so easy to archive. So you can use disableTimeToLive=true to not set a time to live value on the sent message. Then the message will not expire on the receiver system. See below in section About time to live for more details.|false|boolean|
|forceSendOriginalMessage|When using mapJmsMessage=false Camel will create a new JMS message to send to a new JMS destination if you touch the headers (get or set) during the route. Set this option to true to force Camel to send the original JMS message that was received.|false|boolean|
|includeSentJMSMessageID|Only applicable when sending to JMS destination using InOnly (eg fire and forget). Enabling this option will enrich the Camel Exchange with the actual JMSMessageID that was used by the JMS client when the message was sent to the JMS destination.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|replyToCacheLevelName|Sets the cache level by name for the reply consumer when doing request/reply over JMS. This option only applies when using fixed reply queues (not temporary). Camel will by default use: CACHE\_CONSUMER for exclusive or shared w/ replyToSelectorName. And CACHE\_SESSION for shared without replyToSelectorName. Some JMS brokers such as IBM WebSphere may require to set the replyToCacheLevelName=CACHE\_NONE to work. Note: If using temporary queues then CACHE\_NONE is not allowed, and you must use a higher value such as CACHE\_CONSUMER or CACHE\_SESSION.||string|
|replyToDestinationSelectorName|Sets the JMS Selector using the fixed name to be used so you can filter out your own replies from the others when using a shared queue (that is, if you are not using a temporary reply queue).||string|
|streamMessageTypeEnabled|Sets whether StreamMessage type is enabled or not. Message payloads of streaming kind such as files, InputStream, etc will either by sent as BytesMessage or StreamMessage. This option controls which kind will be used. By default BytesMessage is used which enforces the entire message payload to be read into memory. By enabling this option the message payload is read into memory in chunks and each chunk is then written to the StreamMessage until no more data.|false|boolean|
|allowSerializedHeaders|Controls whether or not to include serialized headers. Applies only when transferExchange is true. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level.|false|boolean|
|artemisStreamingEnabled|Whether optimizing for Apache Artemis streaming mode. This can reduce memory overhead when using Artemis with JMS StreamMessage types. This option must only be enabled if Apache Artemis is being used.|false|boolean|
|asyncStartListener|Whether to startup the JmsConsumer message listener asynchronously, when starting a route. For example if a JmsConsumer cannot get a connection to a remote JMS broker, then it may block while retrying and/or fail-over. This will cause Camel to block while starting routes. By setting this option to true, you will let routes startup, while the JmsConsumer connects to the JMS broker using a dedicated thread in asynchronous mode. If this option is used, then beware that if the connection could not be established, then an exception is logged at WARN level, and the consumer will not be able to receive messages; You can then restart the route to retry.|false|boolean|
|asyncStopListener|Whether to stop the JmsConsumer message listener asynchronously, when stopping a route.|false|boolean|
|destinationResolver|A pluggable org.springframework.jms.support.destination.DestinationResolver that allows you to use your own resolver (for example, to lookup the real destination in a JNDI registry).||object|
|errorHandler|Specifies a org.springframework.util.ErrorHandler to be invoked in case of any uncaught exceptions thrown while processing a Message. By default these exceptions will be logged at the WARN level, if no errorHandler has been configured. You can configure logging level and whether stack traces should be logged using errorHandlerLoggingLevel and errorHandlerLogStackTrace options. This makes it much easier to configure, than having to code a custom errorHandler.||object|
|exceptionListener|Specifies the JMS Exception Listener that is to be notified of any underlying JMS exceptions.||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|idleConsumerLimit|Specify the limit for the number of consumers that are allowed to be idle at any given time.|1|integer|
|idleTaskExecutionLimit|Specifies the limit for idle executions of a receive task, not having received any message within its execution. If this limit is reached, the task will shut down and leave receiving to other executing tasks (in the case of dynamic scheduling; see the maxConcurrentConsumers setting). There is additional doc available from Spring.|1|integer|
|includeAllJMSXProperties|Whether to include all JMSX prefixed properties when mapping from JMS to Camel Message. Setting this to true will include properties such as JMSXAppID, and JMSXUserID etc. Note: If you are using a custom headerFilterStrategy then this option does not apply.|false|boolean|
|jmsKeyFormatStrategy|Pluggable strategy for encoding and decoding JMS keys so they can be compliant with the JMS specification. Camel provides two implementations out of the box: default and passthrough. The default strategy will safely marshal dots and hyphens (. and -). The passthrough strategy leaves the key as is. Can be used for JMS brokers which do not care whether JMS header keys contain illegal characters. You can provide your own implementation of the org.apache.camel.component.jms.JmsKeyFormatStrategy and refer to it using the # notation.||object|
|mapJmsMessage|Specifies whether Camel should auto map the received JMS message to a suited payload type, such as jakarta.jms.TextMessage to a String etc.|true|boolean|
|maxMessagesPerTask|The number of messages per task. -1 is unlimited. If you use a range for concurrent consumers (eg min max), then this option can be used to set a value to eg 100 to control how fast the consumers will shrink when less work is required.|-1|integer|
|messageConverter|To use a custom Spring org.springframework.jms.support.converter.MessageConverter so you can be in control how to map to/from a jakarta.jms.Message.||object|
|messageCreatedStrategy|To use the given MessageCreatedStrategy which are invoked when Camel creates new instances of jakarta.jms.Message objects when Camel is sending a JMS message.||object|
|messageIdEnabled|When sending, specifies whether message IDs should be added. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the message ID set to null; if the provider ignores the hint, the message ID must be set to its normal unique value.|true|boolean|
|messageListenerContainerFactory|Registry ID of the MessageListenerContainerFactory used to determine what org.springframework.jms.listener.AbstractMessageListenerContainer to use to consume messages. Setting this will automatically set consumerType to Custom.||object|
|messageTimestampEnabled|Specifies whether timestamps should be enabled by default on sending messages. This is just an hint to the JMS broker. If the JMS provider accepts this hint, these messages must have the timestamp set to zero; if the provider ignores the hint the timestamp must be set to its normal value.|true|boolean|
|pubSubNoLocal|Specifies whether to inhibit the delivery of messages published by its own connection.|false|boolean|
|receiveTimeout|The timeout for receiving messages (in milliseconds).|1000|duration|
|recoveryInterval|Specifies the interval between recovery attempts, i.e. when a connection is being refreshed, in milliseconds. The default is 5000 ms, that is, 5 seconds.|5000|duration|
|requestTimeoutCheckerInterval|Configures how often Camel should check for timed out Exchanges when doing request/reply over JMS. By default Camel checks once per second. But if you must react faster when a timeout occurs, then you can lower this interval, to check more frequently. The timeout is determined by the option requestTimeout.|1000|duration|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|temporaryQueueResolver|A pluggable TemporaryQueueResolver that allows you to use your own resolver for creating temporary queues (some messaging systems has special requirements for creating temporary queues).||object|
|transferException|If enabled and you are using Request Reply messaging (InOut) and an Exchange failed on the consumer side, then the caused Exception will be send back in response as a jakarta.jms.ObjectMessage. If the client is Camel, the returned Exception is rethrown. This allows you to use Camel JMS as a bridge in your routing - for example, using persistent queues to enable robust routing. Notice that if you also have transferExchange enabled, this option takes precedence. The caught exception is required to be serializable. The original Exception on the consumer side can be wrapped in an outer exception such as org.apache.camel.RuntimeCamelException when returned to the producer. Use this with caution as the data is using Java Object serialization and requires the received to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumer!|false|boolean|
|transferExchange|You can transfer the exchange over the wire instead of just the body and headers. The following fields are transferred: In body, Out body, Fault body, In headers, Out headers, Fault headers, exchange properties, exchange exception. This requires that the objects are serializable. Camel will exclude any non-serializable objects and log it at WARN level. You must enable this option on both the producer and consumer side, so Camel knows the payloads is an Exchange and not a regular payload. Use this with caution as the data is using Java Object serialization and requires the receiver to be able to deserialize the data at Class level, which forces a strong coupling between the producers and consumers having to use compatible Camel versions!|false|boolean|
|useMessageIDAsCorrelationID|Specifies whether JMSMessageID should always be used as JMSCorrelationID for InOut messages.|false|boolean|
|waitForProvisionCorrelationToBeUpdatedCounter|Number of times to wait for provisional correlation id to be updated to the actual correlation id when doing request/reply over JMS and when the option useMessageIDAsCorrelationID is enabled.|50|integer|
|waitForProvisionCorrelationToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for provisional correlation id to be updated.|100|duration|
|waitForTemporaryReplyToToBeUpdatedCounter|Number of times to wait for temporary replyTo queue to be created and ready when doing request/reply over JMS.|200|integer|
|waitForTemporaryReplyToToBeUpdatedThreadSleepingTime|Interval in millis to sleep each time while waiting for temporary replyTo queue to be ready.|100|duration|
|errorHandlerLoggingLevel|Allows to configure the default errorHandler logging level for logging uncaught exceptions.|WARN|object|
|errorHandlerLogStackTrace|Allows to control whether stack-traces should be logged or not, by the default errorHandler.|true|boolean|
|password|Password to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|username|Username to use with the ConnectionFactory. You can also configure username/password directly on the ConnectionFactory.||string|
|transacted|Specifies whether to use transacted mode|false|boolean|
|transactedInOut|Specifies whether InOut operations (request reply) default to using transacted mode If this flag is set to true, then Spring JmsTemplate will have sessionTransacted set to true, and the acknowledgeMode as transacted on the JmsTemplate used for InOut operations. Note from Spring JMS: that within a JTA transaction, the parameters passed to createQueue, createTopic methods are not taken into account. Depending on the Java EE transaction context, the container makes its own decisions on these values. Analogously, these parameters are not taken into account within a locally managed transaction either, since Spring JMS operates on an existing JMS Session in this case. Setting this flag to true will use a short local JMS transaction when running outside of a managed transaction, and a synchronized local JMS transaction in case of a managed transaction (other than an XA transaction) being present. This has the effect of a local JMS transaction being managed alongside the main transaction (which might be a native JDBC transaction), with the JMS transaction committing right after the main transaction.|false|boolean|
|lazyCreateTransactionManager|If true, Camel will create a JmsTransactionManager, if there is no transactionManager injected when option transacted=true.|true|boolean|
|transactionManager|The Spring transaction manager to use.||object|
|transactionName|The name of the transaction to use.||string|
|transactionTimeout|The timeout value of the transaction (in seconds), if using transacted mode.|-1|integer|
