# Scheduler

**Since Camel 2.15**

**Only consumer is supported**

The Scheduler component is used to generate message exchanges when a
scheduler fires. This component is similar to the
[Timer](#timer-component.adoc) component, but it offers more
functionality in terms of scheduling. Also, this component uses JDK
`ScheduledExecutorService`, whereas the timer uses a JDK `Timer`.

You can only consume events from this endpoint.

# URI format

    scheduler:name[?options]

Where `name` is the name of the scheduler, which is created and shared
across endpoints. So if you use the same name for all your scheduler
endpoints, only one scheduler thread pool and thread will be used - but
you can configure the thread pool to allow more concurrent threads.

**Note:** The IN body of the generated exchange is `null`. So
`exchange.getIn().getBody()` returns `null`.

# More information

This component is a scheduler [Polling
Consumer](http://camel.apache.org/polling-consumer.html) where you can
find more information about the options above, and examples at the
[Polling Consumer](http://camel.apache.org/polling-consumer.html) page.

# Usage

## Exchange Properties

When the timer is fired, it adds the following information as properties
to the `Exchange`:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>Exchange.TIMER_NAME</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The value of the <code>name</code>
option.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>Exchange.TIMER_FIRED_TIME</code></p></td>
<td style="text-align: left;"><p><code>Date</code></p></td>
<td style="text-align: left;"><p>The time when the consumer
fired.</p></td>
</tr>
</tbody>
</table>

## Forcing the scheduler to trigger immediately when completed

To let the scheduler trigger as soon as the previous task is complete,
you can set the option `greedy=true`. But beware then the scheduler will
keep firing all the time. So use this with caution.

## Forcing the scheduler to be idle

There can be use cases where you want the scheduler to trigger and be
greedy. But sometimes you want to "tell the scheduler" that there was no
task to poll, so the scheduler can change into idle mode using the
backoff options. To do this, you would need to set a property on the
exchange with the key `Exchange.SCHEDULER_POLLED_MESSAGES` to a boolean
value of false. This will cause the consumer to indicate that there were
no messages polled.

The consumer will otherwise as by default return 1 message polled to the
scheduler, every time the consumer has completed processing the
exchange.

# Example

To set up a route that generates an event every 60 seconds:

    from("scheduler://foo?delay=60000").to("bean:myBean?method=someMethodName");

The above route will generate an event and then invoke the
`someMethodName` method on the bean called `myBean` in the Registry such
as JNDI or Spring.

And the route in Spring DSL:

    <route>
      <from uri="scheduler://foo?delay=60000"/>
      <to uri="bean:myBean?method=someMethodName"/>
    </route>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|includeMetadata|Whether to include metadata in the exchange such as fired time, timer name, timer count etc.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|poolSize|Number of core threads in the thread pool used by the scheduling thread pool. Is by default using a single thread|1|integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|The name of the scheduler||string|
|includeMetadata|Whether to include metadata in the exchange such as fired time, timer name, timer count etc.|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|500|integer|
|greedy|If greedy is enabled, then the ScheduledPollConsumer will run immediately again, if the previous run polled 1 or more messages.|false|boolean|
|initialDelay|Milliseconds before the first poll starts.|1000|integer|
|poolSize|Number of core threads in the thread pool used by the scheduling thread pool. Is by default using a single thread|1|integer|
|repeatCount|Specifies a maximum limit of number of fires. So if you set it to 1, the scheduler will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.|0|integer|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
|scheduledExecutorService|Allows for configuring a custom/shared thread pool to use for the consumer. By default each consumer has its own single threaded thread pool.||object|
|scheduler|To use a cron scheduler from either camel-spring or camel-quartz component. Use value spring or quartz for built in scheduler|none|object|
|schedulerProperties|To configure additional properties when using a custom scheduler or any of the Quartz, Spring based scheduler.||object|
|startScheduler|Whether the scheduler should be auto started.|true|boolean|
|timeUnit|Time unit for initialDelay and delay options.|MILLISECONDS|object|
|useFixedDelay|Controls if fixed delay or fixed rate is used. See ScheduledExecutorService in JDK for details.|true|boolean|
