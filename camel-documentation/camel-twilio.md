# Twilio

**Since Camel 2.20**

**Both producer and consumer are supported**

The Twilio component provides access to Version 2010-04-01 of Twilio
REST APIs accessible using [Twilio Java
SDK](https://github.com/twilio/twilio-java).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-twilio</artifactId>
        <version>${camel-version}</version>
    </dependency>

# Producer Endpoints:

Producer endpoints can use endpoint prefixes followed by endpoint names
and associated options described next. A shorthand alias can be used for
all the endpoints. The endpoint URI MUST contain a prefix.

Any of the endpoint options can be provided in either the endpoint URI,
or dynamically in a message header. The message header name must be of
the format **`CamelTwilio.<option>`**. Note that the **`inBody`** option
overrides message header, i.e., the endpoint option **`inBody=option`**
would override a **`CamelTwilio.option`** header.

Endpoint can be one of:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 20%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Shorthand Alias</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><strong>creator</strong></p></td>
<td style="text-align: left;"><p>create</p></td>
<td style="text-align: left;"><p>Make the request to the Twilio API to
perform the <code>create</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>deleter</strong></p></td>
<td style="text-align: left;"><p>delete</p></td>
<td style="text-align: left;"><p>Make the request to the Twilio API to
perform the <code>delete</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>fetcher</strong></p></td>
<td style="text-align: left;"><p>fetch</p></td>
<td style="text-align: left;"><p>Make the request to the Twilio API to
perform the <code>fetch</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>reader</strong></p></td>
<td style="text-align: left;"><p>read</p></td>
<td style="text-align: left;"><p>Make the request to the Twilio API to
perform the <code>read</code></p></td>
</tr>
<tr>
<td style="text-align: left;"><p><strong>updater</strong></p></td>
<td style="text-align: left;"><p>update</p></td>
<td style="text-align: left;"><p>Make the request to the Twilio API to
perform the <code>update</code></p></td>
</tr>
</tbody>
</table>

Available endpoints differ depending on the endpoint prefixes.

For more information on the endpoints and options, see [Twilio API
documentation](https://www.twilio.com/docs/libraries/reference/twilio-java/index.html).

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|To use the shared configuration||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|restClient|To use the shared REST client||object|
|accountSid|The account SID to use.||string|
|password|Auth token for the account.||string|
|username|The account to use.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
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
