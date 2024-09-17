# Timer

**Since Camel 1.0**

**Only consumer is supported**

The Timer component is used to generate message exchanges when a timer
fires. You can only consume events from this endpoint.

# URI format

    timer:name[?options]

Where `name` is the name of the `Timer` object, which is created and
shared across endpoints. So if you use the same name for all your timer
endpoints, only one `Timer` object and thread will be used.

The *IN* body of the generated exchange is `null`. Therefore, calling
`exchange.getIn().getBody()` returns `null`.

**Advanced Scheduler**

See also the [Quartz](#quartz-component.adoc) component that supports
much more advanced scheduling.

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
style="text-align: left;"><p><code>Exchange.TIMER_TIME</code></p></td>
<td style="text-align: left;"><p><code>Date</code></p></td>
<td style="text-align: left;"><p>The value of the <code>time</code>
option.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>Exchange.TIMER_PERIOD</code></p></td>
<td style="text-align: left;"><p><code>long</code></p></td>
<td style="text-align: left;"><p>The value of the <code>period</code>
option.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>Exchange.TIMER_FIRED_TIME</code></p></td>
<td style="text-align: left;"><p><code>Date</code></p></td>
<td style="text-align: left;"><p>The time when the consumer
fired.</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>Exchange.TIMER_COUNTER</code></p></td>
<td style="text-align: left;"><p><code>Long</code></p></td>
<td style="text-align: left;"><p>The current fire counter. Starts from
1.</p></td>
</tr>
</tbody>
</table>

# Example

To set up a route that generates an event every 60 seconds:

    from("timer://foo?fixedRate=true&period=60000").to("bean:myBean?method=someMethodName");

The above route will generate an event and then invoke the
`someMethodName` method on the bean called `myBean` in the Registry.

And the route in Spring DSL:

    <route>
      <from uri="timer://foo?fixedRate=true&amp;period=60000"/>
      <to uri="bean:myBean?method=someMethodName"/>
    </route>

## Firing as soon as possible

You may want to fire messages in a Camel route as soon as possible, you
can use a negative delay:

    <route>
      <from uri="timer://foo?delay=-1"/>
      <to uri="bean:myBean?method=someMethodName"/>
    </route>

In this way, the timer will fire messages immediately.

You can also specify a `repeatCount` parameter in conjunction with a
negative delay to stop firing messages after a fixed number has been
reached.

If you don’t specify a `repeatCount` then the timer will continue firing
messages until the route will be stopped.

## Firing only once

You may want to fire a message in a Camel route only once, such as when
starting the route. To do that, you use the `repeatCount` option as
shown:

    <route>
      <from uri="timer://foo?repeatCount=1"/>
      <to uri="bean:myBean?method=someMethodName"/>
    </route>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|includeMetadata|Whether to include metadata in the exchange such as fired time, timer name, timer count etc.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|timerName|The name of the timer||string|
|delay|The number of milliseconds to wait before the first event is generated. Should not be used in conjunction with the time option. The default value is 1000.|1000|duration|
|fixedRate|Events take place at approximately regular intervals, separated by the specified period.|false|boolean|
|includeMetadata|Whether to include metadata in the exchange such as fired time, timer name, timer count etc.|false|boolean|
|period|Generate periodic events every period. Must be zero or positive value. The default value is 1000.|1000|duration|
|repeatCount|Specifies a maximum limit for the number of fires. Therefore, if you set it to 1, the timer will only fire once. If you set it to 5, it will only fire five times. A value of zero or negative means fire forever.||integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|daemon|Specifies whether the thread associated with the timer endpoint runs as a daemon. The default value is true.|true|boolean|
|pattern|Allows you to specify a custom Date pattern to use for setting the time option using URI syntax.||string|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
|time|A java.util.Date the first event should be generated. If using the URI, the pattern expected is: yyyy-MM-dd HH:mm:ss or yyyy-MM-dd'T'HH:mm:ss.||string|
|timer|To use a custom Timer||object|
|runLoggingLevel|The consumer logs a start/complete log line when it polls. This option allows you to configure the logging level for that.|TRACE|object|
