# Slack

**Since Camel 2.16**

**Both producer and consumer are supported**

The Slack component allows you to connect to an instance of
[Slack](http://www.slack.com/) and to send and receive the messages.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-slack</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

To send a message to a channel.

    slack:#channel[?options]

To send a direct message to a Slack user.

    slack:@userID[?options]

# Usage

To send a message contained in the message body, a pre-established
[Slack incoming webhook](https://api.slack.com/incoming-webhooks) must
be configured in Slack.

## Configuring in Spring XML

The SlackComponent with XML must be configured as a Spring bean that
contains the incoming webhook url or the app token for the integration
as a parameter.

    <bean id="slack" class="org.apache.camel.component.slack.SlackComponent">
        <property name="webhookUrl" value="https://hooks.slack.com/services/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"/>
        <property name="token" value="xoxb-12345678901-1234567890123-xxxxxxxxxxxxxxxxxxxxxxxx"/>
    </bean>

for Java, you can configure this using Java code.

## Producer

You can now use a token to send a message instead of WebhookUrl

    from("direct:test")
        .to("slack:#random?token=RAW(<YOUR_TOKEN>)");

You can now use the Slack API model to create blocks. You can read more
about it here [https://api.slack.com/block-kit](https://api.slack.com/block-kit)

        public void testSlackAPIModelMessage() {
            Message message = new Message();
            message.setBlocks(Collections.singletonList(SectionBlock
                    .builder()
                    .text(MarkdownTextObject
                            .builder()
                            .text("*Hello from Camel!*")
                            .build())
                    .build()));
    
            template.sendBody(test, message);
        }

You’ll need to create a Slack app and use it in your workspace.

For token usage, set the *OAuth Token*.

Add the corresponding (`channels:history`, `chat:write`) user token
scopes to your app to grant it permission to write messages in the
corresponding channel. You’ll also need to invite the Bot or User to the
corresponding channel.

For Bot tokens, you’ll need the following permissions:

-   channels:history

-   chat:write

For User tokens, you’ll need the following permissions:

-   channels:history

-   chat:write

## Consumer

You can also use a consumer for messages in a channel

    from("slack://general?token=RAW(<YOUR_TOKEN>)&maxResults=1")
        .to("mock:result");

This way you’ll get the last message from `general` channel. The
consumer will track the timestamp of the last message consumed, and in
the next poll it will consume only newer messages in the channel.

You’ll need to create a Slack app and use it in your workspace.

Use the *User OAuth Token* as token for the consumer endpoint.

Add the corresponding history (`channels:history`, `groups:history`,
`mpim:history` and `im:history`) and read (`channels:read`,
`groups:read`, `mpim:read` and `im:read`) user token scope to your app
to grant it permission to view messages in the corresponding channel.

For Bot tokens, you’ll need the following permissions:

-   channels:history

-   groups:history

-   im:history

-   mpim:history

-   channels:read

-   groups:read

-   im:read

-   mpim:read

For User tokens, you’ll need the following permissions:

-   channels:history

-   groups:history

-   im:history

-   mpim:history

-   channels:read

-   groups:read

-   im:read

-   mpim:read

The `naturalOrder` option allows consuming messages from the oldest to
the newest. Originally, you would get the newest first and consume
backward (`message 3 -> message 2 -> message 1`)

The channel / conversation doesn’t need to be public to read the history
and messages. Use the `conversationType` option to specify the type of
the conversation (`PUBLIC_CHANNEL`,`PRIVATE_CHANNEL`, `MPIM`, `IM`).

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|token|The token to access Slack. This app needs to have channels:history, groups:history, im:history, mpim:history, channels:read, groups:read, im:read and mpim:read permissions. The User OAuth Token is the kind of token needed.||string|
|webhookUrl|The incoming webhook URL||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|channel|The channel name (syntax #name) or slack user (syntax userName) to send a message directly to an user.||string|
|token|The token to access Slack. This app needs to have channels:history, groups:history, im:history, mpim:history, channels:read, groups:read, im:read and mpim:read permissions. The User OAuth Token is the kind of token needed.||string|
|conversationType|Type of conversation|PUBLIC\_CHANNEL|object|
|maxResults|The Max Result for the poll|10|string|
|naturalOrder|Create exchanges in natural order (oldest to newest) or not|false|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|serverUrl|The Server URL of the Slack instance|https://slack.com|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|iconEmoji|Use a Slack emoji as an avatar||string|
|iconUrl|The avatar that the component will use when sending message to a channel or user.||string|
|username|This is the username that the bot will have when sending messages to a channel or user.||string|
|webhookUrl|The incoming webhook URL||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|backoffErrorThreshold|The number of subsequent error polls (failed due some error) that should happen before the backoffMultipler should kick-in.||integer|
|backoffIdleThreshold|The number of subsequent idle polls that should happen before the backoffMultipler should kick-in.||integer|
|backoffMultiplier|To let the scheduled polling consumer backoff if there has been a number of subsequent idles/errors in a row. The multiplier is then the number of polls that will be skipped before the next actual attempt is happening again. When this option is in use then backoffIdleThreshold and/or backoffErrorThreshold must also be configured.||integer|
|delay|Milliseconds before the next poll.|10000|duration|
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
