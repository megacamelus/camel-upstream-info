# Delay-eip.md

The Delay EIP is used for delaying messages during routing.

# Options

# Exchange properties

# Example

The example below will delay all messages received on **seda:b** 1
second before sending them to **mock:result**.

Java  
from("seda:b")
.delay(1000)
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<delay>  
<constant>1000</constant>  
</delay>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:b
steps:
\- delay:
expression:
constant: 1000
\- to:
uri: mock:result

Note that delay creates its own block, so some DSLs (including Java)
require the delay block be closed:

    .from("direct:delayBlockExample")
        .to("direct:getJobState")
        .loopDoWhile(simple("${body.state} = 'NOT_DONE'"))
            .log(LoggingLevel.DEBUG, "Pausing")
            .delay(10000)
                .syncDelayed()
            .end() // we must end the delay or else the log statement will be executed in each loop iteration
            .to("direct:getJobState")
        .end()
        .log("and we're done");

The delayed value can be a dynamic
[Expression](#manual::expression.adoc).

For example, to delay a random between 1 and 5 seconds, we can use the
[Simple](#languages:simple-language.adoc) language:

Java  
from("seda:b")
.delay(simple("${random(1000,5000)}"))
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<delay>  
<simple>${random(1000,5000)}</simple>  
</delay>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:b
steps:
\- delay:
expression:
simple: "${random(1000,5000)}"
\- to:
uri: mock:result

You can also call a [Bean Method](#languages:bean-language.adoc) to
compute the delayed value from Java code:

    from("activemq:foo")
      .delay().method("someBean", "computeDelay")
      .to("activemq:bar");

Then the bean would look something like this:

    public class SomeBean {
      public long computeDelay() {
         long delay = 0;
         // use java code to compute a delay value in millis
         return delay;
     }
    }

# Asynchronous delaying

You can let the Delayer use non-blocking asynchronous delaying, which
means Camel will use scheduled thread pool (`ScheduledExecutorService`)
to schedule a task to be executed in the future. This allows the caller
thread to not block and be able to service other messages.

You use the `asyncDelayed()` to enable the async behavior.

Java  
from("activemq:queue:foo")
.delay(1000).asyncDelayed()
.to("activemq:aDelayedQueue");

XML  
<route>  
<from uri="activemq:queue:foo"/>  
<delay asyncDelayed="true">  
<constant>1000</constant>  
</delay>  
<to uri="activemq:aDelayedQueue"/>  
</route>

YAML  
\- from:
uri: activemq:queue:foo
steps:
\- delay:
expression:
constant: 1000
asyncDelayed: true
\- to:
uri: activemq:aDelayedQueue
