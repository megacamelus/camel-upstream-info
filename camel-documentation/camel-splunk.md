# Splunk

**Since Camel 2.13**

**Both producer and consumer are supported**

The Splunk component provides access to
[Splunk](http://docs.splunk.com/Documentation/Splunk/latest) using the
Splunk provided [client](https://github.com/splunk/splunk-sdk-java) api,
and it enables you to publish and search for events in Splunk.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-splunk</artifactId>
        <version>${camel-version}</version>
    </dependency>

# URI format

    splunk://[endpoint]?[options]

# Usage

## Producer Endpoints

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>stream</code></p></td>
<td style="text-align: left;"><p>Streams data to a named index or the
default if not specified. When using stream mode, be aware of that
Splunk has some internal buffer (about 1MB or so) before events get to
the index. If you need realtime, better use submit or tcp mode.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>submit</code></p></td>
<td style="text-align: left;"><p>submit mode. Uses Splunk rest api to
publish events to a named index or the default if not
specified.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>tcp</code></p></td>
<td style="text-align: left;"><p>tcp mode. Streams data to a tcp port,
and requires an open receiver port in Splunk.</p></td>
</tr>
</tbody>
</table>

When publishing events, the message body should contain a SplunkEvent.
See comment under message body.

**Example**

          from("direct:start").convertBodyTo(SplunkEvent.class)
              .to("splunk://submit?username=user&password=123&index=myindex&sourceType=someSourceType&source=mySource")...

In this example, a converter is required to convert to a SplunkEvent
class.

## Consumer Endpoints

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Endpoint</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>normal</code></p></td>
<td style="text-align: left;"><p>Performs normal search and requires a
search query in the search option.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>realtime</code></p></td>
<td style="text-align: left;"><p>Performs realtime search on live data
and requires a search query in the search option.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>savedsearch</code></p></td>
<td style="text-align: left;"><p>Performs search based on a search query
saved in splunk and requires the name of the query in the savedSearch
option.</p></td>
</tr>
</tbody>
</table>

**Example**

          from("splunk://normal?delay=5000&username=user&password=123&initEarliestTime=-10s&search=search index=myindex sourcetype=someSourcetype")
              .to("direct:search-result");

Camel Splunk component creates a route exchange per search result with a
SplunkEvent in the body.

## Message body

Splunk operates on data in key/value pairs. The `SplunkEvent` class is a
placeholder for such data, and should be in the message body for the
producer. Likewise, it will be returned in the body per search result
for the consumer.

You can send raw data to Splunk by setting the raw option on the
producer endpoint. This is useful for e.g., json/xml and other payloads
where Splunk has built in support.

## Use Cases

Search Twitter for tweets with music and publish events to Splunk

          from("twitter://search?type=polling&keywords=music&delay=10&consumerKey=abc&consumerSecret=def&accessToken=hij&accessTokenSecret=xxx")
              .convertBodyTo(SplunkEvent.class)
              .to("splunk://submit?username=foo&password=bar&index=camel-tweets&sourceType=twitter&source=music-tweets");

To convert a Tweet to a `SplunkEvent`, you could use a converter like:

    @Converter
    public class Tweet2SplunkEvent {
        @Converter
        public static SplunkEvent convertTweet(Status status) {
            SplunkEvent data = new SplunkEvent("twitter-message", null);
            //data.addPair("source", status.getSource());
            data.addPair("from_user", status.getUser().getScreenName());
            data.addPair("in_reply_to", status.getInReplyToScreenName());
            data.addPair(SplunkEvent.COMMON_START_TIME, status.getCreatedAt());
            data.addPair(SplunkEvent.COMMON_EVENT_ID, status.getId());
            data.addPair("text", status.getText());
            data.addPair("retweet_count", status.getRetweetCount());
            if (status.getPlace() != null) {
                data.addPair("place_country", status.getPlace().getCountry());
                data.addPair("place_name", status.getPlace().getName());
                data.addPair("place_street", status.getPlace().getStreetAddress());
            }
            if (status.getGeoLocation() != null) {
                data.addPair("geo_latitude", status.getGeoLocation().getLatitude());
                data.addPair("geo_longitude", status.getGeoLocation().getLongitude());
            }
            return data;
        }
    }

Search Splunk for tweets:

          from("splunk://normal?username=foo&password=bar&initEarliestTime=-2m&search=search index=camel-tweets sourcetype=twitter")
              .log("${body}");

## Other comments

Splunk comes with a variety of options for leveraging machine generated
data with prebuilt apps for analyzing and displaying this. For example,
the jmx app could be used to publish jmx attributes, e.g., route and jvm
metrics to Splunk, and display this on a dashboard.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|splunkConfigurationFactory|To use the SplunkConfigurationFactory||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Name has no purpose||string|
|app|Splunk app||string|
|connectionTimeout|Timeout in MS when connecting to Splunk server|5000|integer|
|host|Splunk host.|localhost|string|
|owner|Splunk owner||string|
|port|Splunk port|8089|integer|
|scheme|Splunk scheme|https|string|
|count|A number that indicates the maximum number of entities to return.||integer|
|earliestTime|Earliest time of the search time window.||string|
|initEarliestTime|Initial start offset of the first search||string|
|latestTime|Latest time of the search time window.||string|
|savedSearch|The name of the query saved in Splunk to run||string|
|search|The Splunk query to run||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|streaming|Sets streaming mode. Streaming mode sends exchanges as they are received, rather than in a batch.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|eventHost|Override the default Splunk event host field||string|
|index|Splunk index to write to||string|
|raw|Should the payload be inserted raw|false|boolean|
|source|Splunk source argument||string|
|sourceType|Splunk sourcetype argument||string|
|tcpReceiverLocalPort|Splunk tcp receiver port defined locally on splunk server. (For example if splunk port 9997 is mapped to 12345, tcpReceiverLocalPort has to be 9997)||integer|
|tcpReceiverPort|Splunk tcp receiver port||integer|
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
|password|Password for Splunk||string|
|sslProtocol|Set the ssl protocol to use|TLSv1.2|object|
|token|User's token for Splunk. This takes precedence over password when both are set||string|
|username|Username for Splunk||string|
|useSunHttpsHandler|Use sun.net.www.protocol.https.Handler Https handler to establish the Splunk Connection. Can be useful when running in application servers to avoid app. server https handling.|false|boolean|
|validateCertificates|Sets client's certificate validation mode. Value false makes SSL vulnerable and is not recommended for the production environment.|true|boolean|
