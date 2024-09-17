# Spring-rabbitmq

**Since Camel 3.8**

**Both producer and consumer are supported**

The Spring RabbitMQ component allows you to produce and consume messages
from [RabbitMQ](http://www.rabbitmq.com/) instances. Using the Spring
RabbitMQ client.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-spring-rabbitmq</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    spring-rabbitmq:exchangeName?[options]

The exchange name determines the exchange to which the produced messages
will be sent to. In the case of consumers, the exchange name determines
the exchange the queue will be bound to.

# Usage

## Using a connection factory

To connect to RabbitMQ, you need to set up a `ConnectionFactory` (same
as with JMS) with the login details such as:

It is recommended to use `CachingConnectionFactory` from spring-rabbit
as it comes with connection pooling out of the box.

    <bean id="rabbitConnectionFactory" class="org.springframework.amqp.rabbit.connection.CachingConnectionFactory">
      <property name="uri" value="amqp://localhost:5672"/>
    </bean>

The `ConnectionFactory` is auto-detected by default, so you can do:

    <camelContext>
      <route>
        <from uri="direct:cheese"/>
        <to uri="spring-rabbitmq:foo?routingKey=cheese"/>
      </route>
    </camelContext>

## Default Exchange Name

To use default exchange name (which would be an empty exchange name in
RabbitMQ) then you should use `default` as name in the endpoint uri,
such as:

    to("spring-rabbitmq:default?routingKey=foo")

## Auto declare exchanges, queues and bindings

Before you can send or receive messages from RabbitMQ, then exchanges,
queues and bindings must be setup first.

In development mode, it may be desirable to let Camel automatic do this.
You can enable this by setting `autoDeclare=true` on the
`SpringRabbitMQComponent`.

Then Spring RabbitMQ will automatically declare the necessary elements
and set up the binding between the exchange, queue and routing keys.

The elements can be configured using the multivalued `args` option.

For example, to specify the queue as durable and exclusive, you can
configure the endpoint uri with
`arg.queue.durable=true&arg.queue.exclusive=true`.

**Exchanges**

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Default</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>autoDelete</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>True if the server should delete the
exchange when it is no longer in use (if all bindings are
deleted).</p></td>
<td style="text-align: left;"><p>false</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>durable</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>A durable exchange will survive a
server restart.</p></td>
<td style="text-align: left;"><p>true</p></td>
</tr>
</tbody>
</table>

You can also configure any additional `x-` arguments. See details in the
RabbitMQ documentation.

**Queues**

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Default</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>autoDelete</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>True if the server should delete the
exchange when it is no longer in use (if all bindings are
deleted).</p></td>
<td style="text-align: left;"><p>false</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>durable</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>A durable queue will survive a server
restart.</p></td>
<td style="text-align: left;"><p>false</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exclusive</p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Whether the queue is exclusive</p></td>
<td style="text-align: left;"><p>false</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>x-dead-letter-exchange</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The name of the dead letter exchange.
If none configured, then the component configured value is
used.</p></td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>x-dead-letter-routing-key</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The routing key for the dead letter
exchange. If none configured, then the component configured value is
used.</p></td>
<td style="text-align: left;"></td>
</tr>
</tbody>
</table>

You can also configure any additional `x-` arguments, such as the
message time to live, via `x-message-ttl`, and many others. See details
in the RabbitMQ documentation.

## Mapping from Camel to RabbitMQ

The message body is mapped from Camel Message body to a `byte[]` which
is the type that RabbitMQ uses for message body. Camel will use its type
converter to convert the message body to a byte array.

Spring Rabbit comes out of the box with support for mapping Java
serialized objects, but Camel Spring RabbitMQ does **not** support this
due to security vulnerabilities and using Java objects is a bad design
as it enforces strong coupling.

Custom message headers are mapped from Camel Message headers to RabbitMQ
headers. This behaviour can be customized by configuring a new
implementation of `HeaderFilterStrategy` on the Camel component.

## Request / Reply

Request and reply messaging is supported using [RabbitMQ direct
reply-to](https://www.rabbitmq.com/direct-reply-to.html).

The example below will do request/reply, where the message is sent via
the cheese exchange name and routing key `foo.bar`, which is being
consumed by the second Camel route, that prepends the message with
\`Hello \`, and then sends back the message.

So if we send `World` as message body to *direct:start* then, we will se
the message being logged

-   `log:request -> World`

-   `log:input -> World`

-   `log:response -> Hello World`

<!-- -->

    from("direct:start")
        .to("log:request")
        .to(ExchangePattern.InOut, "spring-rabbitmq:cheese?routingKey=foo.bar")
        .to("log:response");
    
    from("spring-rabbitmq:cheese?queues=myqueue&routingKey=foo.bar")
        .to("log:input")
        .transform(body().prepend("Hello "));

## Reuse endpoint and send to different destinations computed at runtime

If you need to send messages to a lot of different RabbitMQ exchanges,
it makes sense to reuse an endpoint and specify the real destination in
a message header. This allows Camel to reuse the same endpoint, but send
to different exchanges. This greatly reduces the number of endpoints
created and economizes on memory and thread resources.

Using [toD](#eips:toD-eip.adoc) is easier than specifying the dynamic
destination with headers

You can specify using the following headers:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelSpringRabbitmqExchangeOverrideName</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The exchange name.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelSpringRabbitmqRoutingOverrideKey</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The routing key.</p></td>
</tr>
</tbody>
</table>

For example, the following route shows how you can compute a destination
at run time and use it to override the exchange appearing in the
endpoint URL:

    from("file://inbox")
      .to("bean:computeDestination")
      .to("spring-rabbitmq:dummy");

The exchange name, `dummy`, is just a placeholder. It must be provided
as part of the RabbitMQ endpoint URL, but it will be ignored in this
example.

In the `computeDestination` bean, specify the real destination by
setting the `CamelRabbitmqExchangeOverrideName` header as follows:

    public void setExchangeHeader(Exchange exchange) {
       String region = ....
       exchange.getIn().setHeader("CamelSpringRabbitmqExchangeOverrideName", "order-" + region);
    }

Then Camel will read this header and use it as the exchange name instead
of the one configured on the endpoint. So, in this example Camel sends
the message to `spring-rabbitmq:order-emea`, assuming the `region` value
was `emea`.

Keep in mind that the producer removes both
`CamelSpringRabbitmqExchangeOverrideName` and
`CamelSpringRabbitmqRoutingOverrideKey` headers from the exchange and do
not propagate them to the created Rabbitmq message to avoid the
accidental loops in the routes (in scenarios when the message will be
forwarded to another RabbitMQ endpoint).

## Using toD

If you need to send messages to a lot of different exchanges, it makes
sense to reuse an endpoint and specify the dynamic destinations with
simple language using [toD](#eips:toD-eip.adoc).

For example, suppose you need to send messages to exchanges with order
types, then using toD could, for example, be done as follows:

**Example SJMS2 route with `toD`**

    from("direct:order")
      .toD("spring-rabbit:order-${header.orderType}");

## Manual Acknowledgement

If we need to manually acknowledge a message for some use case, we can
do it by setting and acknowledgeMode to Manual and using the below
snippet of code to get Channel and deliveryTag to manually acknowledge
the message:

    from("spring-rabbitmq:%s?queues=%s&acknowledgeMode=MANUAL")
        .process(exchange -> {
            Channel channel = exchange.getProperty(SpringRabbitMQConstants.CHANNEL, Channel.class);
            long deliveryTag = exchange.getMessage().getHeader(SpringRabbitMQConstants.DELIVERY_TAG, long.class);
            channel.basicAck(deliveryTag, false);
        })

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|amqpAdmin|Optional AMQP Admin service to use for auto declaring elements (queues, exchanges, bindings)||object|
|connectionFactory|The connection factory to be use. A connection factory must be configured either on the component or endpoint.||object|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This ensures that when Camel starts that all the JMS consumers have a valid connection to the JMS broker. If a connection cannot be granted then Camel throws an exception on startup. This ensures that Camel is not started with failed connections. The JMS producers is tested as well.|false|boolean|
|autoDeclare|Specifies whether the consumer should auto declare binding between exchange, queue and routing key when starting. Enabling this can be good for development to make it easy to standup exchanges, queues and bindings on the broker.|true|boolean|
|autoStartup|Specifies whether the consumer container should auto-startup.|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|deadLetterExchange|The name of the dead letter exchange||string|
|deadLetterExchangeType|The type of the dead letter exchange|direct|string|
|deadLetterQueue|The name of the dead letter queue||string|
|deadLetterRoutingKey|The routing key for the dead letter exchange||string|
|maximumRetryAttempts|How many times a Rabbitmq consumer will retry the same message if Camel failed to process the message|5|integer|
|rejectAndDontRequeue|Whether a Rabbitmq consumer should reject the message without requeuing. This enables failed messages to be sent to a Dead Letter Exchange/Queue, if the broker is so configured.|true|boolean|
|retryDelay|Delay in msec a Rabbitmq consumer will wait before redelivering a message that Camel failed to process|1000|integer|
|concurrentConsumers|The number of consumers|1|integer|
|errorHandler|To use a custom ErrorHandler for handling exceptions from the message listener (consumer)||object|
|listenerContainerFactory|To use a custom factory for creating and configuring ListenerContainer to be used by the consumer for receiving messages||object|
|maxConcurrentConsumers|The maximum number of consumers (available only with SMLC)||integer|
|messageListenerContainerType|The type of the MessageListenerContainer|DMLC|string|
|prefetchCount|Tell the broker how many messages to send to each consumer in a single request. Often this can be set quite high to improve throughput.|250|integer|
|retry|Custom retry configuration to use. If this is configured then the other settings such as maximumRetryAttempts for retry are not in use.||object|
|shutdownTimeout|The time to wait for workers in milliseconds after the container is stopped. If any workers are active when the shutdown signal comes they will be allowed to finish processing as long as they can finish within this timeout.|5000|duration|
|allowNullBody|Whether to allow sending messages with no body. If this option is false and the message body is null, then an MessageConversionException is thrown.|false|boolean|
|autoDeclareProducer|Specifies whether the producer should auto declare binding between exchange, queue and routing key when starting. Enabling this can be good for development to make it easy to standup exchanges, queues and bindings on the broker.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|replyTimeout|Specify the timeout in milliseconds to be used when waiting for a reply message when doing request/reply messaging. The default value is 5 seconds. A negative value indicates an indefinite timeout.|5000|duration|
|args|Specify arguments for configuring the different RabbitMQ concepts, a different prefix is required for each element: consumer. exchange. queue. binding. dlq.exchange. dlq.queue. dlq.binding. For example to declare a queue with message ttl argument: queue.x-message-ttl=60000||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|ignoreDeclarationExceptions|Switch on ignore exceptions such as mismatched properties when declaring|false|boolean|
|messageConverter|To use a custom MessageConverter so you can be in control how to map to/from a org.springframework.amqp.core.Message.||object|
|messagePropertiesConverter|To use a custom MessagePropertiesConverter so you can be in control how to map to/from a org.springframework.amqp.core.MessageProperties.||object|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|exchangeName|The exchange name determines the exchange to which the produced messages will be sent to. In the case of consumers, the exchange name determines the exchange the queue will be bound to. Note: to use default exchange then do not use empty name, but use default instead.||string|
|connectionFactory|The connection factory to be use. A connection factory must be configured either on the component or endpoint.||object|
|deadLetterExchange|The name of the dead letter exchange||string|
|deadLetterExchangeType|The type of the dead letter exchange|direct|string|
|deadLetterQueue|The name of the dead letter queue||string|
|deadLetterRoutingKey|The routing key for the dead letter exchange||string|
|disableReplyTo|Specifies whether Camel ignores the ReplyTo header in messages. If true, Camel does not send a reply back to the destination specified in the ReplyTo header. You can use this option if you want Camel to consume from a route and you do not want Camel to automatically send back a reply message because another component in your code handles the reply message. You can also use this option if you want to use Camel as a proxy between different message brokers and you want to route message from one system to another.|false|boolean|
|queues|The queue(s) to use for consuming or producing messages. Multiple queue names can be separated by comma. If none has been configured then Camel will generate an unique id as the queue name.||string|
|routingKey|The value of a routing key to use. Default is empty which is not helpful when using the default (or any direct) exchange, but fine if the exchange is a headers exchange for instance.||string|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This ensures that when Camel starts that all the JMS consumers have a valid connection to the JMS broker. If a connection cannot be granted then Camel throws an exception on startup. This ensures that Camel is not started with failed connections. The JMS producers is tested as well.|false|boolean|
|acknowledgeMode|Flag controlling the behaviour of the container with respect to message acknowledgement. The most common usage is to let the container handle the acknowledgements (so the listener doesn't need to know about the channel or the message). Set to AcknowledgeMode.MANUAL if the listener will send the acknowledgements itself using Channel.basicAck(long, boolean). Manual acks are consistent with either a transactional or non-transactional channel, but if you are doing no other work on the channel at the same other than receiving a single message then the transaction is probably unnecessary. Set to AcknowledgeMode.NONE to tell the broker not to expect any acknowledgements, and it will assume all messages are acknowledged as soon as they are sent (this is autoack in native Rabbit broker terms). If AcknowledgeMode.NONE then the channel cannot be transactional (so the container will fail on start up if that flag is accidentally set).||object|
|asyncConsumer|Whether the consumer processes the Exchange asynchronously. If enabled then the consumer may pickup the next message from the queue, while the previous message is being processed asynchronously (by the Asynchronous Routing Engine). This means that messages may be processed not 100% strictly in order. If disabled (as default) then the Exchange is fully processed before the consumer will pickup the next message from the queue.|false|boolean|
|autoDeclare|Specifies whether the consumer should auto declare binding between exchange, queue and routing key when starting.|true|boolean|
|autoStartup|Specifies whether the consumer container should auto-startup.|true|boolean|
|exchangeType|The type of the exchange|direct|string|
|exclusive|Set to true for an exclusive consumer|false|boolean|
|maximumRetryAttempts|How many times a Rabbitmq consumer will try the same message if Camel failed to process the message (The number of attempts includes the initial try)|5|integer|
|noLocal|Set to true for an no-local consumer|false|boolean|
|rejectAndDontRequeue|Whether a Rabbitmq consumer should reject the message without requeuing. This enables failed messages to be sent to a Dead Letter Exchange/Queue, if the broker is so configured.|true|boolean|
|retryDelay|Delay in millis a Rabbitmq consumer will wait before redelivering a message that Camel failed to process|1000|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|concurrentConsumers|The number of consumers||integer|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|maxConcurrentConsumers|The maximum number of consumers (available only with SMLC)||integer|
|messageListenerContainerType|The type of the MessageListenerContainer|DMLC|string|
|prefetchCount|Tell the broker how many messages to send in a single request. Often this can be set quite high to improve throughput.||integer|
|retry|Custom retry configuration to use. If this is configured then the other settings such as maximumRetryAttempts for retry are not in use.||object|
|allowNullBody|Whether to allow sending messages with no body. If this option is false and the message body is null, then an MessageConversionException is thrown.|false|boolean|
|autoDeclareProducer|Specifies whether the producer should auto declare binding between exchange, queue and routing key when starting.|false|boolean|
|confirm|Controls whether to wait for confirms. The connection factory must be configured for publisher confirms and this method. auto = Camel detects if the connection factory uses confirms or not. disabled = Confirms is disabled. enabled = Confirms is enabled.|auto|string|
|confirmTimeout|Specify the timeout in milliseconds to be used when waiting for a message sent to be confirmed by RabbitMQ when doing send only messaging (InOnly). The default value is 5 seconds. A negative value indicates an indefinite timeout.|5000|duration|
|replyTimeout|Specify the timeout in milliseconds to be used when waiting for a reply message when doing request/reply (InOut) messaging. The default value is 30 seconds. A negative value indicates an indefinite timeout (Beware that this will cause a memory leak if a reply is not received).|30000|duration|
|skipBindQueue|If true the queue will not be bound to the exchange after declaring it.|false|boolean|
|skipDeclareExchange|This can be used if we need to declare the queue but not the exchange.|false|boolean|
|skipDeclareQueue|If true the producer will not declare and bind a queue. This can be used for directing messages via an existing routing key.|false|boolean|
|usePublisherConnection|Use a separate connection for publishers and consumers|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|args|Specify arguments for configuring the different RabbitMQ concepts, a different prefix is required for each element: arg.consumer. arg.exchange. arg.queue. arg.binding. arg.dlq.exchange. arg.dlq.queue. arg.dlq.binding. For example to declare a queue with message ttl argument: args=arg.queue.x-message-ttl=60000||object|
|messageConverter|To use a custom MessageConverter so you can be in control how to map to/from a org.springframework.amqp.core.Message.||object|
|messagePropertiesConverter|To use a custom MessagePropertiesConverter so you can be in control how to map to/from a org.springframework.amqp.core.MessageProperties.||object|
|synchronous|Sets whether synchronous processing should be strictly used|false|boolean|
