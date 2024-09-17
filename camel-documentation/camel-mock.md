# Mock

**Since Camel 1.0**

**Only producer is supported**

Testing of distributed and asynchronous processing is notoriously
challenging. The [Mock](#mock-component.adoc) and
[DataSet](#dataset-component.adoc) endpoints work with the Camel Testing
Framework to simplify your unit and integration testing using
[Enterprise Integration
Patterns](#eips:enterprise-integration-patterns.adoc) and Camel’s large
range of Components together with the powerful Bean Integration.

# URI format

    mock:someName[?options]

Where `someName` can be any string that uniquely identifies the
endpoint.

# Usage

The Mock component provides a powerful declarative testing mechanism,
which is similar to [jMock](http://www.jmock.org) in that it allows
declarative expectations to be created on any Mock endpoint before a
test begins. Then the test is run, which typically fires messages to one
or more endpoints, and finally the expectations can be asserted in a
test case to ensure the system worked as expected.

This allows you to test various things like:

-   The correct number of messages is received on each endpoint.

-   The correct payloads are received, in the right order.

-   Messages arrive at an endpoint in order, using some Expression to
    create an order testing function.

-   Messages arrive match some kind of Predicate such as that specific
    headers have certain values, or that parts of the messages match
    some predicate, such as by evaluating an
    [XPath](#languages:xpath-language.adoc) or
    [XQuery](#languages:xquery-language.adoc) Expression.

There is also the [Test endpoint](#others:test-junit5.adoc), which is a
Mock endpoint, but which uses a second endpoint to provide the list of
expected message bodies and automatically sets up the Mock endpoint
assertions. In other words, it’s a Mock endpoint that automatically sets
up its assertions from some sample messages in a File or
[database](#jpa-component.adoc), for example.

**Mock endpoints keep received Exchanges in memory indefinitely.**

Remember that Mock is designed for testing. When you add Mock endpoints
to a route, each Exchange sent to the endpoint will be stored (to allow
for later validation) in memory until explicitly reset or the JVM is
restarted. If you are sending high volume and/or large messages, this
may cause excessive memory use. If your goal is to test deployable
routes inline, consider using NotifyBuilder or AdviceWith in your tests
instead of adding Mock endpoints to routes directly. There are two new
options `retainFirst`, and `retainLast` that can be used to limit the
number of messages the Mock endpoints keep in memory.

# Examples

## Simple Example

Here’s a simple example of Mock endpoint in use. First, the endpoint is
resolved on the context. Then we set an expectation, and then, after the
test has run, we assert that our expectations have been met:

    MockEndpoint resultEndpoint = context.getEndpoint("mock:foo", MockEndpoint.class);
    
    // set expectations
    resultEndpoint.expectedMessageCount(2);
    
    // send some messages
    
    // now let's assert that the mock:foo endpoint received 2 messages
    resultEndpoint.assertIsSatisfied();

You typically always call the
[`assertIsSatisfied()`](https://www.javadoc.io/doc/org.apache.camel/camel-mock/latest/org/apache/camel/component/mock/MockEndpoint.html#assertIsSatisfied--)
method to test that the expectations were met after running a test.

Camel will by default wait 10 seconds when the `assertIsSatisfied()` is
invoked. This can be configured by setting the
`setResultWaitTime(millis)` method.

## Using assertPeriod

When the assertion is satisfied then Camel will stop waiting and
continue from the `assertIsSatisfied` method. That means if a new
message arrives at the mock endpoint, just a bit later. That arrival
will not affect the outcome of the assertion. Suppose you do want to
test that no new messages arrives after a period thereafter, then you
can do that by setting the `setAssertPeriod` method, for example:

    MockEndpoint resultEndpoint = context.getEndpoint("mock:foo", MockEndpoint.class);
    resultEndpoint.setAssertPeriod(5000);
    resultEndpoint.expectedMessageCount(2);
    
    // send some messages
    
    // now let's assert that the mock:foo endpoint received 2 messages
    resultEndpoint.assertIsSatisfied();

## Setting expectations

You can see from the Javadoc of
[MockEndpoint](https://www.javadoc.io/doc/org.apache.camel/camel-mock/current/org/apache/camel/component/mock/MockEndpoint.html)
the various helper methods you can use to set expectations. The main
methods are as follows:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Method</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>expectedMessageCount(int)</code></p></td>
<td style="text-align: left;"><p>To define the expected count of
messages on the endpoint.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>expectedMinimumMessageCount(int)</code></p></td>
<td style="text-align: left;"><p>To define the minimum number of
expected messages on the endpoint.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>expectedBodiesReceived(…)</code></p></td>
<td style="text-align: left;"><p>To define the expected bodies that
should be received (in order).</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>expectedHeaderReceived(…)</code></p></td>
<td style="text-align: left;"><p>To define the expected header that
should be received</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>expectsAscending(Expression)</code></p></td>
<td style="text-align: left;"><p>To add an expectation that messages are
received in order, using the given Expression to compare
messages.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>expectsDescending(Expression)</code></p></td>
<td style="text-align: left;"><p>To add an expectation that messages are
received in order, using the given Expression to compare
messages.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>expectsNoDuplicates(Expression)</code></p></td>
<td style="text-align: left;"><p>To add an expectation that no duplicate
messages are received; using an Expression to calculate a unique
identifier for each message. This could be something like the
<code>JMSMessageID</code> if using JMS, or some unique reference number
within the message.</p></td>
</tr>
</tbody>
</table>

Here’s another example:

    resultEndpoint.expectedBodiesReceived("firstMessageBody", "secondMessageBody", "thirdMessageBody");

## Adding expectations to specific messages

In addition, you can use the
[`message(int messageIndex)`](https://javadoc.io/doc/org.apache.camel/camel-mock/latest/org/apache/camel/component/mock/MockEndpoint.html)
method to add assertions about a specific message that is received.

For example, to add expectations of the headers or body of the first
message (using zero-based indexing like `java.util.List`), you can use
the following code:

    resultEndpoint.message(0).header("foo").isEqualTo("bar");

There are some examples of the Mock endpoint in use in the [`camel-core`
processor
tests](https://github.com/apache/camel/tree/main/core/camel-core/src/test/java/org/apache/camel/processor).

## Mocking existing endpoints

Camel now allows you to automatically mock existing endpoints in your
Camel routes.

**How it works** The endpoints are still in action. What happens
differently is that a [Mock](#mock-component.adoc) endpoint is injected
and receives the message first and then delegates the message to the
target endpoint. You can view this as a kind of intercept and delegate
or endpoint listener.

Suppose you have the given route below:

****Route****

You can then use the `adviceWith` feature in Camel to mock all the
endpoints in a given route from your unit test, as shown below:

****`adviceWith` mocking all endpoints****

Notice that the mock endpoint is given the URI `mock:<endpoint>`, for
example `mock:direct:foo`. Camel logs at `INFO` level the endpoints
being mocked:

    INFO  Adviced endpoint [direct://foo] with mock endpoint [mock:direct:foo]

**Mocked endpoints are without parameters**  
Endpoints which are mocked will have their parameters stripped off. For
example, the endpoint `log:foo?showAll=true` will be mocked to the
following endpoint `mock:log:foo`. Notice the parameters have been
removed.

It’s also possible to only mock certain endpoints using a pattern. For
example to mock all `log` endpoints you do as shown:

****`adviceWith` mocking only log endpoints using a pattern****

The pattern supported can be a wildcard or a regular expression. See
more details about this at Intercept as it is the same matching function
used by Camel.

Mind that mocking endpoints causes the messages to be copied when they
arrive at the mock. That means Camel will use more memory. This may not
be suitable when you send in a lot of messages.

## Mocking existing endpoints using the `camel-test` component

Instead of using the `adviceWith` to instruct Camel to mock endpoints,
you can easily enable this behavior when using the `camel-test` Test
Kit.

The same route can be tested as follows. Notice that we return `"*"`
from the `isMockEndpoints` method, which tells Camel to mock all
endpoints.

If you only want to mock all `log` endpoints you can return `"log*"`
instead.

****`isMockEndpoints` using camel-test kit****

## Mocking existing endpoints with XML DSL

If you do not use the `camel-test` component for unit testing (as shown
above) you can use a different approach when using XML files for routes.

The solution is to create a new XML file used by the unit test and then
include the intended XML file which has the route you want to test.

Suppose we have the route in the `camel-route.xml` file:

****camel-route.xml****

Then we create a new XML file as follows, where we include the
`camel-route.xml` file and define a spring bean with the class
`org.apache.camel.impl.InterceptSendToMockEndpointStrategy` which tells
Camel to mock all endpoints:

****test-camel-route.xml****

Then in your unit test you load the new XML file
(`test-camel-route.xml`) instead of `camel-route.xml`.

To only mock all [Log](#log-component.adoc) endpoints, you can define
the pattern in the constructor for the bean:

    <bean id="mockAllEndpoints" class="org.apache.camel.impl.InterceptSendToMockEndpointStrategy">
        <constructor-arg index="0" value="log*"/>
    </bean>

## Mocking endpoints and skip sending to original endpoint

Sometimes you want to easily mock and skip sending to certain endpoints.
So the message is detoured and send to the mock endpoint only. You can
now use the `mockEndpointsAndSkip` method using AdviceWith. The example
below will skip sending to the two endpoints `"direct:foo"`, and
`"direct:bar"`.

****adviceWith mock and skip sending to endpoints****

The same example using the Test Kit

****isMockEndpointsAndSkip using camel-test kit****

## Limiting the number of messages to keep

The [Mock](#mock-component.adoc) endpoints will by default keep a copy
of every Exchange that it received. So if you test with a lot of
messages, then it will consume memory.  
We have introduced two options `retainFirst` and `retainLast` that can
be used to specify to only keep Nth of the first and/or last Exchanges.

For example, in the code below, we only want to retain a copy of the
first five and last five Exchanges the mock receives.

      MockEndpoint mock = getMockEndpoint("mock:data");
      mock.setRetainFirst(5);
      mock.setRetainLast(5);
      mock.expectedMessageCount(2000);
    
      mock.assertIsSatisfied();

Using this has some limitations. The `getExchanges()` and
`getReceivedExchanges()` methods on the `MockEndpoint` will return only
the retained copies of the Exchanges. So in the example above, the list
will contain 10 Exchanges; the first five, and the last five.  
The `retainFirst` and `retainLast` options also have limitations on
which expectation methods you can use. For example, the `expectedXXX`
methods that work on message bodies, headers, etc. will only operate on
the retained messages. In the example above, they can test only the
expectations on the 10 retained messages.

## Testing with arrival times

The [Mock](#mock-component.adoc) endpoint stores the arrival time of the
message as a property on the Exchange.

    Date time = exchange.getProperty(Exchange.RECEIVED_TIMESTAMP, Date.class);

You can use this information to know when the message arrived at the
mock. But it also provides foundation to know the time interval between
the previous and next message arrived at the mock. You can use this to
set expectations using the `arrives` DSL on the
[Mock](#mock-component.adoc) endpoint.

For example, to say that the first message should arrive between 0 and 2
seconds before the next you can do:

    mock.message(0).arrives().noLaterThan(2).seconds().beforeNext();

You can also define this as that second message (0 index based) should
arrive no later than 0 and 2 seconds after the previous:

    mock.message(1).arrives().noLaterThan(2).seconds().afterPrevious();

You can also use between to set a lower bound. For example, suppose that
it should be between 1 and 4 seconds:

    mock.message(1).arrives().between(1, 4).seconds().afterPrevious();

You can also set the expectation on all messages, for example, to say
that the gap between them should be at most 1 second:

    mock.allMessages().arrives().noLaterThan(1).seconds().beforeNext();

**Time units**

In the example above we use `seconds` as the time unit, but Camel offers
`milliseconds`, and `minutes` as well.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|log|To turn on logging when the mock receives an incoming message. This will log only one time at INFO level for the incoming message. For more detailed logging, then set the logger to DEBUG level for the org.apache.camel.component.mock.MockEndpoint class.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|exchangeFormatter|Sets a custom ExchangeFormatter to convert the Exchange to a String suitable for logging. If not specified, we default to DefaultExchangeFormatter.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name of mock endpoint||string|
|assertPeriod|Sets a grace period after which the mock endpoint will re-assert to ensure the preliminary assertion is still valid. This is used, for example, to assert that exactly a number of messages arrive. For example, if the expected count was set to 5, then the assertion is satisfied when five or more messages arrive. To ensure that exactly 5 messages arrive, then you would need to wait a little period to ensure no further message arrives. This is what you can use this method for. By default, this period is disabled.||duration|
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
