# Ironmq

**Since Camel 2.17**

**Both producer and consumer are supported**

The IronMQ component provides integration with
[IronMQ](http://www.iron.io/products/mq) an elastic and durable hosted
message queue as a service.

The component uses the [IronMQ java
client](https://github.com/iron-io/iron_mq_java) library.

To run it requires an IronMQ account and a project id and token.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-ironmq</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

     ironmq:queueName[?options]

Where `queueName` identifies the IronMQ queue you want to publish or
consume messages from.

# Usage

## Message Body

It should be either a String or an array of Strings. In the latter case,
the batch of strings will be sent to IronMQ as one request, creating one
message per element in the array.

# Examples

## Consumer example

Consume 50 messages per poll from the queue `testqueue` on aws eu, and
save the messages to files.

    from("ironmq:testqueue?ironMQCloud=https://mq-aws-eu-west-1-1.iron.io&projectId=myIronMQProjectid&token=myIronMQToken&maxMessagesPerPoll=50")
      .to("file:somefolder");

## Producer example

Dequeue from activemq jms and enqueue the messages on IronMQ.

    from("activemq:foo")
      .to("ironmq:testqueue?projectId=myIronMQProjectid&token=myIronMQToken");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|queueName|The name of the IronMQ queue||string|
|ironMQCloud|IronMq Cloud url. Urls for public clusters: https://mq-aws-us-east-1-1.iron.io (US) and https://mq-aws-eu-west-1-1.iron.io (EU)|https://mq-aws-us-east-1-1.iron.io|string|
|preserveHeaders|Should message headers be preserved when publishing messages. This will add the Camel headers to the Iron MQ message as a json payload with a header list, and a message body. Useful when Camel is both consumer and producer.|false|boolean|
|projectId|IronMQ projectId||string|
|batchDelete|Should messages be deleted in one batch. This will limit the number of api requests since messages are deleted in one request, instead of one per exchange. If enabled care should be taken that the consumer is idempotent when processing exchanges.|false|boolean|
|concurrentConsumers|The number of concurrent consumers.|1|integer|
|maxMessagesPerPoll|Number of messages to poll per call. Maximum is 100.|1|integer|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|timeout|After timeout (in seconds), item will be placed back onto the queue.|60|integer|
|wait|Time in seconds to wait for a message to become available. This enables long polling. Default is 0 (does not wait), maximum is 30.||integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|visibilityDelay|The item will not be available on the queue until this many seconds have passed. Default is 0 seconds.||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|client|Reference to a io.iron.ironmq.Client in the Registry.||object|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
|token|IronMQ token||string|
