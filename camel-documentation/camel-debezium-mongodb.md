# Debezium-mongodb

**Since Camel 3.0**

**Only consumer is supported**

The Debezium MongoDB component is wrapper around
[Debezium](https://debezium.io/) using [Debezium
Engine](https://debezium.io/documentation/reference/1.9/development/engine.html),
which enables Change Data Capture from MongoDB database using Debezium
without the need for Kafka or Kafka Connect.

The Debezium MongoDB connector uses MongoDB’s oplog to capture the
changes. The connector works only with the MongoDB replica sets or with
sharded clusters, where each shard is a separate replica set. Therefore,
you will need to have your MongoDB instance running either in replica
set mode or sharded clusters mode.

**Note on handling failures:** per [Debezium Embedded
Engine](https://debezium.io/documentation/reference/1.9/development/engine.html#_handling_failures)
documentation, the engines are actively recording source offsets and
periodically flush these offsets to a persistent storage. Therefore,
when the application is restarted or crashed, the engine will resume
from the last recorded offset. This means that, at normal operation,
your downstream routes will receive each event exactly once. However, in
case of an application crash (not having a graceful shutdown), the
application will resume from the last recorded offset, which may result
in receiving duplicate events immediately after the restart. Therefore,
your downstream routes should be tolerant enough of such a case and
deduplicate events if needed.

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-debezium-mongodb</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    debezium-mongodb:name[?options]

For more information about configuration:
[https://debezium.io/documentation/reference/0.10/operations/embedded.html#engine-properties](https://debezium.io/documentation/reference/0.10/operations/embedded.html#engine-properties)
[https://debezium.io/documentation/reference/0.10/connectors/mongodb.html#connector-properties](https://debezium.io/documentation/reference/0.10/connectors/mongodb.html#connector-properties)

**Note**: Debezium Mongodb uses MongoDB’s oplog to populate the CDC
events, the update events in MongoDB’s oplog don’t have the before or
after states of the changed document, so there’s no way for the Debezium
connector to provide this information, therefore header key
`CamelDebeziumBefore` is not available in this component.

# Message body

The message body if is not `null` (in case of tombstones), it contains
the state of the row after the event occurred as `String` JSON format,
and you can unmarshal using Camel JSON Data Format.

# Examples

## Consuming events

Here is a basic route that you can use to listen to Debezium events from
MongoDB connector:

    from("debezium-mongodb:dbz-test-1?offsetStorageFileName=/usr/offset-file-1.dat&mongodbHosts=rs0/localhost:27017&mongodbUser=debezium&mongodbPassword=dbz&mongodbName=dbserver1&databaseHistoryFileFilename=/usr/history-file-1.dat")
        .log("Event received from Debezium : ${body}")
        .log("    with this identifier ${headers.CamelDebeziumIdentifier}")
        .log("    with these source metadata ${headers.CamelDebeziumSourceMetadata}")
        .log("    the event occurred upon this operation '${headers.CamelDebeziumSourceOperation}'")
        .log("    on this database '${headers.CamelDebeziumSourceMetadata[db]}' and this table '${headers.CamelDebeziumSourceMetadata[table]}'")
        .log("    with the key ${headers.CamelDebeziumKey}")
        .choice()
            .when(header(DebeziumConstants.HEADER_OPERATION).in("c", "u", "r"))
                .unmarshal().json()
                .log("Event received from Debezium : ${body}")
             .end()
        .end();

By default, the component will emit the events in the body String JSON
format in case of `u`, `c` or `r` operations. This can be easily
converted to JSON using Camel JSON Data Format e.g.:
`.unmarshal().json()` like the above example. In case of operation `d`,
the body will be `null`.

This component is a thin wrapper around Debezium Engine as mentioned.
Therefore, before using this component in production, you need to
understand how Debezium works and how configurations can reflect the
expected behavior. This is especially true in regard to [handling
failures](https://debezium.io/documentation/reference/1.8/operations/embedded.html#_handling_failures).

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|additionalProperties|Additional properties for debezium components in case they can't be set directly on the camel configurations (e.g: setting Kafka Connect properties needed by Debezium engine, for example setting KafkaOffsetBackingStore), the properties have to be prefixed with additionalProperties.. E.g: additionalProperties.transactional.id=12345\&additionalProperties.schema.registry.url=http://localhost:8811/avro||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|configuration|Allow pre-configured Configurations to be set.||object|
|internalKeyConverter|The Converter class that should be used to serialize and deserialize key data for offsets. The default is JSON converter.|org.apache.kafka.connect.json.JsonConverter|string|
|internalValueConverter|The Converter class that should be used to serialize and deserialize value data for offsets. The default is JSON converter.|org.apache.kafka.connect.json.JsonConverter|string|
|offsetCommitPolicy|The name of the Java class of the commit policy. It defines when offsets commit has to be triggered based on the number of events processed and the time elapsed since the last commit. This class must implement the interface 'OffsetCommitPolicy'. The default is a periodic commit policy based upon time intervals.||string|
|offsetCommitTimeoutMs|Maximum number of milliseconds to wait for records to flush and partition offset data to be committed to offset storage before cancelling the process and restoring the offset data to be committed in a future attempt. The default is 5 seconds.|5000|duration|
|offsetFlushIntervalMs|Interval at which to try committing offsets. The default is 1 minute.|60000|duration|
|offsetStorage|The name of the Java class that is responsible for persistence of connector offsets.|org.apache.kafka.connect.storage.FileOffsetBackingStore|string|
|offsetStorageFileName|Path to file where offsets are to be stored. Required when offset.storage is set to the FileOffsetBackingStore.||string|
|offsetStoragePartitions|The number of partitions used when creating the offset storage topic. Required when offset.storage is set to the 'KafkaOffsetBackingStore'.||integer|
|offsetStorageReplicationFactor|Replication factor used when creating the offset storage topic. Required when offset.storage is set to the KafkaOffsetBackingStore||integer|
|offsetStorageTopic|The name of the Kafka topic where offsets are to be stored. Required when offset.storage is set to the KafkaOffsetBackingStore.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|captureMode|The method used to capture changes from MongoDB server. Options include: 'change\_streams' to capture changes via MongoDB Change Streams, update events do not contain full documents; 'change\_streams\_update\_full' (the default) to capture changes via MongoDB Change Streams, update events contain full documents|change\_streams\_update\_full|string|
|collectionExcludeList|A comma-separated list of regular expressions or literals that match the collection names for which changes are to be excluded||string|
|collectionIncludeList|A comma-separated list of regular expressions or literals that match the collection names for which changes are to be captured||string|
|converters|Optional list of custom converters that would be used instead of default ones. The converters are defined using '.type' config option and configured using options '.'||string|
|cursorMaxAwaitTimeMs|The maximum processing time in milliseconds to wait for the oplog cursor to process a single poll request||duration|
|customMetricTags|The custom metric tags will accept key-value pairs to customize the MBean object name which should be appended the end of regular name, each key would represent a tag for the MBean object name, and the corresponding value would be the value of that tag the key is. For example: k1=v1,k2=v2||string|
|databaseExcludeList|A comma-separated list of regular expressions or literals that match the database names for which changes are to be excluded||string|
|databaseIncludeList|A comma-separated list of regular expressions or literals that match the database names for which changes are to be captured||string|
|errorsMaxRetries|The maximum number of retries on connection errors before failing (-1 = no limit, 0 = disabled, 0 = num of retries).|-1|integer|
|eventProcessingFailureHandlingMode|Specify how failures during processing of events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its position is raised, causing the connector to be stopped; 'warn' the problematic event and its position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|fieldExcludeList|A comma-separated list of the fully-qualified names of fields that should be excluded from change event message values||string|
|fieldRenames|A comma-separated list of the fully-qualified replacements of fields that should be used to rename fields in change event message values. Fully-qualified replacements for fields are of the form databaseName.collectionName.fieldName.nestedFieldName:newNestedFieldName, where databaseName and collectionName may contain the wildcard () which matches any characters, the colon character (:) is used to determine rename mapping of field.||string|
|heartbeatIntervalMs|Length of an interval in milli-seconds in in which the connector periodically sends heartbeat messages to a heartbeat topic. Use 0 to disable heartbeat messages. Disabled by default.|0ms|duration|
|heartbeatTopicsPrefix|The prefix that is used to name heartbeat topics.Defaults to \_\_debezium-heartbeat.|\_\_debezium-heartbeat|string|
|incrementalSnapshotWatermarkingStrategy|Specify the strategy used for watermarking during an incremental snapshot: 'insert\_insert' both open and close signal is written into signal data collection (default); 'insert\_delete' only open signal is written on signal data collection, the close will delete the relative open signal;|INSERT\_INSERT|string|
|maxBatchSize|Maximum size of each batch of source records. Defaults to 2048.|2048|integer|
|maxQueueSize|Maximum size of the queue for change events read from the database log but not yet recorded or forwarded. Defaults to 8192, and should always be larger than the maximum batch size.|8192|integer|
|maxQueueSizeInBytes|Maximum size of the queue in bytes for change events read from the database log but not yet recorded or forwarded. Defaults to 0. Mean the feature is not enabled|0|integer|
|mongodbAuthsource|Database containing user credentials.|admin|string|
|mongodbConnectionString|Database connection string.||string|
|mongodbConnectTimeoutMs|The connection timeout, given in milliseconds. Defaults to 10 seconds (10,000 ms).|10s|duration|
|mongodbHeartbeatFrequencyMs|The frequency that the cluster monitor attempts to reach each server. Defaults to 10 seconds (10,000 ms).|10s|duration|
|mongodbPassword|Password to be used when connecting to MongoDB, if necessary.||string|
|mongodbPollIntervalMs|Interval for looking for new, removed, or changed replica sets, given in milliseconds. Defaults to 30 seconds (30,000 ms).|30s|duration|
|mongodbServerSelectionTimeoutMs|The server selection timeout, given in milliseconds. Defaults to 10 seconds (10,000 ms).|30s|duration|
|mongodbSocketTimeoutMs|The socket timeout, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|mongodbSslEnabled|Should connector use SSL to connect to MongoDB instances|false|boolean|
|mongodbSslInvalidHostnameAllowed|Whether invalid host names are allowed when using SSL. If true the connection will not prevent man-in-the-middle attacks|false|boolean|
|mongodbUser|Database user for connecting to MongoDB, if necessary.||string|
|notificationEnabledChannels|List of notification channels names that are enabled.||string|
|notificationSinkTopicName|The name of the topic for the notifications. This is required in case 'sink' is in the list of enabled channels||string|
|pollIntervalMs|Time to wait for new change events to appear after receiving no events, given in milliseconds. Defaults to 500 ms.|500ms|duration|
|postProcessors|Optional list of post processors. The processors are defined using '.type' config option and configured using options ''||string|
|provideTransactionMetadata|Enables transaction metadata extraction together with event counting|false|boolean|
|queryFetchSize|The maximum number of records that should be loaded into memory while streaming. A value of '0' uses the default JDBC fetch size.|0|integer|
|retriableRestartConnectorWaitMs|Time to wait before restarting connector after retriable exception occurs. Defaults to 10000ms.|10s|duration|
|schemaHistoryInternalFileFilename|The path to the file that will be used to record the database schema history||string|
|schemaNameAdjustmentMode|Specify how schema names should be adjusted for compatibility with the message converter used by the connector, including: 'avro' replaces the characters that cannot be used in the Avro type name with underscore; 'avro\_unicode' replaces the underscore or characters that cannot be used in the Avro type name with corresponding unicode like \_uxxxx. Note: \_ is an escape sequence like backslash in Java;'none' does not apply any adjustment (default)|none|string|
|signalDataCollection|The name of the data collection that is used to send signals/commands to Debezium. Signaling is disabled when not set.||string|
|signalEnabledChannels|List of channels names that are enabled. Source channel is enabled by default|source|string|
|signalPollIntervalMs|Interval for looking for new signals in registered channels, given in milliseconds. Defaults to 5 seconds.|5s|duration|
|skippedOperations|The comma-separated list of operations to skip during streaming, defined as: 'c' for inserts/create; 'u' for updates; 'd' for deletes, 't' for truncates, and 'none' to indicate nothing skipped. By default, only truncate operations will be skipped.|t|string|
|snapshotCollectionFilterOverrides|This property contains a comma-separated list of ., for which the initial snapshot may be a subset of data present in the data source. The subset would be defined by mongodb filter query specified as value for property snapshot.collection.filter.override..||string|
|snapshotDelayMs|A delay period before a snapshot will begin, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|snapshotFetchSize|The maximum number of records that should be loaded into memory while performing a snapshot.||integer|
|snapshotIncludeCollectionList|This setting must be set to specify a list of tables/collections whose snapshot must be taken on creating or restarting the connector.||string|
|snapshotMaxThreads|The maximum number of threads used to perform the snapshot. Defaults to 1.|1|integer|
|snapshotMode|The criteria for running a snapshot upon startup of the connector. Select one of the following snapshot options: 'initial' (default): If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures the current full state of the configured tables. After the snapshot completes, the connector begins to stream changes from the oplog. 'never': The connector does not run a snapshot. Upon first startup, the connector immediately begins reading from the beginning of the oplog.|initial|string|
|snapshotModeConfigurationBasedSnapshotData|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnDataError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnSchemaError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotSchema|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedStartStream|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the stream should start or not after snapshot.|false|boolean|
|snapshotModeCustomName|When 'snapshot.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'Snapshotter' interface and is called on each app boot to determine whether to do a snapshot.||string|
|sourceinfoStructMaker|The name of the SourceInfoStructMaker class that returns SourceInfo schema and struct.|io.debezium.connector.mongodb.MongoDbSourceInfoStructMaker|string|
|streamingDelayMs|A delay period after the snapshot is completed and the streaming begins, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|tombstonesOnDelete|Whether delete operations should be represented by a delete event and a subsequent tombstone event (true) or only by a delete event (false). Emitting the tombstone event (the default behavior) allows Kafka to completely delete all events pertaining to the given key once the source record got deleted.|false|boolean|
|topicNamingStrategy|The name of the TopicNamingStrategy class that should be used to determine the topic name for data change, schema change, transaction, heartbeat event etc.|io.debezium.schema.SchemaTopicNamingStrategy|string|
|topicPrefix|Topic prefix that identifies and provides a namespace for the particular database server/cluster is capturing changes. The topic prefix should be unique across all other connectors, since it is used as a prefix for all Kafka topic names that receive events emitted by this connector. Only alphanumeric characters, hyphens, dots and underscores must be accepted.||string|
|transactionMetadataFactory|Class to make transaction context \& transaction struct/schemas|io.debezium.pipeline.txmetadata.DefaultTransactionMetadataFactory|string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|Unique name for the connector. Attempting to register again with the same name will fail.||string|
|additionalProperties|Additional properties for debezium components in case they can't be set directly on the camel configurations (e.g: setting Kafka Connect properties needed by Debezium engine, for example setting KafkaOffsetBackingStore), the properties have to be prefixed with additionalProperties.. E.g: additionalProperties.transactional.id=12345\&additionalProperties.schema.registry.url=http://localhost:8811/avro||object|
|internalKeyConverter|The Converter class that should be used to serialize and deserialize key data for offsets. The default is JSON converter.|org.apache.kafka.connect.json.JsonConverter|string|
|internalValueConverter|The Converter class that should be used to serialize and deserialize value data for offsets. The default is JSON converter.|org.apache.kafka.connect.json.JsonConverter|string|
|offsetCommitPolicy|The name of the Java class of the commit policy. It defines when offsets commit has to be triggered based on the number of events processed and the time elapsed since the last commit. This class must implement the interface 'OffsetCommitPolicy'. The default is a periodic commit policy based upon time intervals.||string|
|offsetCommitTimeoutMs|Maximum number of milliseconds to wait for records to flush and partition offset data to be committed to offset storage before cancelling the process and restoring the offset data to be committed in a future attempt. The default is 5 seconds.|5000|duration|
|offsetFlushIntervalMs|Interval at which to try committing offsets. The default is 1 minute.|60000|duration|
|offsetStorage|The name of the Java class that is responsible for persistence of connector offsets.|org.apache.kafka.connect.storage.FileOffsetBackingStore|string|
|offsetStorageFileName|Path to file where offsets are to be stored. Required when offset.storage is set to the FileOffsetBackingStore.||string|
|offsetStoragePartitions|The number of partitions used when creating the offset storage topic. Required when offset.storage is set to the 'KafkaOffsetBackingStore'.||integer|
|offsetStorageReplicationFactor|Replication factor used when creating the offset storage topic. Required when offset.storage is set to the KafkaOffsetBackingStore||integer|
|offsetStorageTopic|The name of the Kafka topic where offsets are to be stored. Required when offset.storage is set to the KafkaOffsetBackingStore.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|captureMode|The method used to capture changes from MongoDB server. Options include: 'change\_streams' to capture changes via MongoDB Change Streams, update events do not contain full documents; 'change\_streams\_update\_full' (the default) to capture changes via MongoDB Change Streams, update events contain full documents|change\_streams\_update\_full|string|
|collectionExcludeList|A comma-separated list of regular expressions or literals that match the collection names for which changes are to be excluded||string|
|collectionIncludeList|A comma-separated list of regular expressions or literals that match the collection names for which changes are to be captured||string|
|converters|Optional list of custom converters that would be used instead of default ones. The converters are defined using '.type' config option and configured using options '.'||string|
|cursorMaxAwaitTimeMs|The maximum processing time in milliseconds to wait for the oplog cursor to process a single poll request||duration|
|customMetricTags|The custom metric tags will accept key-value pairs to customize the MBean object name which should be appended the end of regular name, each key would represent a tag for the MBean object name, and the corresponding value would be the value of that tag the key is. For example: k1=v1,k2=v2||string|
|databaseExcludeList|A comma-separated list of regular expressions or literals that match the database names for which changes are to be excluded||string|
|databaseIncludeList|A comma-separated list of regular expressions or literals that match the database names for which changes are to be captured||string|
|errorsMaxRetries|The maximum number of retries on connection errors before failing (-1 = no limit, 0 = disabled, 0 = num of retries).|-1|integer|
|eventProcessingFailureHandlingMode|Specify how failures during processing of events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its position is raised, causing the connector to be stopped; 'warn' the problematic event and its position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|fieldExcludeList|A comma-separated list of the fully-qualified names of fields that should be excluded from change event message values||string|
|fieldRenames|A comma-separated list of the fully-qualified replacements of fields that should be used to rename fields in change event message values. Fully-qualified replacements for fields are of the form databaseName.collectionName.fieldName.nestedFieldName:newNestedFieldName, where databaseName and collectionName may contain the wildcard () which matches any characters, the colon character (:) is used to determine rename mapping of field.||string|
|heartbeatIntervalMs|Length of an interval in milli-seconds in in which the connector periodically sends heartbeat messages to a heartbeat topic. Use 0 to disable heartbeat messages. Disabled by default.|0ms|duration|
|heartbeatTopicsPrefix|The prefix that is used to name heartbeat topics.Defaults to \_\_debezium-heartbeat.|\_\_debezium-heartbeat|string|
|incrementalSnapshotWatermarkingStrategy|Specify the strategy used for watermarking during an incremental snapshot: 'insert\_insert' both open and close signal is written into signal data collection (default); 'insert\_delete' only open signal is written on signal data collection, the close will delete the relative open signal;|INSERT\_INSERT|string|
|maxBatchSize|Maximum size of each batch of source records. Defaults to 2048.|2048|integer|
|maxQueueSize|Maximum size of the queue for change events read from the database log but not yet recorded or forwarded. Defaults to 8192, and should always be larger than the maximum batch size.|8192|integer|
|maxQueueSizeInBytes|Maximum size of the queue in bytes for change events read from the database log but not yet recorded or forwarded. Defaults to 0. Mean the feature is not enabled|0|integer|
|mongodbAuthsource|Database containing user credentials.|admin|string|
|mongodbConnectionString|Database connection string.||string|
|mongodbConnectTimeoutMs|The connection timeout, given in milliseconds. Defaults to 10 seconds (10,000 ms).|10s|duration|
|mongodbHeartbeatFrequencyMs|The frequency that the cluster monitor attempts to reach each server. Defaults to 10 seconds (10,000 ms).|10s|duration|
|mongodbPassword|Password to be used when connecting to MongoDB, if necessary.||string|
|mongodbPollIntervalMs|Interval for looking for new, removed, or changed replica sets, given in milliseconds. Defaults to 30 seconds (30,000 ms).|30s|duration|
|mongodbServerSelectionTimeoutMs|The server selection timeout, given in milliseconds. Defaults to 10 seconds (10,000 ms).|30s|duration|
|mongodbSocketTimeoutMs|The socket timeout, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|mongodbSslEnabled|Should connector use SSL to connect to MongoDB instances|false|boolean|
|mongodbSslInvalidHostnameAllowed|Whether invalid host names are allowed when using SSL. If true the connection will not prevent man-in-the-middle attacks|false|boolean|
|mongodbUser|Database user for connecting to MongoDB, if necessary.||string|
|notificationEnabledChannels|List of notification channels names that are enabled.||string|
|notificationSinkTopicName|The name of the topic for the notifications. This is required in case 'sink' is in the list of enabled channels||string|
|pollIntervalMs|Time to wait for new change events to appear after receiving no events, given in milliseconds. Defaults to 500 ms.|500ms|duration|
|postProcessors|Optional list of post processors. The processors are defined using '.type' config option and configured using options ''||string|
|provideTransactionMetadata|Enables transaction metadata extraction together with event counting|false|boolean|
|queryFetchSize|The maximum number of records that should be loaded into memory while streaming. A value of '0' uses the default JDBC fetch size.|0|integer|
|retriableRestartConnectorWaitMs|Time to wait before restarting connector after retriable exception occurs. Defaults to 10000ms.|10s|duration|
|schemaHistoryInternalFileFilename|The path to the file that will be used to record the database schema history||string|
|schemaNameAdjustmentMode|Specify how schema names should be adjusted for compatibility with the message converter used by the connector, including: 'avro' replaces the characters that cannot be used in the Avro type name with underscore; 'avro\_unicode' replaces the underscore or characters that cannot be used in the Avro type name with corresponding unicode like \_uxxxx. Note: \_ is an escape sequence like backslash in Java;'none' does not apply any adjustment (default)|none|string|
|signalDataCollection|The name of the data collection that is used to send signals/commands to Debezium. Signaling is disabled when not set.||string|
|signalEnabledChannels|List of channels names that are enabled. Source channel is enabled by default|source|string|
|signalPollIntervalMs|Interval for looking for new signals in registered channels, given in milliseconds. Defaults to 5 seconds.|5s|duration|
|skippedOperations|The comma-separated list of operations to skip during streaming, defined as: 'c' for inserts/create; 'u' for updates; 'd' for deletes, 't' for truncates, and 'none' to indicate nothing skipped. By default, only truncate operations will be skipped.|t|string|
|snapshotCollectionFilterOverrides|This property contains a comma-separated list of ., for which the initial snapshot may be a subset of data present in the data source. The subset would be defined by mongodb filter query specified as value for property snapshot.collection.filter.override..||string|
|snapshotDelayMs|A delay period before a snapshot will begin, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|snapshotFetchSize|The maximum number of records that should be loaded into memory while performing a snapshot.||integer|
|snapshotIncludeCollectionList|This setting must be set to specify a list of tables/collections whose snapshot must be taken on creating or restarting the connector.||string|
|snapshotMaxThreads|The maximum number of threads used to perform the snapshot. Defaults to 1.|1|integer|
|snapshotMode|The criteria for running a snapshot upon startup of the connector. Select one of the following snapshot options: 'initial' (default): If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures the current full state of the configured tables. After the snapshot completes, the connector begins to stream changes from the oplog. 'never': The connector does not run a snapshot. Upon first startup, the connector immediately begins reading from the beginning of the oplog.|initial|string|
|snapshotModeConfigurationBasedSnapshotData|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnDataError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnSchemaError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotSchema|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedStartStream|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the stream should start or not after snapshot.|false|boolean|
|snapshotModeCustomName|When 'snapshot.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'Snapshotter' interface and is called on each app boot to determine whether to do a snapshot.||string|
|sourceinfoStructMaker|The name of the SourceInfoStructMaker class that returns SourceInfo schema and struct.|io.debezium.connector.mongodb.MongoDbSourceInfoStructMaker|string|
|streamingDelayMs|A delay period after the snapshot is completed and the streaming begins, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|tombstonesOnDelete|Whether delete operations should be represented by a delete event and a subsequent tombstone event (true) or only by a delete event (false). Emitting the tombstone event (the default behavior) allows Kafka to completely delete all events pertaining to the given key once the source record got deleted.|false|boolean|
|topicNamingStrategy|The name of the TopicNamingStrategy class that should be used to determine the topic name for data change, schema change, transaction, heartbeat event etc.|io.debezium.schema.SchemaTopicNamingStrategy|string|
|topicPrefix|Topic prefix that identifies and provides a namespace for the particular database server/cluster is capturing changes. The topic prefix should be unique across all other connectors, since it is used as a prefix for all Kafka topic names that receive events emitted by this connector. Only alphanumeric characters, hyphens, dots and underscores must be accepted.||string|
|transactionMetadataFactory|Class to make transaction context \& transaction struct/schemas|io.debezium.pipeline.txmetadata.DefaultTransactionMetadataFactory|string|
