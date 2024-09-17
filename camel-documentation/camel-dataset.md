# Dataset

**Since Camel 1.3**

**Both producer and consumer are supported**

Testing of distributed and asynchronous processing is notoriously
challenging. The [Mock](#mock-component.adoc),
[DataSet](#dataset-component.adoc), and [DataSet
Test](#dataset-test-component.adoc) endpoints work with the Camel
Testing Framework to simplify your unit and integration testing using
[Enterprise Integration
Patterns](#eips:enterprise-integration-patterns.adoc) and Camel’s large
range of Components together with the powerful Bean Integration.

The DataSet component provides a mechanism to easily perform load \& soak
testing of your system. It works by allowing you to create [DataSet
instances](https://www.javadoc.io/doc/org.apache.camel/camel-dataset/current/org/apache/camel/component/dataset/DataSet.html)
both as a source of messages and as a way to assert that the data set is
received.

Camel will use the [throughput logger](#log-component.adoc) when sending
the dataset.

# URI format

    dataset:name[?options]

Where **name** is used to find the [DataSet
instance](https://www.javadoc.io/doc/org.apache.camel/camel-dataset/current/org/apache/camel/component/dataset/DataSet.html)
in the Registry

Camel ships with a support implementation of
`org.apache.camel.component.dataset.DataSet`, the
`org.apache.camel.component.dataset.DataSetSupport` class, that can be
used as a base for implementing your own data set. Camel also ships with
some implementations that can be used for testing:
`org.apache.camel.component.dataset.SimpleDataSet`,
`org.apache.camel.component.dataset.ListDataSet` and
`org.apache.camel.component.dataset.FileDataSet`, all of which extend
`DataSetSupport`.

# Usage

## Configuring DataSet

Camel will look up in the Registry for a bean implementing the `DataSet`
interface. So you can register your own data set as:

    <bean id="myDataSet" class="com.mycompany.MyDataSet">
      <property name="size" value="100"/>
    </bean>

## DataSetSupport (abstract class)

The `DataSetSupport` abstract class is a nice starting point for new
data set, and provides some useful features to derived classes.

### Additional Properties on DataSetSupport

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>defaultHeaders</code></p></td>
<td
style="text-align: left;"><p><code>Map&lt;String,Object&gt;</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p>Specify the default message body. For
<code>SimpleDataSet</code> it is a constant payload; though if you want
to create custom payloads per message, create your own derivation of
<code>DataSetSupport</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>outputTransformer</code></p></td>
<td
style="text-align: left;"><p><code>org.apache.camel.Processor</code></p></td>
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>size</code></p></td>
<td style="text-align: left;"><p><code>long</code></p></td>
<td style="text-align: left;"><p><code>10</code></p></td>
<td style="text-align: left;"><p>Specify how many messages to
send/consume.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>reportCount</code></p></td>
<td style="text-align: left;"><p><code>long</code></p></td>
<td style="text-align: left;"><p><code>-1</code></p></td>
<td style="text-align: left;"><p>Specify the number of messages to be
received before reporting progress. Useful for showing the progress of a
large load test. If smaller than zero (` &lt; 0`), then
<code>size</code> / 5, if is 0 then <code>size</code>, else set to
<code>reportCount</code> value.</p></td>
</tr>
</tbody>
</table>

## SimpleDataSet

The `SimpleDataSet` extends `DataSetSupport`, and adds a default body.

### Additional Properties on SimpleDataSet

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>defaultBody</code></p></td>
<td style="text-align: left;"><p><code>Object</code></p></td>
<td
style="text-align: left;"><p><code>&lt;hello&gt;world!&lt;/hello&gt;</code></p></td>
<td style="text-align: left;"><p>Specify the default message body. By
default, the <code>SimpleDataSet</code> produces the same constant
payload for each exchange. If you want to customize the payload for each
exchange, create a Camel <code>Processor</code> and configure the
<code>SimpleDataSet</code> to use it by setting the
<code>outputTransformer</code> property.</p></td>
</tr>
</tbody>
</table>

## ListDataSet

The List\`DataSet\` extends `DataSetSupport`, and adds a list of default
bodies.

### Additional Properties on ListDataSet

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>defaultBodies</code></p></td>
<td
style="text-align: left;"><p><code>List&lt;Object&gt;</code></p></td>
<td
style="text-align: left;"><p><code>empty LinkedList&lt;Object&gt;</code></p></td>
<td style="text-align: left;"><p>Specify the default message body. By
default, the <code>ListDataSet</code> selects a constant payload from
the list of <code>defaultBodies</code> using the
<code>CamelDataSetIndex</code>. If you want to customize the payload,
create a Camel <code>Processor</code> and configure the
<code>ListDataSet</code> to use it by setting the
<code>outputTransformer</code> property.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>size</code></p></td>
<td style="text-align: left;"><p><code>long</code></p></td>
<td style="text-align: left;"><p>the size of the defaultBodies
list</p></td>
<td style="text-align: left;"><p>Specify how many messages to
send/consume. This value can be different from the size of the
<code>defaultBodies</code> list. If the value is less than the size of
the <code>defaultBodies</code> list, some of the list elements will not
be used. If the value is greater than the size of the
<code>defaultBodies</code> list, the payload for the exchange will be
selected using the modulus of the <code>CamelDataSetIndex</code> and the
size of the <code>defaultBodies</code> list (i.e.,
<code>CamelDataSetIndex % defaultBodies.size()</code> )</p></td>
</tr>
</tbody>
</table>

## FileDataSet

The `FileDataSet` extends `ListDataSet`, and adds support for loading
the bodies from a file.

### Additional Properties on FileDataSet

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Property</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>sourceFile</code></p></td>
<td style="text-align: left;"><p><code>File</code></p></td>
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"><p>Specify the source file for
payloads</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>delimiter</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>\z</p></td>
<td style="text-align: left;"><p>Specify the delimiter pattern used by a
<code>java.util.Scanner</code> to split the file into multiple
payloads.</p></td>
</tr>
</tbody>
</table>

# Example

For example, to test that a set of messages are sent to a queue and then
consumed from the queue without losing any messages:

    // send the dataset to a queue
    from("dataset:foo").to("activemq:SomeQueue");
    
    // now lets test that the messages are consumed correctly
    from("activemq:SomeQueue").to("dataset:foo");

The above would look in the Registry to find the `foo` `DataSet`
instance which is used to create the messages.

Then you create a `DataSet` implementation, such as using the
`SimpleDataSet` as described below, configuring things like how big the
data set is and what the messages look like etc.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|log|To turn on logging when the mock receives an incoming message. This will log only one time at INFO level for the incoming message. For more detailed logging, then set the logger to DEBUG level for the org.apache.camel.component.mock.MockEndpoint class.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|exchangeFormatter|Sets a custom ExchangeFormatter to convert the Exchange to a String suitable for logging. If not specified, we default to DefaultExchangeFormatter.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name of DataSet to lookup in the registry||object|
|dataSetIndex|Controls the behaviour of the CamelDataSetIndex header. off (consumer) the header will not be set. strict (consumer) the header will be set. lenient (consumer) the header will be set. off (producer) the header value will not be verified, and will not be set if it is not present. strict (producer) the header value must be present and will be verified. lenient (producer) the header value will be verified if it is present, and will be set if it is not present.|lenient|string|
|initialDelay|Time period in millis to wait before starting sending messages.|1000|duration|
|minRate|Wait until the DataSet contains at least this number of messages|0|integer|
|preloadSize|Sets how many messages should be preloaded (sent) before the route completes its initialization|0|integer|
|produceDelay|Allows a delay to be specified which causes a delay when a message is sent by the consumer (to simulate slow processing)|3|duration|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|assertPeriod|Sets a grace period after which the mock endpoint will re-assert to ensure the preliminary assertion is still valid. This is used, for example, to assert that exactly a number of messages arrive. For example, if the expected count was set to 5, then the assertion is satisfied when five or more messages arrive. To ensure that exactly 5 messages arrive, then you would need to wait a little period to ensure no further message arrives. This is what you can use this method for. By default, this period is disabled.||duration|
|consumeDelay|Allows a delay to be specified which causes a delay when a message is consumed by the producer (to simulate slow processing)|0|duration|
|expectedCount|Specifies the expected number of message exchanges that should be received by this endpoint. Beware: If you want to expect that 0 messages, then take extra care, as 0 matches when the tests starts, so you need to set a assert period time to let the test run for a while to make sure there are still no messages arrived; for that use setAssertPeriod(long). An alternative is to use NotifyBuilder, and use the notifier to know when Camel is done routing some messages, before you call the assertIsSatisfied() method on the mocks. This allows you to not use a fixed assert period, to speedup testing times. If you want to assert that exactly nth message arrives to this mock endpoint, then see also the setAssertPeriod(long) method for further details.|-1|integer|
|failFast|Sets whether assertIsSatisfied() should fail fast at the first detected failed expectation while it may otherwise wait for all expected messages to arrive before performing expectations verifications. Is by default true. Set to false to use behavior as in Camel 2.x.|false|boolean|
|log|To turn on logging when the mock receives an incoming message. This will log only one time at INFO level for the incoming message. For more detailed logging then set the logger to DEBUG level for the org.apache.camel.component.mock.MockEndpoint class.|false|boolean|
|reportGroup|A number that is used to turn on throughput logging based on groups of the size.||integer|
|resultMinimumWaitTime|Sets the minimum expected amount of time (in millis) the assertIsSatisfied() will wait on a latch until it is satisfied||duration|
|resultWaitTime|Sets the maximum amount of time (in millis) the assertIsSatisfied() will wait on a latch until it is satisfied||duration|
|retainFirst|Specifies to only retain the first nth number of received Exchanges. This is used when testing with big data, to reduce memory consumption by not storing copies of every Exchange this mock endpoint receives. Important: When using this limitation, then the getReceivedCounter() will still return the actual number of received Exchanges. For example if we have received 5000 Exchanges, and have configured to only retain the first 10 Exchanges, then the getReceivedCounter() will still return 5000 but there is only the first 10 Exchanges in the getExchanges() and getReceivedExchanges() methods. When using this method, then some of the other expectation methods is not supported, for example the expectedBodiesReceived(Object...) sets a expectation on the first number of bodies received. You can configure both setRetainFirst(int) and setRetainLast(int) methods, to limit both the first and last received.|-1|integer|
|retainLast|Specifies to only retain the last nth number of received Exchanges. This is used when testing with big data, to reduce memory consumption by not storing copies of every Exchange this mock endpoint receives. Important: When using this limitation, then the getReceivedCounter() will still return the actual number of received Exchanges. For example if we have received 5000 Exchanges, and have configured to only retain the last 20 Exchanges, then the getReceivedCounter() will still return 5000 but there is only the last 20 Exchanges in the getExchanges() and getReceivedExchanges() methods. When using this method, then some of the other expectation methods is not supported, for example the expectedBodiesReceived(Object...) sets a expectation on the first number of bodies received. You can configure both setRetainFirst(int) and setRetainLast(int) methods, to limit both the first and last received.|-1|integer|
|sleepForEmptyTest|Allows a sleep to be specified to wait to check that this endpoint really is empty when expectedMessageCount(int) is called with zero||duration|
|copyOnExchange|Sets whether to make a deep copy of the incoming Exchange when received at this mock endpoint. Is by default true.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
