# Azure-eventhubs

**Since Camel 3.5**

**Both producer and consumer are supported**

The Azure Event Hubs component provides the capability to produce and
consume events with [Azure Event
Hubs](https://azure.microsoft.com/en-us/services/event-hubs/) using the
[AMQP
protocol](https://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol).
Azure EventHubs is a highly scalable publish-subscribe service that can
ingest millions of events per second and stream them to multiple
consumers.

**Prerequisites**

You must have a valid Microsoft Azure Event Hubs account. More
information is available at the [Azure Documentation
Portal](https://docs.microsoft.com/azure/).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-azure-eventhubs</artifactId>
        <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

    azure-eventhubs://[namespace/eventHubName][?options]

When providing a `connectionString`, the `namespace` and `eventHubName`
options are not required as they are already included in the
`connectionString`

# Usage

## Authentication Information

There are three different Credential Types: `AZURE_IDENTITY`,
`TOKEN_CREDENTIAL` and `CONNECTION_STRING`.

**CONNECTION\_STRING**:

You can either:

-   Provide the `connectionString` option. Using this options means that
    you don’t need to specify additional options `namespace`,
    `eventHubName`, `sharedAccessKey` and `sharedAccessName` , as this
    data is already included within the `connectionString`. Learn more
    [here](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-get-connection-string)
    on how to generate the connection string.

Or

-   Provide `sharedAccessName` and `sharedAccessKey` options for your
    Azure Event Hubs account. The `sharedAccessKey` can be generated
    through the Event Hubs Azure portal. The connection String will then
    be generated automatically for you by the azure-eventhubs component.

**TOKEN\_CREDENTIAL**:

-   Bind an implementation of
    `com.azure.core.credential.TokenCredential` to the Camel Registry
    (see example below). See the documentation [here about Azure-AD
    authentication](https://docs.microsoft.com/en-us/azure/active-directory/authentication/overview-authentication).

**AZURE\_IDENTITY**: - This will use an
`com.azure.identity.DefaultAzureCredentialBuilder().build()` instance.
This will follow the Default Azure Credential Chain. See the
documentation [here about Azure-AD
authentication](https://docs.microsoft.com/en-us/azure/active-directory/authentication/overview-authentication).

**Client instance**:

-   Provide a
    [EventHubProducerAsyncClient](https://docs.microsoft.com/en-us/java/api/com.azure.messaging.eventhubs.eventhubproducerasyncclient?view=azure-java-stable)
    instance which can be used for the `producerAsyncClient` option.
    However, this is **only supported for azure-eventhubs producer**,
    for the consumer, it is not possible to inject the client due to
    some design constraints in the `EventProcessorClient`.

## Checkpoint Store Information

A checkpoint store, stores and retrieves partition ownership information
and checkpoint details for each partition in a given consumer group of
an event hub instance. Users are not meant to implement a
`CheckpointStore`. Users are expected to choose existing implementations
of this interface, instantiate it, and pass it to the component through
the `checkpointStore` option.

When no `CheckpointStore` implementation is provided, the
azure-eventhubs component will fall back to use
[`BlobCheckpointStore`](https://docs.microsoft.com/en-us/javascript/api/@azure/eventhubs-checkpointstore-blob/blobcheckpointstore?view=azure-node-latest)
to store the checkpoint information in the Azure Blob Storage account.
If you chose to use the default `BlobCheckpointStore`, you will need to
supply the following options:

-   `blobAccountName`: The Azure account name to be used for
    authentication with azure blob services.

-   `blobAccessKey`: The access key for the associated azure account
    name to be used for authentication with azure blob services.

-   `blobContainerName`: The name of the blob container that shall be
    used by the BlobCheckpointStore to store the checkpoint offsets.

## Message body type

The azure-eventhubs producer expects the data in the message body to be
of type `byte[]`. This allows the simple messages (E.g. `String` based
ones) to be marshalled /unmarshalled with ease. The same is true for the
azure-eventhubs consumer, it will set the encoded data as `byte[]` in
the message body.

## Automatic detection of EventHubProducerAsyncClient client in the Camel registry

The component is capable of detecting the presence of an
EventHubProducerAsyncClient bean into the registry. If it’s the only
instance of that type, it will be used as the client, and you won’t have
to define it as uri parameter, like the example above. This may be
really useful for smarter configuration of the endpoint.

# Examples

## Consumer Example

To consume events:

    from("azure-eventhubs:/camel/camelHub?sharedAccessName=SASaccountName&sharedAccessKey=SASaccessKey&blobAccountName=accountName&blobAccessKey=accessKey&blobContainerName=containerName")
        .to("file://queuedirectory");

## Producer Example

To produce events:

    from("direct:start")
        .process(exchange -> {
            exchange.getIn().setHeader(EventHubsConstants.PARTITION_ID, firstPartition);
            exchange.getIn().setBody("test event");
        })
        .to("azure-eventhubs:?connectionString=RAW({{connectionString}})"

The azure-eventhubs producer supports sending sending events as an
`Iterable` (E.g. as a `List`). For example:

    from("direct:start")
        .process(exchange -> {
            final List<String> messages = new LinkedList<>();
            messages.add("Test String Message 1");
            messages.add("Test String Message 2");
    
            exchange.getIn().setHeader(EventHubsConstants.PARTITION_ID, firstPartition);
            exchange.getIn().setBody(messages);
        })
        .to("azure-eventhubs:?connectionString=RAW({{connectionString}})"

## Azure-AD Authentication example

The example below makes use of the Azure-AD authentication. See
[here](https://docs.microsoft.com/en-us/java/api/overview/azure/identity-readme?view=azure-java-stable#environment-variables)
about what environment variables you need to set for this to work:

    @BindToRegistry("myTokenCredential")
    public com.azure.core.credential.TokenCredential myTokenCredential() {
        return com.azure.identity.DefaultAzureCredentialBuilder().build();
    }
    
    from("direct:start")
        .to("azure-eventhubs:namespace/eventHubName?tokenCredential=#myTokenCredential&credentialType=TOKEN_CREDENTIAL)"

# Important Development Notes

When developing on this component, you will need to obtain your Azure
accessKey to run the integration tests. In addition to the mocked unit
tests, you **will need to run the integration tests with every change
you make or even client upgrade as the Azure client can break things
even on minor versions upgrade.** To run the integration tests, on this
component directory, run the following maven command:

    mvn verify -DconnectionString=string -DblobAccountName=blob -DblobAccessKey=key

Whereby `blobAccountName` is your Azure account name and `blobAccessKey`
is the access key being generated from Azure portal and
`connectionString` is the eventHub connection string.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|amqpRetryOptions|Sets the retry policy for EventHubProducerAsyncClient. If not specified, the default retry options are used.||object|
|amqpTransportType|Sets the transport type by which all the communication with Azure Event Hubs occurs.|AMQP|object|
|configuration|The component configurations||object|
|blobAccessKey|In case you chose the default BlobCheckpointStore, this sets access key for the associated azure account name to be used for authentication with azure blob services.||string|
|blobAccountName|In case you chose the default BlobCheckpointStore, this sets Azure account name to be used for authentication with azure blob services.||string|
|blobContainerName|In case you chose the default BlobCheckpointStore, this sets the blob container that shall be used by the BlobCheckpointStore to store the checkpoint offsets.||string|
|blobStorageSharedKeyCredential|In case you chose the default BlobCheckpointStore, StorageSharedKeyCredential can be injected to create the azure client, this holds the important authentication information.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|checkpointBatchSize|Sets the batch size between each checkpoint update. Works jointly with checkpointBatchTimeout.|500|integer|
|checkpointBatchTimeout|Sets the batch timeout between each checkpoint update. Works jointly with checkpointBatchSize.|5000|integer|
|checkpointStore|Sets the CheckpointStore the EventProcessorClient will use for storing partition ownership and checkpoint information. Users can, optionally, provide their own implementation of CheckpointStore which will store ownership and checkpoint information. By default, it's set to use com.azure.messaging.eventhubs.checkpointstore.blob.BlobCheckpointStore which stores all checkpoint offsets into Azure Blob Storage.|BlobCheckpointStore|object|
|consumerGroupName|Sets the name of the consumer group this consumer is associated with. Events are read in the context of this group. The name of the consumer group that is created by default is $Default.|$Default|string|
|eventPosition|Sets the map containing the event position to use for each partition if a checkpoint for the partition does not exist in CheckpointStore. This map is keyed off of the partition id. If there is no checkpoint in CheckpointStore and there is no entry in this map, the processing of the partition will start from EventPosition#latest() position.||object|
|prefetchCount|Sets the count used by the receiver to control the number of events the Event Hub consumer will actively receive and queue locally without regard to whether a receive operation is currently active.|500|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|partitionId|Sets the identifier of the Event Hub partition that the EventData events will be sent to. If the identifier is not specified, the Event Hubs service will be responsible for routing events that are sent to an available partition.||string|
|partitionKey|Sets a hashing key to be provided for the batch of events, which instructs the Event Hubs service to map this key to a specific partition. The selection of a partition is stable for a given partition hashing key. Should any other batches of events be sent using the same exact partition hashing key, the Event Hubs service will route them all to the same partition. This should be specified only when there is a need to group events by partition, but there is flexibility into which partition they are routed. If ensuring that a batch of events is sent only to a specific partition, it is recommended that the identifier of the position be specified directly when sending the batch.||string|
|producerAsyncClient|Sets the EventHubProducerAsyncClient.An asynchronous producer responsible for transmitting EventData to a specific Event Hub, grouped together in batches. Depending on the com.azure.messaging.eventhubs.models.CreateBatchOptions options specified when creating an com.azure.messaging.eventhubs.EventDataBatch, the events may be automatically routed to an available partition or specific to a partition. Use by this component to produce the data in camel producer.||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|connectionString|Instead of supplying namespace, sharedAccessKey, sharedAccessName, etc. you can supply the connection string for your eventHub. The connection string for EventHubs already includes all the necessary information to connect to your EventHub. To learn how to generate the connection string, take a look at this documentation: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-get-connection-string||string|
|credentialType|Determines the credential strategy to adopt|CONNECTION\_STRING|object|
|sharedAccessKey|The generated value for the SharedAccessName.||string|
|sharedAccessName|The name you chose for your EventHubs SAS keys.||string|
|tokenCredential|Provide custom authentication credentials using an implementation of TokenCredential.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|namespace|EventHubs namespace created in Azure Portal.||string|
|eventHubName|EventHubs name under a specific namespace.||string|
|amqpRetryOptions|Sets the retry policy for EventHubProducerAsyncClient. If not specified, the default retry options are used.||object|
|amqpTransportType|Sets the transport type by which all the communication with Azure Event Hubs occurs.|AMQP|object|
|blobAccessKey|In case you chose the default BlobCheckpointStore, this sets access key for the associated azure account name to be used for authentication with azure blob services.||string|
|blobAccountName|In case you chose the default BlobCheckpointStore, this sets Azure account name to be used for authentication with azure blob services.||string|
|blobContainerName|In case you chose the default BlobCheckpointStore, this sets the blob container that shall be used by the BlobCheckpointStore to store the checkpoint offsets.||string|
|blobStorageSharedKeyCredential|In case you chose the default BlobCheckpointStore, StorageSharedKeyCredential can be injected to create the azure client, this holds the important authentication information.||object|
|checkpointBatchSize|Sets the batch size between each checkpoint update. Works jointly with checkpointBatchTimeout.|500|integer|
|checkpointBatchTimeout|Sets the batch timeout between each checkpoint update. Works jointly with checkpointBatchSize.|5000|integer|
|checkpointStore|Sets the CheckpointStore the EventProcessorClient will use for storing partition ownership and checkpoint information. Users can, optionally, provide their own implementation of CheckpointStore which will store ownership and checkpoint information. By default, it's set to use com.azure.messaging.eventhubs.checkpointstore.blob.BlobCheckpointStore which stores all checkpoint offsets into Azure Blob Storage.|BlobCheckpointStore|object|
|consumerGroupName|Sets the name of the consumer group this consumer is associated with. Events are read in the context of this group. The name of the consumer group that is created by default is $Default.|$Default|string|
|eventPosition|Sets the map containing the event position to use for each partition if a checkpoint for the partition does not exist in CheckpointStore. This map is keyed off of the partition id. If there is no checkpoint in CheckpointStore and there is no entry in this map, the processing of the partition will start from EventPosition#latest() position.||object|
|prefetchCount|Sets the count used by the receiver to control the number of events the Event Hub consumer will actively receive and queue locally without regard to whether a receive operation is currently active.|500|integer|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|partitionId|Sets the identifier of the Event Hub partition that the EventData events will be sent to. If the identifier is not specified, the Event Hubs service will be responsible for routing events that are sent to an available partition.||string|
|partitionKey|Sets a hashing key to be provided for the batch of events, which instructs the Event Hubs service to map this key to a specific partition. The selection of a partition is stable for a given partition hashing key. Should any other batches of events be sent using the same exact partition hashing key, the Event Hubs service will route them all to the same partition. This should be specified only when there is a need to group events by partition, but there is flexibility into which partition they are routed. If ensuring that a batch of events is sent only to a specific partition, it is recommended that the identifier of the position be specified directly when sending the batch.||string|
|producerAsyncClient|Sets the EventHubProducerAsyncClient.An asynchronous producer responsible for transmitting EventData to a specific Event Hub, grouped together in batches. Depending on the com.azure.messaging.eventhubs.models.CreateBatchOptions options specified when creating an com.azure.messaging.eventhubs.EventDataBatch, the events may be automatically routed to an available partition or specific to a partition. Use by this component to produce the data in camel producer.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|connectionString|Instead of supplying namespace, sharedAccessKey, sharedAccessName, etc. you can supply the connection string for your eventHub. The connection string for EventHubs already includes all the necessary information to connect to your EventHub. To learn how to generate the connection string, take a look at this documentation: https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-get-connection-string||string|
|credentialType|Determines the credential strategy to adopt|CONNECTION\_STRING|object|
|sharedAccessKey|The generated value for the SharedAccessName.||string|
|sharedAccessName|The name you chose for your EventHubs SAS keys.||string|
|tokenCredential|Provide custom authentication credentials using an implementation of TokenCredential.||object|
