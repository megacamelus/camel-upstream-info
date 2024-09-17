# Rocketmq

**Since Camel 3.20**

**Both producer and consumer are supported**

The RocketMQ component allows you to produce and consume messages from
[RocketMQ](https://rocketmq.apache.org/) instances.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-rocketmq</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

Since RocketMQ 5.x API is compatible with 4.x, this component works with
both RocketMQ 4.x and 5.x. Users could change RocketMQ dependencies on
their own.

# URI format

    rocketmq:topicName?[options]

The topic name determines the topic to which the produced messages will
be sent to. In the case of consumers, the topic name determines the
topic will be subscribed. This component uses RocketMQ push consumer by
default.

# Usage

## InOut Pattern

InOut Pattern based on Message Key. When the producer sends the message,
a messageKey will be generated and append to the message’s key.

After the message sent, a consumer will listen to the topic configured
by the parameter `ReplyToTopic`.

When a message from `ReplyToTpic` contains the key, it means that the
reply received and continue routing.

If `requestTimeoutMillis` elapsed and no reply received, an exception
will be thrown.

    from("rocketmq:START_TOPIC?producerGroup=p1&consumerGroup=c1")
    
    .to(ExchangePattern.InOut, "rocketmq:INTERMEDIATE_TOPIC" +
            "?producerGroup=intermediaProducer" +
            "&consumerGroup=intermediateConsumer" +
            "&replyToTopic=REPLY_TO_TOPIC" +
            "&replyToConsumerGroup=replyToConsumerGroup" +
            "&requestTimeoutMillis=30000")
    
    .to("log:InOutRoute?showAll=true")

# Examples

Receive messages from a topic named `from_topic`, route to `to_topic`.

    from("rocketmq:FROM_TOPIC?namesrvAddr=localhost:9876&consumerGroup=consumer")
        .to("rocketmq:TO_TOPIC?namesrvAddr=localhost:9876&producerGroup=producer");

Setting specific headers can change routing behaviour. For example, if
header `RocketMQConstants.OVERRIDE_TOPIC_NAME` was set, the message will
be sent to `ACTUAL_TARGET` instead of `ORIGIN_TARGET`.

    from("rocketmq:FROM?consumerGroup=consumer")
            .process(exchange -> {
                exchange.getMessage().setHeader(RocketMQConstants.OVERRIDE_TOPIC_NAME, "ACTUAL_TARGET");
                exchange.getMessage().setHeader(RocketMQConstants.OVERRIDE_TAG, "OVERRIDE_TAG");
                exchange.getMessage().setHeader(RocketMQConstants.OVERRIDE_MESSAGE_KEY, "OVERRIDE_MESSAGE_KEY");
            }
    )
    .to("rocketmq:ORIGIN_TARGET?producerGroup=producer")
    .to("log:RocketRoute?showAll=true")

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|namesrvAddr|Name server address of RocketMQ cluster.|localhost:9876|string|
|sendTag|Each message would be sent with this tag.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|consumerGroup|Consumer group name.||string|
|subscribeTags|Subscribe tags of consumer. Multiple tags could be split by , such as TagATagB|\*|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|producerGroup|Producer group name.||string|
|replyToConsumerGroup|Consumer group name used for receiving response.||string|
|replyToTopic|Topic used for receiving response when using in-out pattern.||string|
|waitForSendResult|Whether waiting for send result before routing to next endpoint.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|requestTimeoutCheckerIntervalMillis|Check interval milliseconds of request timeout.|1000|integer|
|requestTimeoutMillis|Timeout milliseconds of receiving response when using in-out pattern.|10000|integer|
|accessKey|Access key for RocketMQ ACL.||string|
|secretKey|Secret key for RocketMQ ACL.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|topicName|Topic name of this endpoint.||string|
|namesrvAddr|Name server address of RocketMQ cluster.|localhost:9876|string|
|consumerGroup|Consumer group name.||string|
|subscribeTags|Subscribe tags of consumer. Multiple tags could be split by , such as TagATagB|\*|string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|producerGroup|Producer group name.||string|
|replyToConsumerGroup|Consumer group name used for receiving response.||string|
|replyToTopic|Topic used for receiving response when using in-out pattern.||string|
|sendTag|Each message would be sent with this tag.||string|
|waitForSendResult|Whether waiting for send result before routing to next endpoint.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|requestTimeoutCheckerIntervalMillis|Check interval milliseconds of request timeout.|1000|integer|
|requestTimeoutMillis|Timeout milliseconds of receiving response when using in-out pattern.|10000|integer|
|accessKey|Access key for RocketMQ ACL.||string|
|secretKey|Secret key for RocketMQ ACL.||string|
