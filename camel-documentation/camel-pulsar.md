# Pulsar

**Since Camel 2.24**

**Both producer and consumer are supported**

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-pulsar</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

# URI format

    pulsar:[persistent|non-persistent]://tenant/namespace/topic

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|authenticationClass|The Authentication FQCN to be used while creating the client from URI||string|
|authenticationParams|The Authentication Parameters to be used while creating the client from URI||string|
|configuration|Allows to pre-configure the Pulsar component with common options that the endpoints will reuse.||object|
|serviceUrl|The Pulsar Service URL to point while creating the client from URI||string|
|ackGroupTimeMillis|Group the consumer acknowledgments for the specified time in milliseconds - defaults to 100|100|integer|
|ackTimeoutMillis|Timeout for unacknowledged messages in milliseconds - defaults to 10000|10000|integer|
|ackTimeoutRedeliveryBackoff|RedeliveryBackoff to use for ack timeout redelivery backoff.||object|
|allowManualAcknowledgement|Whether to allow manual message acknowledgements. If this option is enabled, then messages are not acknowledged automatically after successful route completion. Instead, an instance of PulsarMessageReceipt is stored as a header on the org.apache.camel.Exchange. Messages can then be acknowledged using PulsarMessageReceipt at any time before the ackTimeout occurs.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|consumerName|Name of the consumer when subscription is EXCLUSIVE|sole-consumer|string|
|consumerNamePrefix|Prefix to add to consumer names when a SHARED or FAILOVER subscription is used|cons|string|
|consumerQueueSize|Size of the consumer queue - defaults to 10|10|integer|
|deadLetterTopic|Name of the topic where the messages which fail maxRedeliverCount times will be sent. Note: if not set, default topic name will be topicName-subscriptionName-DLQ||string|
|enableRetry|To enable retry letter topic mode. The default retry letter topic uses this format: topicname-subscriptionname-RETRY|false|boolean|
|keySharedPolicy|Policy to use by consumer when using key-shared subscription type.||string|
|maxRedeliverCount|Maximum number of times that a message will be redelivered before being sent to the dead letter queue. If this value is not set, no Dead Letter Policy will be created||integer|
|messageListener|Whether to use the messageListener interface, or to receive messages using a separate thread pool|true|boolean|
|negativeAckRedeliveryBackoff|RedeliveryBackoff to use for negative ack redelivery backoff.||object|
|negativeAckRedeliveryDelayMicros|Set the negative acknowledgement delay|60000000|integer|
|numberOfConsumers|Number of consumers - defaults to 1|1|integer|
|numberOfConsumerThreads|Number of threads to receive and handle messages when using a separate thread pool|1|integer|
|readCompacted|Enable compacted topic reading.|false|boolean|
|retryLetterTopic|Name of the topic to use in retry mode. Note: if not set, default topic name will be topicName-subscriptionName-RETRY||string|
|subscriptionInitialPosition|Control the initial position in the topic of a newly created subscription. Default is latest message.|LATEST|object|
|subscriptionName|Name of the subscription to use|subs|string|
|subscriptionTopicsMode|Determines to which topics this consumer should be subscribed to - Persistent, Non-Persistent, or both. Only used with pattern subscriptions.|PersistentOnly|object|
|subscriptionType|Type of the subscription EXCLUSIVESHAREDFAILOVERKEY\_SHARED, defaults to EXCLUSIVE|EXCLUSIVE|object|
|topicsPattern|Whether the topic is a pattern (regular expression) that allows the consumer to subscribe to all matching topics in the namespace|false|boolean|
|pulsarMessageReceiptFactory|Provide a factory to create an alternate implementation of PulsarMessageReceipt.||object|
|batcherBuilder|Control batching method used by the producer.|DEFAULT|object|
|batchingEnabled|Control whether automatic batching of messages is enabled for the producer.|true|boolean|
|batchingMaxMessages|The maximum size to batch messages.|1000|integer|
|batchingMaxPublishDelayMicros|The maximum time period within which the messages sent will be batched if batchingEnabled is true.|1000|integer|
|blockIfQueueFull|Whether to block the producing thread if pending messages queue is full or to throw a ProducerQueueIsFullError|false|boolean|
|chunkingEnabled|Control whether chunking of messages is enabled for the producer.|false|boolean|
|compressionType|Compression type to use|NONE|object|
|hashingScheme|Hashing function to use when choosing the partition to use for a particular message|JavaStringHash|string|
|initialSequenceId|The first message published will have a sequence Id of initialSequenceId 1.|-1|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxPendingMessages|Size of the pending massages queue. When the queue is full, by default, any further sends will fail unless blockIfQueueFull=true|1000|integer|
|maxPendingMessagesAcrossPartitions|The maximum number of pending messages for partitioned topics. The maxPendingMessages value will be reduced if (number of partitions maxPendingMessages) exceeds this value. Partitioned topics have a pending message queue for each partition.|50000|integer|
|messageRouter|Custom Message Router to use||object|
|messageRoutingMode|Message Routing Mode to use|RoundRobinPartition|object|
|producerName|Name of the producer. If unset, lets Pulsar select a unique identifier.||string|
|sendTimeoutMs|Send timeout in milliseconds|30000|integer|
|autoConfiguration|The pulsar auto configuration||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|pulsarClient|The pulsar client||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|persistence|Whether the topic is persistent or non-persistent||string|
|tenant|The tenant||string|
|namespace|The namespace||string|
|topic|The topic||string|
|authenticationClass|The Authentication FQCN to be used while creating the client from URI||string|
|authenticationParams|The Authentication Parameters to be used while creating the client from URI||string|
|serviceUrl|The Pulsar Service URL to point while creating the client from URI||string|
|ackGroupTimeMillis|Group the consumer acknowledgments for the specified time in milliseconds - defaults to 100|100|integer|
|ackTimeoutMillis|Timeout for unacknowledged messages in milliseconds - defaults to 10000|10000|integer|
|ackTimeoutRedeliveryBackoff|RedeliveryBackoff to use for ack timeout redelivery backoff.||object|
|allowManualAcknowledgement|Whether to allow manual message acknowledgements. If this option is enabled, then messages are not acknowledged automatically after successful route completion. Instead, an instance of PulsarMessageReceipt is stored as a header on the org.apache.camel.Exchange. Messages can then be acknowledged using PulsarMessageReceipt at any time before the ackTimeout occurs.|false|boolean|
|consumerName|Name of the consumer when subscription is EXCLUSIVE|sole-consumer|string|
|consumerNamePrefix|Prefix to add to consumer names when a SHARED or FAILOVER subscription is used|cons|string|
|consumerQueueSize|Size of the consumer queue - defaults to 10|10|integer|
|deadLetterTopic|Name of the topic where the messages which fail maxRedeliverCount times will be sent. Note: if not set, default topic name will be topicName-subscriptionName-DLQ||string|
|enableRetry|To enable retry letter topic mode. The default retry letter topic uses this format: topicname-subscriptionname-RETRY|false|boolean|
|keySharedPolicy|Policy to use by consumer when using key-shared subscription type.||string|
|maxRedeliverCount|Maximum number of times that a message will be redelivered before being sent to the dead letter queue. If this value is not set, no Dead Letter Policy will be created||integer|
|messageListener|Whether to use the messageListener interface, or to receive messages using a separate thread pool|true|boolean|
|negativeAckRedeliveryBackoff|RedeliveryBackoff to use for negative ack redelivery backoff.||object|
|negativeAckRedeliveryDelayMicros|Set the negative acknowledgement delay|60000000|integer|
|numberOfConsumers|Number of consumers - defaults to 1|1|integer|
|numberOfConsumerThreads|Number of threads to receive and handle messages when using a separate thread pool|1|integer|
|readCompacted|Enable compacted topic reading.|false|boolean|
|retryLetterTopic|Name of the topic to use in retry mode. Note: if not set, default topic name will be topicName-subscriptionName-RETRY||string|
|subscriptionInitialPosition|Control the initial position in the topic of a newly created subscription. Default is latest message.|LATEST|object|
|subscriptionName|Name of the subscription to use|subs|string|
|subscriptionTopicsMode|Determines to which topics this consumer should be subscribed to - Persistent, Non-Persistent, or both. Only used with pattern subscriptions.|PersistentOnly|object|
|subscriptionType|Type of the subscription EXCLUSIVESHAREDFAILOVERKEY\_SHARED, defaults to EXCLUSIVE|EXCLUSIVE|object|
|topicsPattern|Whether the topic is a pattern (regular expression) that allows the consumer to subscribe to all matching topics in the namespace|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|batcherBuilder|Control batching method used by the producer.|DEFAULT|object|
|batchingEnabled|Control whether automatic batching of messages is enabled for the producer.|true|boolean|
|batchingMaxMessages|The maximum size to batch messages.|1000|integer|
|batchingMaxPublishDelayMicros|The maximum time period within which the messages sent will be batched if batchingEnabled is true.|1000|integer|
|blockIfQueueFull|Whether to block the producing thread if pending messages queue is full or to throw a ProducerQueueIsFullError|false|boolean|
|chunkingEnabled|Control whether chunking of messages is enabled for the producer.|false|boolean|
|compressionType|Compression type to use|NONE|object|
|hashingScheme|Hashing function to use when choosing the partition to use for a particular message|JavaStringHash|string|
|initialSequenceId|The first message published will have a sequence Id of initialSequenceId 1.|-1|integer|
|maxPendingMessages|Size of the pending massages queue. When the queue is full, by default, any further sends will fail unless blockIfQueueFull=true|1000|integer|
|maxPendingMessagesAcrossPartitions|The maximum number of pending messages for partitioned topics. The maxPendingMessages value will be reduced if (number of partitions maxPendingMessages) exceeds this value. Partitioned topics have a pending message queue for each partition.|50000|integer|
|messageRouter|Custom Message Router to use||object|
|messageRoutingMode|Message Routing Mode to use|RoundRobinPartition|object|
|producerName|Name of the producer. If unset, lets Pulsar select a unique identifier.||string|
|sendTimeoutMs|Send timeout in milliseconds|30000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
