# Twitter-directmessage

**Since Camel 2.10**

**Both producer and consumer are supported**

The Twitter Direct Message Component consumes/produces a user’s direct
messages.

**Consumer interval of time**

When using the Direct Message consumer, it will consider only the last
30-day direct messages

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|httpProxyHost|The http proxy host which can be used for the camel-twitter.||string|
|httpProxyPassword|The http proxy password which can be used for the camel-twitter.||string|
|httpProxyPort|The http proxy port which can be used for the camel-twitter.||integer|
|httpProxyUser|The http proxy user which can be used for the camel-twitter.||string|
|accessToken|The access token||string|
|accessTokenSecret|The access token secret||string|
|consumerKey|The consumer key||string|
|consumerSecret|The consumer secret||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|user|The user name to send a direct message. This will be ignored for consumer.||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|type|Endpoint type to use.|polling|object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|distanceMetric|Used by the geography search, to search by radius using the configured metrics. The unit can either be mi for miles, or km for kilometers. You need to configure all the following options: longitude, latitude, radius, and distanceMetric.|km|string|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|extendedMode|Used for enabling full text from twitter (eg receive tweets that contains more than 140 characters).|true|boolean|
|latitude|Used by the geography search to search by latitude. You need to configure all the following options: longitude, latitude, radius, and distanceMetric.||number|
|locations|Bounding boxes, created by pairs of lat/lons. Can be used for filter. A pair is defined as lat,lon. And multiple pairs can be separated by semicolon.||string|
|longitude|Used by the geography search to search by longitude. You need to configure all the following options: longitude, latitude, radius, and distanceMetric.||number|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|radius|Used by the geography search to search by radius. You need to configure all the following options: longitude, latitude, radius, and distanceMetric.||number|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|count|Limiting number of results per page.|5|integer|
|filterOld|Filter out old tweets, that has previously been polled. This state is stored in memory only, and based on last tweet id.|true|boolean|
|lang|The lang string ISO\_639-1 which will be used for searching||string|
|numberOfPages|The number of pages result which you want camel-twitter to consume.|1|integer|
|sinceId|The last tweet id which will be used for pulling the tweets. It is useful when the camel route is restarted after a long running.|1|integer|
|userIds|To filter by user ids for filter. Multiple values can be separated by comma.||string|
|httpProxyHost|The http proxy host which can be used for the camel-twitter. Can also be configured on the TwitterComponent level instead.||string|
|httpProxyPassword|The http proxy password which can be used for the camel-twitter. Can also be configured on the TwitterComponent level instead.||string|
|httpProxyPort|The http proxy port which can be used for the camel-twitter. Can also be configured on the TwitterComponent level instead.||integer|
|httpProxyUser|The http proxy user which can be used for the camel-twitter. Can also be configured on the TwitterComponent level instead.||string|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|30000|duration|
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
|accessToken|The access token. Can also be configured on the TwitterComponent level instead.||string|
|accessTokenSecret|The access secret. Can also be configured on the TwitterComponent level instead.||string|
|consumerKey|The consumer key. Can also be configured on the TwitterComponent level instead.||string|
|consumerSecret|The consumer secret. Can also be configured on the TwitterComponent level instead.||string|
|sortById|Sorts by id, so the oldest are first, and newest last.|true|boolean|
