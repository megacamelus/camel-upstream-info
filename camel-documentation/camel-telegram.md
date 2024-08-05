# Telegram

**Since Camel 2.18**

**Both producer and consumer are supported**

The Telegram component provides access to the [Telegram Bot
API](https://core.telegram.org/bots/api). It allows a Camel-based
application to send and receive messages by acting as a Bot,
participating in direct conversations with normal users, private and
public groups or channels.

A Telegram Bot must be created before using this component, following
the instructions at the [Telegram Bot developers
home](https://core.telegram.org/bots#3-how-do-i-create-a-bot). When a
new Bot is created, the [BotFather](https://telegram.me/botfather)
provides an **authorization token** corresponding to the Bot. The
authorization token is a mandatory parameter for the camel-telegram
endpoint.

To allow the Bot to receive all messages exchanged within a group or
channel (not just the ones starting with a */* character), ask the
BotFather to **disable the privacy mode**, using the **/setprivacy**
command.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-telegram</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    telegram:type[?options]

# Usage

The Telegram component supports both consumer and producer endpoints. It
can also be used in **reactive chatbot mode** (to consume, then produce
messages).

# Producer Example

The following is a basic example of how to send a message to a Telegram
chat through the Telegram Bot API.

in Java DSL

    from("direct:start").to("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere");

or in Spring XML

    <route>
        <from uri="direct:start"/>
        <to uri="telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere"/>
    <route>

The code `123456789:insertYourAuthorizationTokenHere` is the
**authorization token** corresponding to the Bot.

When using the producer endpoint without specifying the **chat id**
option, the target chat will be identified using information contained
in the body or headers of the message. The following message bodies are
allowed for a producer endpoint (messages of type `OutgoingXXXMessage`
belong to the package `org.apache.camel.component.telegram.model`)

<table>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>OutgoingTextMessage</code></p></td>
<td style="text-align: left;"><p>To send a text message to a
chat</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>OutgoingPhotoMessage</code></p></td>
<td style="text-align: left;"><p>To send a photo (JPG, PNG) to a
chat</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>OutgoingAudioMessage</code></p></td>
<td style="text-align: left;"><p>To send a mp3 audio to a chat</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>OutgoingVideoMessage</code></p></td>
<td style="text-align: left;"><p>To send a mp4 video to a chat</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>OutgoingDocumentMessage</code></p></td>
<td style="text-align: left;"><p>To send a file to a chat (any media
type)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>OutgoingStickerMessage</code></p></td>
<td style="text-align: left;"><p>To send a sticker to a chat
(WEBP)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>OutgoingAnswerInlineQuery</code></p></td>
<td style="text-align: left;"><p>To send answers to an inline
query</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>EditMessageTextMessage</code></p></td>
<td style="text-align: left;"><p>To edit text and game messages
(editMessageText)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>EditMessageCaptionMessage</code></p></td>
<td style="text-align: left;"><p>To edit captions of messages
(editMessageCaption)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>EditMessageMediaMessage</code></p></td>
<td style="text-align: left;"><p>To edit animation, audio, document,
photo, or video messages. (editMessageMedia)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>EditMessageReplyMarkupMessage</code></p></td>
<td style="text-align: left;"><p>To edit only the reply markup of a
message. (editMessageReplyMarkup)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>EditMessageDelete</code></p></td>
<td style="text-align: left;"><p>To delete a message, including service
messages. (deleteMessage)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>SendLocationMessage</code></p></td>
<td style="text-align: left;"><p>To send a location
(setSendLocation)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>EditMessageLiveLocationMessage</code></p></td>
<td style="text-align: left;"><p>To send changes to a live location
(editMessageLiveLocation)</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>StopMessageLiveLocationMessage</code></p></td>
<td style="text-align: left;"><p>To stop updating a live location
message sent by the bot or via the bot (for inline bots) before
live_period expires (stopMessageLiveLocation)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SendVenueMessage</code></p></td>
<td style="text-align: left;"><p>To send information about a venue
(sendVenue)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>byte[]</code></p></td>
<td style="text-align: left;"><p>To send any media type supported. It
requires the <code>CamelTelegramMediaType</code> header to be set to the
appropriate media type</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>To send a text message to a chat. It
gets converted automatically into a
<code>OutgoingTextMessage</code></p></td>
</tr>
</tbody>
</table>

# Consumer Example

The following is a basic example of how to receive all messages that
telegram users are sending to the configured Bot. In Java DSL

    from("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere")
    .bean(ProcessorBean.class)

or in Spring XML

    <route>
        <from uri="telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere"/>
        <bean ref="myBean" />
    <route>
    
    <bean id="myBean" class="com.example.MyBean"/>

The `MyBean` is a simple bean that will receive the messages

    public class MyBean {
    
        public void process(String message) {
            // or Exchange, or org.apache.camel.component.telegram.model.IncomingMessage (or both)
    
            // do process
        }
    
    }

Supported types for incoming messages are

<table>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Java Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>IncomingMessage</code></p></td>
<td style="text-align: left;"><p>The full object representation of an
incoming message</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The content of the message, for text
messages only</p></td>
</tr>
</tbody>
</table>

# Reactive Chat-Bot Example

The reactive chatbot mode is a simple way of using the Camel component
to build a simple chatbot that replies directly to chat messages
received from the Telegram users.

The following is a basic configuration of the chatbot in Java DSL

    from("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere")
    .bean(ChatBotLogic.class)
    .to("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere");

or in Spring XML

    <route>
        <from uri="telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere"/>
        <bean ref="chatBotLogic" />
        <to uri="telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere"/>
    <route>
    
    <bean id="chatBotLogic" class="com.example.ChatBotLogic"/>

The `ChatBotLogic` is a simple bean that implements a generic
String-to-String method.

    public class ChatBotLogic {
    
        public String chatBotProcess(String message) {
            if( "do-not-reply".equals(message) ) {
                return null; // no response in the chat
            }
    
            return "echo from the bot: " + message; // echoes the message
        }
    
    }

Every non-null string returned by the `chatBotProcess` method is
automatically routed to the chat that originated the request (as the
`CamelTelegramChatId` header is used to route the message).

# Getting the Chat ID

If you want to push messages to a specific Telegram chat when an event
occurs, you need to retrieve the corresponding chat ID. The chat ID is
not currently shown in the telegram client, but you can obtain it using
a simple route.

First, add the bot to the chat where you want to push messages, then run
a route like the following one.

    from("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere")
    .to("log:INFO?showHeaders=true");

Any message received by the bot will be dumped to your log together with
information about the chat (`CamelTelegramChatId` header).

Once you get the chat ID, you can use the following sample route to push
a message to it.

    from("timer:tick")
    .setBody().constant("Hello")
    to("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere&chatId=123456")

Note that the corresponding URI parameter is simply `chatId`.

# Customizing keyboard

You can customize the user keyboard instead of asking him to write an
option. `OutgoingTextMessage` has the property `ReplyMarkup` which can
be used for such a thing.

    from("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere")
        .process(exchange -> {
    
            OutgoingTextMessage msg = new OutgoingTextMessage();
            msg.setText("Choose one option!");
    
            InlineKeyboardButton buttonOptionOneI = InlineKeyboardButton.builder()
                    .text("Option One - I").build();
    
            InlineKeyboardButton buttonOptionOneII = InlineKeyboardButton.builder()
                    .text("Option One - II").build();
    
            InlineKeyboardButton buttonOptionTwoI = InlineKeyboardButton.builder()
                    .text("Option Two - I").build();
    
            ReplyKeyboardMarkup replyMarkup = ReplyKeyboardMarkup.builder()
                    .keyboard()
                        .addRow(Arrays.asList(buttonOptionOneI, buttonOptionOneII))
                        .addRow(Arrays.asList(buttonOptionTwoI))
                        .close()
                    .oneTimeKeyboard(true)
                    .build();
    
            msg.setReplyMarkup(replyMarkup);
    
            exchange.getIn().setBody(msg);
        })
        .to("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere");

If you want to disable it, the next message must have the property
`removeKeyboard` set on `ReplyKeyboardMarkup` object.

    from("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere")
        .process(exchange -> {
    
            OutgoingTextMessage msg = new OutgoingTextMessage();
            msg.setText("Your answer was accepted!");
    
            ReplyKeyboardMarkup replyMarkup = ReplyKeyboardMarkup.builder()
                    .removeKeyboard(true)
                    .build();
    
            msg.setReplyKeyboardMarkup(replyMarkup);
    
            exchange.getIn().setBody(msg);
        })
        .to("telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere");

# Webhook Mode

The Telegram component supports usage in the **webhook mode** using the
**camel-webhook** component.

To enable webhook mode, users need first to add a REST implementation to
their application. Maven users, for example, can add **netty-http** to
their `pom.xml` file:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-netty-http</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Once done, you need to prepend the webhook URI to the telegram URI you
want to use.

In Java DSL:

    from("webhook:telegram:bots?authorizationToken=123456789:insertYourAuthorizationTokenHere").to("log:info");

Some endpoints will be exposed by your application and Telegram will be
configured to send messages to them. You need to ensure that your server
is exposed to the internet and to pass the right value of the
**camel.component.webhook.configuration.webhook-external-url** property.

Refer to the **camel-webhook** component documentation for instructions
on how to set it.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|baseUri|Can be used to set an alternative base URI, e.g. when you want to test the component against a mock Telegram API|https://api.telegram.org|string|
|client|To use a custom java.net.http.HttpClient||object|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|
|authorizationToken|The default Telegram authorization token to be used when the information is not provided in the endpoints.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|type|The endpoint type. Currently, only the 'bots' type is supported.||string|
|limit|Limit on the number of updates that can be received in a single polling request.|100|integer|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|timeout|Timeout in seconds for long polling. Put 0 for short polling or a bigger number for long polling. Long polling produces shorter response time.|30|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|chatId|The identifier of the chat that will receive the produced messages. Chat ids can be first obtained from incoming messages (eg. when a telegram user starts a conversation with a bot, its client sends automatically a '/start' message containing the chat id). It is an optional parameter, as the chat id can be set dynamically for each outgoing message (using body or headers).||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|baseUri|Can be used to set an alternative base URI, e.g. when you want to test the component against a mock Telegram API||string|
|bufferSize|The initial in-memory buffer size used when transferring data between Camel and AHC Client.|1048576|integer|
|client|To use a custom HttpClient||object|
|proxyHost|HTTP proxy host which could be used when sending out the message.||string|
|proxyPort|HTTP proxy port which could be used when sending out the message.||integer|
|proxyType|HTTP proxy type which could be used when sending out the message.|HTTP|object|
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
|authorizationToken|The authorization token for using the bot (ask the BotFather)||string|
