# Google-pubsub-lite

**Since Camel 4.6**

**Both producer and consumer are supported**

The Google PubSub Lite component provides access to [Cloud Pub/Sub Lite
Infrastructure](https://cloud.google.com/pubsub/) via the [Google Cloud
Pub/Sub Lite Client for
Java](https://github.com/googleapis/java-pubsublite).

The standard [Google Pub/Sub component](#google-pubsub-component.adoc)
isn’t compatible with Pub/Sub Lite service due to API and message model
differences. Please refer to the following links to learn more about
these differences:

-   [Pub/Sub Lite
    Overview](https://cloud.google.com/pubsub/docs/overview#lite)

-   [Choosing between Pub/Sub or Pub/Sub
    Lite](https://cloud.google.com/pubsub/docs/choosing-pubsub-or-lite)

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-google-pubsub-lite</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.x.x</version>
    </dependency>

# URI Format

The Google PubSub Component uses the following URI format:

    google-pubsub-lite://project-id:location:destinationName?[options]

Destination Name can be either a topic or a subscription name.

# Usage

## Producer Endpoints

Google PubSub Lite expects the payload to be `byte[]` array, Producer
endpoints will send:

-   String body as `byte[]` encoded as UTF-8

-   `byte[]` body as is

-   Everything else will be serialised into a `byte[]` array

A Map set as message header `GooglePubsubConstants.ATTRIBUTES` will be
sent as PubSub attributes.

When producing messages set the message header
`GooglePubsubConstants.ORDERING_KEY`. This will be set as the PubSub
Lite orderingKey for the message. You can find more information on
[Using ordering
keys](https://cloud.google.com/pubsub/lite/docs/publishing#using_ordering_keys).

## Consumer Endpoints

Google PubSub Lite will redeliver the message if it has not been
acknowledged within the time period set as a configuration option on the
subscription.

The component will acknowledge the message once exchange processing has
been completed.

## Message Body

The consumer endpoint returns the content of the message as `byte[]` -
exactly as the underlying system sends it. It is up for the route to
convert/unmarshall the contents.

# Examples

You’ll need to provide a connectionFactory to the ActiveMQ Component, to
have the following examples working.

## Producer Example

     from("timer://scheduler?fixedRate=true&period=5s")
                .setBody(simple("Hello World ${date:now:HH:mm:ss.SSS}"))
                .to("google-pubsub-lite:123456789012:europe-west3-a:my-topic-lite")
                .log("Message sent: ${body}");

## Consumer Example

    from("google-pubsub-lite:123456789012:europe-west3-a:my-subscription-lite")
                .log("Message received: ${body}");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|consumerBytesOutstanding|The number of quota bytes that may be outstanding to the client. Must be greater than the allowed size of the largest message (1 MiB).|10485760|integer|
|consumerMessagesOutstanding|The number of messages that may be outstanding to the client. Must be 0.|1000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|publisherCacheSize|Maximum number of producers to cache. This could be increased if you have producers for lots of different topics.|100|integer|
|publisherCacheTimeout|How many milliseconds should each producer stay alive in the cache.|180000|integer|
|publisherTerminationTimeout|How many milliseconds should a producer be allowed to terminate.|60000|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|serviceAccountKey|The Service account key that can be used as credentials for the PubSub Lite publisher/subscriber. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|projectId|The Google Cloud PubSub Lite Project Id||integer|
|location|The Google Cloud PubSub Lite location||string|
|destinationName|The Destination Name. For the consumer this will be the subscription name, while for the producer this will be the topic name.||string|
|loggerId|Logger ID to use when a match to the parent route required||string|
|ackMode|AUTO = exchange gets ack'ed/nack'ed on completion. NONE = downstream process has to ack/nack explicitly|AUTO|object|
|concurrentConsumers|The number of parallel streams consuming from the subscription|1|integer|
|maxAckExtensionPeriod|Set the maximum period a message ack deadline will be extended. Value in seconds|3600|integer|
|maxMessagesPerPoll|The max number of messages to receive from the server in a single API call|1|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|pubsubEndpoint|Pub/Sub endpoint to use. Required when using message ordering, and ensures that messages are received in order even when multiple publishers are used||string|
|serializer|A custom GooglePubsubLiteSerializer to use for serializing message payloads in the producer||object|
|serviceAccountKey|The Service account key that can be used as credentials for the PubSub publisher/subscriber. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
