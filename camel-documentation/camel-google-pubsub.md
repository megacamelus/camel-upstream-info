# Google-pubsub

**Since Camel 2.19**

**Both producer and consumer are supported**

The Google Pubsub component provides access to [Cloud Pub/Sub
Infrastructure](https://cloud.google.com/pubsub/) via the [Google Cloud
Java Client for Google Cloud
Pub/Sub](https://github.com/googleapis/java-pubsub).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-pubsub</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.x.x</version>
    </dependency>

# URI Format

The Google Pubsub Component uses the following URI format:

    google-pubsub://project-id:destinationName?[options]

Destination Name can be either a topic or a subscription name.

# Usage

## Producer Endpoints

Producer endpoints can accept and deliver to PubSub individual and
grouped exchanges alike. Grouped exchanges have
`Exchange.GROUPED_EXCHANGE` property set.

Google PubSub expects the payload to be byte\[\] array, Producer
endpoints will send:

-   String body as `byte[]` encoded as UTF-8

-   `byte[]` body as is

-   Everything else will be serialised into a `byte[]` array

A Map set as message header `GooglePubsubConstants.ATTRIBUTES` will be
sent as PubSub attributes.

Google PubSub supports ordered message delivery.

To enable this, set the options `messageOrderingEnabled` to true, and
the `pubsubEndpoint` to a GCP region.

When producing messages set the message header
`GooglePubsubConstants.ORDERING_KEY` . This will be set as the PubSub
orderingKey for the message.

For more information, see [Ordering
messages](https://cloud.google.com/pubsub/docs/ordering).

Once exchange has been delivered to PubSub the PubSub Message ID will be
assigned to the header `GooglePubsubConstants.MESSAGE_ID`.

## Consumer Endpoints

Google PubSub will redeliver the message if it has not been acknowledged
within the time period set as a configuration option on the
subscription.

The component will acknowledge the message once exchange processing has
been completed.

If the route throws an exception, the exchange is marked as failed, and
the component will NACK the message. It will be redelivered immediately.

To ack/nack the message the component uses Acknowledgement ID stored as
header `GooglePubsubConstants.ACK_ID`. If the header is removed or
tampered with, the ack will fail and the message will be redelivered
again after the ack deadline.

## Message Body

The consumer endpoint returns the content of the message as `byte[]`.
Exactly as the underlying system sends it. It is up for the route to
convert/unmarshall the contents.

## Authentication Configuration

By default, this component acquires credentials using
`GoogleCredentials.getApplicationDefault()`. This behavior can be
disabled by setting *authenticate* option to `false`, in which case
requests to Google API will be made without authentication details. This
is only desirable when developing against an emulator. This behavior can
be altered by supplying a path to a service account key file.

## Rollback and Redelivery

The rollback for Google PubSub relies on the idea of the Acknowledgement
Deadline - the time period where Google PubSub expects to receive the
acknowledgement. If the acknowledgement has not been received, the
message is redelivered.

Google provides an API to extend the deadline for a message.

More information in [Google PubSub
Documentation](https://cloud.google.com/pubsub/docs/subscriber#ack_deadline)

So, rollback is effectively a deadline extension API call with zero
value - i.e., deadline is reached now, and the message can be
redelivered to the next consumer.

It is possible to delay the message redelivery by setting the
acknowledgement deadline explicitly for the rollback by setting the
message header `GooglePubsubConstants.ACK_DEADLINE` to the value in
seconds.

## Manual Acknowledgement

By default, the PubSub consumer will acknowledge messages once the
exchange has been processed, or negative-acknowledge them if the
exchange has failed.

If the *ackMode* option is set to `NONE`, the component will not
acknowledge messages, and it is up to the route to do so. In this case,
a `GooglePubsubAcknowledge` object is stored in the header
`GooglePubsubConstants.GOOGLE_PUBSUB_ACKNOWLEDGE` and can be used to
acknowledge messages:

    from("google-pubsub:{{project.name}}:{{subscription.name}}?ackMode=NONE")
        .process(exchange -> {
            GooglePubsubAcknowledge acknowledge = exchange.getIn().getHeader(GooglePubsubConstants.GOOGLE_PUBSUB_ACKNOWLEDGE, GooglePubsubAcknowledge.class);
            acknowledge.ack(exchange); // or .nack(exchange)
        });

Manual acknowledgement works with both the asynchronous and synchronous
consumers and will use the acknowledgement id which is stored in
`GooglePubsubConstants.ACK_ID`.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|authenticate|Use Credentials when interacting with PubSub service (no authentication is required when using emulator).|true|boolean|
|endpoint|Endpoint to use with local Pub/Sub emulator.||string|
|serviceAccountKey|The Service account key that can be used as credentials for the PubSub publisher/subscriber. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|synchronousPullRetryableCodes|Comma-separated list of additional retryable error codes for synchronous pull. By default the PubSub client library retries ABORTED, UNAVAILABLE, UNKNOWN||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|publisherCacheSize|Maximum number of producers to cache. This could be increased if you have producers for lots of different topics.||integer|
|publisherCacheTimeout|How many milliseconds should each producer stay alive in the cache.||integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|publisherTerminationTimeout|How many milliseconds should a producer be allowed to terminate.||integer|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|projectId|The Google Cloud PubSub Project Id||string|
|destinationName|The Destination Name. For the consumer this will be the subscription name, while for the producer this will be the topic name.||string|
|authenticate|Use Credentials when interacting with PubSub service (no authentication is required when using emulator).|true|boolean|
|loggerId|Logger ID to use when a match to the parent route required||string|
|serviceAccountKey|The Service account key that can be used as credentials for the PubSub publisher/subscriber. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|ackMode|AUTO = exchange gets ack'ed/nack'ed on completion. NONE = downstream process has to ack/nack explicitly|AUTO|object|
|concurrentConsumers|The number of parallel streams consuming from the subscription|1|integer|
|maxAckExtensionPeriod|Set the maximum period a message ack deadline will be extended. Value in seconds|3600|integer|
|maxMessagesPerPoll|The max number of messages to receive from the server in a single API call|1|integer|
|synchronousPull|Synchronously pull batches of messages|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|messageOrderingEnabled|Should message ordering be enabled|false|boolean|
|pubsubEndpoint|Pub/Sub endpoint to use. Required when using message ordering, and ensures that messages are received in order even when multiple publishers are used||string|
|serializer|A custom GooglePubsubSerializer to use for serializing message payloads in the producer||object|
