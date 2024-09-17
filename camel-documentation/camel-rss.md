# Rss

**Since Camel 2.0**

**Only consumer is supported**

The RSS component is used for polling RSS feeds. By default, Camel will
poll the feed every 60th second.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-rss</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

The component currently only supports consuming feeds.

# URI format

    rss:rssUri

Where `rssUri` is the URI to the RSS feed to poll.

# Usage

## Exchange data types

Camel initializes the In body on the Exchange with a ROME `SyndFeed`.
Depending on the value of the `splitEntries` flag, Camel returns either
a `SyndFeed` with one `SyndEntry` or a `java.util.List` of `SyndEntrys`.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Value</th>
<th style="text-align: left;">Behavior</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>splitEntries</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>A single entry from the current feed is
set in the exchange.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>splitEntries</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>The entire list of entries from the
current feed is set in the exchange.</p></td>
</tr>
</tbody>
</table>

# Example

If the URL for the RSS feed uses query parameters, this component will
resolve them. For example, if the feed uses `alt=rss`, then the
following example will be resolved:

    from("rss:http://someserver.com/feeds/posts/default?alt=rss&splitEntries=false&delay=1000")
        .to("bean:rss");

## Filtering entries

You can filter out entries using XPath, as shown in the data format
section above. You can also exploit Camel’s Bean Integration to
implement your own conditions. For instance, a filter equivalent to the
XPath example above would be:

    from("rss:file:src/test/data/rss20.xml?splitEntries=true&delay=100")
        .filter().method("myFilterBean", "titleContainsCamel")
            .to("mock:result");

The custom bean for this would be:

    public static class FilterBean {
    
        public boolean titleContainsCamel(@Body SyndFeed feed) {
            SyndEntry firstEntry = (SyndEntry) feed.getEntries().get(0);
            return firstEntry.getTitle().contains("Camel");
        }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|feedUri|The URI to the feed to poll.||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|sortEntries|Sets whether to sort entries by published date. Only works when splitEntries = true.|false|boolean|
|splitEntries|Sets whether or not entries should be sent individually or whether the entire feed should be sent as a single message|true|boolean|
|throttleEntries|Sets whether all entries identified in a single feed poll should be delivered immediately. If true, only one entry is processed per delay. Only applicable when splitEntries = true.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|feedHeader|Sets whether to add the feed object as a header.|true|boolean|
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
