# Seda

**Since Camel 1.1**

**Both producer and consumer are supported**

The SEDA component provides asynchronous
[SEDA](https://en.wikipedia.org/wiki/Staged_event-driven_architecture)
behavior, so that messages are exchanged on a
[BlockingQueue](http://java.sun.com/j2se/1.5.0/docs/api/java/util/concurrent/BlockingQueue.html)
and consumers are invoked in a separate thread from the producer.

Note that queues are only visible within the same CamelContext.

This component does not implement any kind of persistence or recovery if
the JVM terminates while messages are yet to be processed. If you need
persistence, reliability or distributed SEDA, try using
[JMS](#jms-component.adoc).

**Synchronous**

The [Direct](#direct-component.adoc) component provides synchronous
invocation of any consumers when a producer sends a message exchange.

# URI format

    seda:someId[?options]

Where *someId* can be any string that uniquely identifies the endpoint
within the current CamelContext.

# Choosing BlockingQueue implementation

By default, the SEDA component always instantiates a
`LinkedBlockingQueue`, but you can use different implementation, you can
reference your own `BlockingQueue` implementation, in this case the size
option is not used:

    <bean id="arrayQueue" class="java.util.ArrayBlockingQueue">
      <constructor-arg index="0" value="10" /><!-- size -->
      <constructor-arg index="1" value="true" /><!-- fairness -->
    </bean>
    
    <!-- ... and later -->
    <from>seda:array?queue=#arrayQueue</from>

You can also reference a `BlockingQueueFactory` implementation. Three
implementations are provided:

-   `LinkedBlockingQueueFactory`

-   `ArrayBlockingQueueFactory`

-   `PriorityBlockingQueueFactory`

<!-- -->

    <bean id="priorityQueueFactory" class="org.apache.camel.component.seda.PriorityBlockingQueueFactory">
      <property name="comparator">
        <bean class="org.apache.camel.demo.MyExchangeComparator" />
      </property>
    </bean>
    
    <!-- ... and later -->
    <from>seda:priority?queueFactory=#priorityQueueFactory&size=100</from>

# Use of Request Reply

The [SEDA](#seda-component.adoc) component supports using Request Reply,
where the caller will wait for the Async route to complete. For
instance:

    from("mina:tcp://0.0.0.0:9876?textline=true&sync=true").to("seda:input");
    
    from("seda:input").to("bean:processInput").to("bean:createResponse");

In the route above, we have a TCP listener on port 9876 that accepts
incoming requests. The request is routed to the `seda:input` queue. As
it is a Request Reply message, we wait for the response. When the
consumer on the `seda:input` queue is complete, it copies the response
to the original message response.

# Concurrent consumers

By default, the SEDA endpoint uses a single consumer thread, but you can
configure it to use concurrent consumer threads. So instead of thread
pools, you can use:

    from("seda:stageName?concurrentConsumers=5").process(...)

As for the difference between the two, note a *thread pool* can
increase/shrink dynamically at runtime depending on load, whereas the
number of concurrent consumers is always fixed.

# Thread pools

Be aware that adding a thread pool to a SEDA endpoint by doing something
like:

    from("seda:stageName").thread(5).process(...)

Can wind up with two `BlockQueues`: one from the SEDA endpoint, and one
from the work queue of the thread pool, which may not be what you want.
Instead, you might wish to configure a [Direct](#direct-component.adoc)
endpoint with a thread pool, which can process messages both
synchronously and asynchronously. For example:

    from("direct:stageName").thread(5).process(...)

You can also directly configure number of threads that process messages
on a SEDA endpoint using the `concurrentConsumers` option.

# Sample

In the route below, we use the SEDA queue to send the request to this
async queue. As such, it is able to send a *fire-and-forget* message for
further processing in another thread, and return a constant reply in
this thread to the original caller.

We send a *Hello World* message and expect the reply to be *OK*.

        @Test
        public void testSendAsync() throws Exception {
            MockEndpoint mock = getMockEndpoint("mock:result");
            mock.expectedBodiesReceived("Hello World");
    
            // START SNIPPET: e2
            Object out = template.requestBody("direct:start", "Hello World");
            assertEquals("OK", out);
            // END SNIPPET: e2
    
            MockEndpoint.assertIsSatisfied(context);
        }
    
        @Override
        protected RouteBuilder createRouteBuilder() throws Exception {
            return new RouteBuilder() {
                // START SNIPPET: e1
                public void configure() throws Exception {
                    from("direct:start")
                        // send it to the seda queue that is async
                        .to("seda:next")
                        // return a constant response
                        .transform(constant("OK"));
    
                    from("seda:next").to("mock:result");
                }
                // END SNIPPET: e1
            };
        }

The *Hello World* message will be consumed from the SEDA queue from
another thread for further processing. Since this is from a unit test,
it will be sent to a `mock` endpoint where we can do assertions in the
unit test.

# Using multipleConsumers

In this example, we have defined two consumers.

        @Test
        public void testSameOptionsProducerStillOkay() throws Exception {
            getMockEndpoint("mock:foo").expectedBodiesReceived("Hello World");
            getMockEndpoint("mock:bar").expectedBodiesReceived("Hello World");
    
            template.sendBody("seda:foo", "Hello World");
    
            MockEndpoint.assertIsSatisfied(context);
        }
    
        @Override
        protected RouteBuilder createRouteBuilder() throws Exception {
            return new RouteBuilder() {
                @Override
                public void configure() throws Exception {
                    from("seda:foo?multipleConsumers=true").routeId("foo").to("mock:foo");
                    from("seda:foo?multipleConsumers=true").routeId("bar").to("mock:bar");
                }
            };
        }

Since we have specified `multipleConsumers=true` on the seda `foo`
endpoint we can have those two consumers receive their own copy of the
message as a kind of *publish/subscribe* style messaging.

As the beans are part of a unit test, they simply send the message to a
mock endpoint.

# Extracting queue information.

If needed, information such as queue size, etc. can be obtained without
using JMX in this fashion:

    SedaEndpoint seda = context.getEndpoint("seda:xxxx");
    int size = seda.getExchanges().size();

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|concurrentConsumers|Sets the default number of concurrent threads processing exchanges.|1|integer|
|defaultPollTimeout|The timeout (in milliseconds) used when polling. When a timeout occurs, the consumer can check whether it is allowed to continue running. Setting a lower value allows the consumer to react more quickly upon shutdown.|1000|integer|
|defaultBlockWhenFull|Whether a thread that sends messages to a full SEDA queue will block until the queue's capacity is no longer exhausted. By default, an exception will be thrown stating that the queue is full. By enabling this option, the calling thread will instead block and wait until the message can be accepted.|false|boolean|
|defaultDiscardWhenFull|Whether a thread that sends messages to a full SEDA queue will be discarded. By default, an exception will be thrown stating that the queue is full. By enabling this option, the calling thread will give up sending and continue, meaning that the message was not sent to the SEDA queue.|false|boolean|
|defaultOfferTimeout|Whether a thread that sends messages to a full SEDA queue will block until the queue's capacity is no longer exhausted. By default, an exception will be thrown stating that the queue is full. By enabling this option, where a configured timeout can be added to the block case. Utilizing the .offer(timeout) method of the underlining java queue||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|defaultQueueFactory|Sets the default queue factory.||object|
|queueSize|Sets the default maximum capacity of the SEDA queue (i.e., the number of messages it can hold).|1000|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name of queue||string|
|size|The maximum capacity of the SEDA queue (i.e., the number of messages it can hold). Will by default use the defaultSize set on the SEDA component.|1000|integer|
|concurrentConsumers|Number of concurrent threads processing exchanges.|1|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|limitConcurrentConsumers|Whether to limit the number of concurrentConsumers to the maximum of 500. By default, an exception will be thrown if an endpoint is configured with a greater number. You can disable that check by turning this option off.|true|boolean|
|multipleConsumers|Specifies whether multiple consumers are allowed. If enabled, you can use SEDA for Publish-Subscribe messaging. That is, you can send a message to the SEDA queue and have each consumer receive a copy of the message. When enabled, this option should be specified on every consumer endpoint.|false|boolean|
|pollTimeout|The timeout (in milliseconds) used when polling. When a timeout occurs, the consumer can check whether it is allowed to continue running. Setting a lower value allows the consumer to react more quickly upon shutdown.|1000|integer|
|purgeWhenStopping|Whether to purge the task queue when stopping the consumer/route. This allows to stop faster, as any pending messages on the queue is discarded.|false|boolean|
|blockWhenFull|Whether a thread that sends messages to a full SEDA queue will block until the queue's capacity is no longer exhausted. By default, an exception will be thrown stating that the queue is full. By enabling this option, the calling thread will instead block and wait until the message can be accepted.|false|boolean|
|discardIfNoConsumers|Whether the producer should discard the message (do not add the message to the queue), when sending to a queue with no active consumers. Only one of the options discardIfNoConsumers and failIfNoConsumers can be enabled at the same time.|false|boolean|
|discardWhenFull|Whether a thread that sends messages to a full SEDA queue will be discarded. By default, an exception will be thrown stating that the queue is full. By enabling this option, the calling thread will give up sending and continue, meaning that the message was not sent to the SEDA queue.|false|boolean|
|failIfNoConsumers|Whether the producer should fail by throwing an exception, when sending to a queue with no active consumers. Only one of the options discardIfNoConsumers and failIfNoConsumers can be enabled at the same time.|false|boolean|
|offerTimeout|Offer timeout (in milliseconds) can be added to the block case when queue is full. You can disable timeout by using 0 or a negative value.||duration|
|timeout|Timeout (in milliseconds) before a SEDA producer will stop waiting for an asynchronous task to complete. You can disable timeout by using 0 or a negative value.|30000|duration|
|waitForTaskToComplete|Option to specify whether the caller should wait for the async task to complete or not before continuing. The following three options are supported: Always, Never or IfReplyExpected. The first two values are self-explanatory. The last value, IfReplyExpected, will only wait if the message is Request Reply based. The default option is IfReplyExpected.|IfReplyExpected|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|queue|Define the queue instance which will be used by the endpoint||object|
