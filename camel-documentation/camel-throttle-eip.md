# Throttle-eip.md

How can I throttle messages to ensure that a specific endpoint does not
get overloaded, or we don’t exceed an agreed SLA with some external
service?

<figure>
<img src="eip/MessagingAdapterIcon.gif" alt="image" />
</figure>

Use a Throttler that controls the rate of how many or fast messages are
flowing to the endpoint.

# Options

# Exchange properties

# Using Throttle

The below example will throttle messages received on seda:a before being
sent to mock:result ensuring that a maximum of 3 messages is sent during
a running 10-second window slot.

Java  
from("seda:a")
.throttle(3).timePeriodMillis(10000)
.to("mock:result");

XML  
<route>  
<from uri="seda:a"/>  
<throttle timePeriodMillis="10000">  
<constant>3</constant>  
</throttle>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
constant: 3
timePeriodMillis: 10000
\- to:
uri: mock:result

To use 10-seconds window, we set the `timePeriodMillis` to ten-thousand.
The default value is 1000 (i.e., 1 second), meaning that setting just
`throttle(3)` has the effect of setting the maximum number of requests
per second.

To throttle by 50 requests per second, it would look like this:

Java  
from("seda:a")
.throttle(50)
.to("seda:b");

XML  
<route>  
<from uri="seda:a"/>  
<throttle>  
<constant>50</constant>  
</throttle>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
constant: 50
\- to:
uri: mock:result

## Dynamically changing maximum requests per period

The Throttler uses an [Expression](#manual:ROOT:expression.adoc) to
configure the number of requests. In all the examples from above, we
used a [constant](#components:languages:constant-language.adoc).
However, the expression can be dynamic, such as determined from a
message header from the current `Exchange`.

At runtime Camel evaluates the expression and converts the result to a
`java.lang.Long` type. In the example below, we use a header from the
message to determine the maximum requests per period. If the header is
absent, then the Throttler uses the old value. This allows you to only
provide a header if the value is to be changed:

Java  
from("seda:a")
.throttle(header("throttleValue")).timePeriodMillis(500)
.to("seda:b")

XML  
<route>  
<from uri="seda:a"/>  
<throttle timePeriodMillis="500">  
<!-- use a header to determine how many messages to throttle per 0.5 sec -->  
<header>throttleValue</header>  
</throttle>  
<to uri="seda:b"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
\# use a header to determine how many messages to throttle per 0.5 sec
header: throttleValue
timePeriodMillis: 500
\- to:
uri: seda:b

## Asynchronous delaying

You can let the Throttler use non-blocking asynchronous delaying, which
means Camel will use a scheduler to schedule a task to be executed in
the future. The task will then continue routing. This allows the caller
thread to not block and be able to service other messages, etc.

You enable asynchronous delaying using `asyncDelayed` as shown:

Java  
from("seda:a")
.throttle(100).asyncDelayed()
.to("seda:b");

XML  
<route>  
<from uri="seda:a"/>  
<throttle asyncDelayed="true">  
<constant>100</constant>  
</throttle>  
<to uri="seda:b"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
constant: 100
asyncDelayed: true
\- to:
uri: seda:b

## Rejecting processing if rate limit hit

When a message is being *throttled* due the maximum request per limit
has been reached, then the Throttler will by default wait until there is
*free space* before continue routing the message.

Instead of waiting you can also configure the Throttler to reject the
message by throwing `ThrottlerRejectedExecutionException` exception.

Java  
from("seda:a")
.throttle(100).rejectExecution(true)
.to("seda:b");

XML  
<route>  
<from uri="seda:a"/>  
<throttle timePeriodMillis="100" rejectExecution="true">  
<constant>100</constant>  
</throttle>  
<to uri="seda:b"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
constant: 100
timePeriodMillis: 100
rejectExecution: true
\- to:
uri: seda:b

## Throttling per group

The Throttler will by default throttle all messages in the same group.
However, it is possible to use a *correlation expression* to diving into
multiple groups, where each group is throttled independently.

For example, you can throttle by a [message](#message.adoc) header as
shown in the following example:

Java  
from("seda:a")
.throttle(100).correlationExpression(header("region"))
.to("seda:b");

XML  
<route>  
<from uri="seda:a"/>  
<throttle>  
<constant>100</constant>  
<correlationExpression>  
<header>region</header>  
</correlationExpression>  
</throttle>  
<to uri="seda:b"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
constant: 100
correlationExpression:
header: region
\- to:
uri: seda:b

In the example above, messages are throttled by the header with name
region. So suppose there are regions for US, EMEA, and ASIA. Then we
have three different groups that each are throttled by 100 messages per
second.

# Throttling Modes

Apache Camel comes with two distinct throttling modes to control and
manage the flow of requests in their applications.

These modes address different aspects of request handling:

**Total Requests Mode**  
Throttles requests based on the total number of requests made within a
defined unit of time. It regulates the overall traffic flow to prevent
overwhelming the system with an excessive number of requests.

**Concurrent Connections Mode**  
Throttles requests by managing concurrent connections using a [leaky
bucket algorithm.](https://en.wikipedia.org/wiki/Leaky_bucket) This
algorithm controls the rate at which requests are processed
simultaneously, preventing system overload.

## Default Mode

By default, Camel uses the **Total Requests Mode** as the default
throttling mechanism.

This means that, unless specified otherwise, the framework regulates the
flow of requests based on the total number of requests per unit of time.

## Choosing Throttling Mode

Users can choose their preferred throttling mode using different
approaches:

**DSL Methods**

-   `totalRequestsMode()`: Sets the total requests mode.

-   `concurrentRequestsMode()`: Sets the concurrent connections mode.

**Mode DSL Method**

-   `mode(String)`: Users can specify the throttling mode by passing
    either `TotalRequests` or `ConcurrentRequests` as an argument.

For example, `mode("ConcurrentRequests")` sets the throttling mode based
on concurrent connections.

These options provide users with fine-grained control over how Camel
manages the flow of requests, allowing them to choose the mode that best
aligns with their specific application requirements.

Java  
from("seda:a")
.throttle(3).mode("ConcurrentRequests")
.to("mock:result");

XML  
<route>  
<from uri="seda:a"/>  
<throttle mode="ConcurrentRequests">  
<constant>3</constant>  
</throttle>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:a
steps:
\- throttle:
expression:
constant: 3
mode: ConcurrentRequests
timePeriodMillis: 10000
\- to:
uri: mock:result
