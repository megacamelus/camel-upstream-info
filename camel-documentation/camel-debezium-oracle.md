# Debezium-oracle

**Since Camel 3.17**

**Only consumer is supported**

The Debezium oracle component is wrapper around
[Debezium](https://debezium.io/) using [Debezium
Engine](https://debezium.io/documentation/reference/1.9/development/engine.html),
that enables Change Data Capture from the Oracle database using Debezium
without the need for Kafka or Kafka Connect.

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
        <artifactId>camel-debezium-oracle</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    debezium-oracle:name[?options]

For more information about configuration:
[https://debezium.io/documentation/reference/0.10/operations/embedded.html#engine-properties](https://debezium.io/documentation/reference/1.18/operations/embedded.html#engine-properties)
[https://debezium.io/documentation/reference/0.10/connectors/oracleql.html#connector-properties](https://debezium.io/documentation/reference/1.18/connectors/oracleql.html#connector-properties)

# Message body

The message body if is not `null` (in case of tombstones), it contains
the state of the row after the event occurred as `Struct` format or
`Map` format if you use the included Type Converter from `Struct` to
`Map`.

Check below for more details.

# Samples

## Consuming events

Here is a basic route that you can use to listen to Debezium events from
oracle connector.

    from("debezium-oracle:dbz-test-1?offsetStorageFileName=/usr/offset-file-1.dat&databaseHostname=localhost&databaseUser=debezium&databasePassword=dbz&databaseServerName=my-app-connector&databaseHistoryFileFilename=/usr/history-file-1.dat")
        .log("Event received from Debezium : ${body}")
        .log("    with this identifier ${headers.CamelDebeziumIdentifier}")
        .log("    with these source metadata ${headers.CamelDebeziumSourceMetadata}")
        .log("    the event occurred upon this operation '${headers.CamelDebeziumSourceOperation}'")
        .log("    on this database '${headers.CamelDebeziumSourceMetadata[db]}' and this table '${headers.CamelDebeziumSourceMetadata[table]}'")
        .log("    with the key ${headers.CamelDebeziumKey}")
        .log("    the previous value is ${headers.CamelDebeziumBefore}")

By default, the component will emit the events in the body and
`CamelDebeziumBefore` header as
[`Struct`](https://kafka.apache.org/22/javadoc/org/apache/kafka/connect/data/Struct.html)
data type, the reasoning behind this, is to perceive the schema
information in case is needed. However, the component as well contains a
[Type Converter](#manual::type-converter.adoc) that converts from
default output type of
[`Struct`](https://kafka.apache.org/22/javadoc/org/apache/kafka/connect/data/Struct.html)
to `Map` in order to leverage Camel’s rich [Data
Format](#manual::data-format.adoc) types which many of them work out of
box with `Map` data type. To use it, you can either add `Map.class` type
when you access the message (e.g.,
`exchange.getIn().getBody(Map.class)`), or you can convert the body
always to `Map` from the route builder by adding
`.convertBodyTo(Map.class)` to your Camel Route DSL after `from`
statement.

We mentioned above the schema, which can be used in case you need to
perform advance data transformation and the schema is needed for that.
If you choose not to convert your body to `Map`, you can obtain the
schema information as
[`Schema`](https://kafka.apache.org/22/javadoc/org/apache/kafka/connect/data/Schema.html)
type from `Struct` like this:

    from("debezium-oracle:[name]?[options]])
        .process(exchange -> {
            final Struct bodyValue = exchange.getIn().getBody(Struct.class);
            final Schema schemaValue = bodyValue.schema();
    
            log.info("Body value is : {}", bodyValue);
            log.info("With Schema : {}", schemaValue);
            log.info("And fields of : {}", schemaValue.fields());
            log.info("Field name has `{}` type", schemaValue.field("name").schema());
        });

This component is a thin wrapper around Debezium Engine as mentioned.
Therefore, before using this component in production, you need to
understand how Debezium works and how configurations can reflect the
expected behavior. This is especially true in regard to [handling
failures](https://debezium.io/documentation/reference/1.9/operations/embedded.html#_handling_failures).

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
|archiveDestinationName|Sets the specific archive log destination as the source for reading archive logs.When not set, the connector will automatically select the first LOCAL and VALID destination.||string|
|archiveLogHours|The number of hours in the past from SYSDATE to mine archive logs. Using 0 mines all available archive logs|0|integer|
|binaryHandlingMode|Specify how binary (blob, binary, etc.) columns should be represented in change events, including: 'bytes' represents binary data as byte array (default); 'base64' represents binary data as base64-encoded string; 'base64-url-safe' represents binary data as base64-url-safe-encoded string; 'hex' represents binary data as hex-encoded (base16) string|bytes|string|
|columnExcludeList|Regular expressions matching columns to exclude from change events||string|
|columnIncludeList|Regular expressions matching columns to include in change events||string|
|columnPropagateSourceType|A comma-separated list of regular expressions matching fully-qualified names of columns that adds the columns original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|converters|Optional list of custom converters that would be used instead of default ones. The converters are defined using '.type' config option and configured using options '.'||string|
|customMetricTags|The custom metric tags will accept key-value pairs to customize the MBean object name which should be appended the end of regular name, each key would represent a tag for the MBean object name, and the corresponding value would be the value of that tag the key is. For example: k1=v1,k2=v2||string|
|databaseConnectionAdapter|The adapter to use when capturing changes from the database. Options include: 'logminer': (the default) to capture changes using native Oracle LogMiner; 'xstream' to capture changes using Oracle XStreams|LogMiner|string|
|databaseDbname|The name of the database from which the connector should capture changes||string|
|databaseHostname|Resolvable hostname or IP address of the database server.||string|
|databaseOutServerName|Name of the XStream Out server to connect to.||string|
|databasePassword|Password of the database user to be used when connecting to the database.||string|
|databasePdbName|Name of the pluggable database when working with a multi-tenant set-up. The CDB name must be given via database.dbname in this case.||string|
|databasePort|Port of the database server.|1528|integer|
|databaseQueryTimeoutMs|Time to wait for a query to execute, given in milliseconds. Defaults to 600 seconds (600,000 ms); zero means there is no limit.|10m|duration|
|databaseUrl|Complete JDBC URL as an alternative to specifying hostname, port and database provided as a way to support alternative connection scenarios.||string|
|databaseUser|Name of the database user to be used when connecting to the database.||string|
|datatypePropagateSourceType|A comma-separated list of regular expressions matching the database-specific data type names that adds the data type's original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|decimalHandlingMode|Specify how DECIMAL and NUMERIC columns should be represented in change events, including: 'precise' (the default) uses java.math.BigDecimal to represent values, which are encoded in the change events using a binary representation and Kafka Connect's 'org.apache.kafka.connect.data.Decimal' type; 'string' uses string to represent values; 'double' represents values using Java's 'double', which may not offer the precision but will be far easier to use in consumers.|precise|string|
|errorsMaxRetries|The maximum number of retries on connection errors before failing (-1 = no limit, 0 = disabled, 0 = num of retries).|-1|integer|
|eventProcessingFailureHandlingMode|Specify how failures during processing of events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its position is raised, causing the connector to be stopped; 'warn' the problematic event and its position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|heartbeatActionQuery|The query executed with every heartbeat.||string|
|heartbeatIntervalMs|Length of an interval in milli-seconds in in which the connector periodically sends heartbeat messages to a heartbeat topic. Use 0 to disable heartbeat messages. Disabled by default.|0ms|duration|
|heartbeatTopicsPrefix|The prefix that is used to name heartbeat topics.Defaults to \_\_debezium-heartbeat.|\_\_debezium-heartbeat|string|
|includeSchemaChanges|Whether the connector should publish changes in the database schema to a Kafka topic with the same name as the database server ID. Each schema change will be recorded using a key that contains the database name and whose value include logical description of the new schema and optionally the DDL statement(s). The default is 'true'. This is independent of how the connector internally records database schema history.|true|boolean|
|includeSchemaComments|Whether the connector parse table and column's comment to metadata object. Note: Enable this option will bring the implications on memory usage. The number and size of ColumnImpl objects is what largely impacts how much memory is consumed by the Debezium connectors, and adding a String to each of them can potentially be quite heavy. The default is 'false'.|false|boolean|
|incrementalSnapshotWatermarkingStrategy|Specify the strategy used for watermarking during an incremental snapshot: 'insert\_insert' both open and close signal is written into signal data collection (default); 'insert\_delete' only open signal is written on signal data collection, the close will delete the relative open signal;|INSERT\_INSERT|string|
|intervalHandlingMode|Specify how INTERVAL columns should be represented in change events, including: 'string' represents values as an exact ISO formatted string; 'numeric' (default) represents values using the inexact conversion into microseconds|numeric|string|
|lobEnabled|When set to 'false', the default, LOB fields will not be captured nor emitted. When set to 'true', the connector will capture LOB fields and emit changes for those fields like any other column type.|false|boolean|
|logMiningArchiveLogOnlyMode|When set to 'false', the default, the connector will mine both archive log and redo logs to emit change events. When set to 'true', the connector will only mine archive logs. There are circumstances where its advantageous to only mine archive logs and accept latency in event emission due to frequent revolving redo logs.|false|boolean|
|logMiningArchiveLogOnlyScnPollIntervalMs|The interval in milliseconds to wait between polls checking to see if the SCN is in the archive logs.|10s|duration|
|logMiningBatchSizeDefault|The starting SCN interval size that the connector will use for reading data from redo/archive logs.|20000|integer|
|logMiningBatchSizeMax|The maximum SCN interval size that this connector will use when reading from redo/archive logs.|100000|integer|
|logMiningBatchSizeMin|The minimum SCN interval size that this connector will try to read from redo/archive logs. Active batch size will be also increased/decreased by this amount for tuning connector throughput when needed.|1000|integer|
|logMiningBufferDropOnStop|When set to true the underlying buffer cache is not retained when the connector is stopped. When set to false (the default), the buffer cache is retained across restarts.|false|boolean|
|logMiningBufferInfinispanCacheEvents|Specifies the XML configuration for the Infinispan 'events' cache||string|
|logMiningBufferInfinispanCacheGlobal|Specifies the XML configuration for the Infinispan 'global' configuration||string|
|logMiningBufferInfinispanCacheProcessedTransactions|Specifies the XML configuration for the Infinispan 'processed-transactions' cache||string|
|logMiningBufferInfinispanCacheSchemaChanges|Specifies the XML configuration for the Infinispan 'schema-changes' cache||string|
|logMiningBufferInfinispanCacheTransactions|Specifies the XML configuration for the Infinispan 'transactions' cache||string|
|logMiningBufferTransactionEventsThreshold|The number of events a transaction can include before the transaction is discarded. This is useful for managing buffer memory and/or space when dealing with very large transactions. Defaults to 0, meaning that no threshold is applied and transactions can have unlimited events.|0|integer|
|logMiningBufferType|The buffer type controls how the connector manages buffering transaction data. memory - Uses the JVM process' heap to buffer all transaction data. infinispan\_embedded - This option uses an embedded Infinispan cache to buffer transaction data and persist it to disk. infinispan\_remote - This option uses a remote Infinispan cluster to buffer transaction data and persist it to disk.|memory|string|
|logMiningFlushTableName|The name of the flush table used by the connector, defaults to LOG\_MINING\_FLUSH.|LOG\_MINING\_FLUSH|string|
|logMiningIncludeRedoSql|When enabled, the transaction log REDO SQL will be included in the source information block.|false|boolean|
|logMiningQueryFilterMode|Specifies how the filter configuration is applied to the LogMiner database query. none - The query does not apply any schema or table filters, all filtering is at runtime by the connector. in - The query uses SQL in-clause expressions to specify the schema or table filters. regex - The query uses Oracle REGEXP\_LIKE expressions to specify the schema or table filters.|none|string|
|logMiningRestartConnection|Debezium opens a database connection and keeps that connection open throughout the entire streaming phase. In some situations, this can lead to excessive SGA memory usage. By setting this option to 'true' (the default is 'false'), the connector will close and re-open a database connection after every detected log switch or if the log.mining.session.max.ms has been reached.|false|boolean|
|logMiningScnGapDetectionGapSizeMin|Used for SCN gap detection, if the difference between current SCN and previous end SCN is bigger than this value, and the time difference of current SCN and previous end SCN is smaller than log.mining.scn.gap.detection.time.interval.max.ms, consider it a SCN gap.|1000000|integer|
|logMiningScnGapDetectionTimeIntervalMaxMs|Used for SCN gap detection, if the difference between current SCN and previous end SCN is bigger than log.mining.scn.gap.detection.gap.size.min, and the time difference of current SCN and previous end SCN is smaller than this value, consider it a SCN gap.|20s|duration|
|logMiningSessionMaxMs|The maximum number of milliseconds that a LogMiner session lives for before being restarted. Defaults to 0 (indefinite until a log switch occurs)|0ms|duration|
|logMiningSleepTimeDefaultMs|The amount of time that the connector will sleep after reading data from redo/archive logs and before starting reading data again. Value is in milliseconds.|1s|duration|
|logMiningSleepTimeIncrementMs|The maximum amount of time that the connector will use to tune the optimal sleep time when reading data from LogMiner. Value is in milliseconds.|200ms|duration|
|logMiningSleepTimeMaxMs|The maximum amount of time that the connector will sleep after reading data from redo/archive logs and before starting reading data again. Value is in milliseconds.|3s|duration|
|logMiningSleepTimeMinMs|The minimum amount of time that the connector will sleep after reading data from redo/archive logs and before starting reading data again. Value is in milliseconds.|0ms|duration|
|logMiningStrategy|There are strategies: Online catalog with faster mining but no captured DDL. Another - with data dictionary loaded into REDO LOG files|redo\_log\_catalog|string|
|logMiningTransactionRetentionMs|Duration in milliseconds to keep long running transactions in transaction buffer between log mining sessions. By default, all transactions are retained.|0ms|duration|
|logMiningUsernameExcludeList|Comma separated list of usernames to exclude from LogMiner query.||string|
|logMiningUsernameIncludeList|Comma separated list of usernames to include from LogMiner query.||string|
|maxBatchSize|Maximum size of each batch of source records. Defaults to 2048.|2048|integer|
|maxQueueSize|Maximum size of the queue for change events read from the database log but not yet recorded or forwarded. Defaults to 8192, and should always be larger than the maximum batch size.|8192|integer|
|maxQueueSizeInBytes|Maximum size of the queue in bytes for change events read from the database log but not yet recorded or forwarded. Defaults to 0. Mean the feature is not enabled|0|integer|
|messageKeyColumns|A semicolon-separated list of expressions that match fully-qualified tables and column(s) to be used as message key. Each expression must match the pattern ':', where the table names could be defined as (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connector, and the key columns are a comma-separated list of columns representing the custom key. For any table without an explicit key configuration the table's primary key column(s) will be used as message key. Example: dbserver1.inventory.orderlines:orderId,orderLineId;dbserver1.inventory.orders:id||string|
|notificationEnabledChannels|List of notification channels names that are enabled.||string|
|notificationSinkTopicName|The name of the topic for the notifications. This is required in case 'sink' is in the list of enabled channels||string|
|openlogreplicatorHost|The hostname of the OpenLogReplicator network service||string|
|openlogreplicatorPort|The port of the OpenLogReplicator network service||integer|
|openlogreplicatorSource|The configured logical source name in the OpenLogReplicator configuration that is to stream changes||string|
|pollIntervalMs|Time to wait for new change events to appear after receiving no events, given in milliseconds. Defaults to 500 ms.|500ms|duration|
|postProcessors|Optional list of post processors. The processors are defined using '.type' config option and configured using options ''||string|
|provideTransactionMetadata|Enables transaction metadata extraction together with event counting|false|boolean|
|queryFetchSize|The maximum number of records that should be loaded into memory while streaming. A value of '0' uses the default JDBC fetch size, defaults to '2000'.|10000|integer|
|racNodes|A comma-separated list of RAC node hostnames or ip addresses||string|
|retriableRestartConnectorWaitMs|Time to wait before restarting connector after retriable exception occurs. Defaults to 10000ms.|10s|duration|
|schemaHistoryInternal|The name of the SchemaHistory class that should be used to store and recover database schema changes. The configuration properties for the history are prefixed with the 'schema.history.internal.' string.|io.debezium.storage.kafka.history.KafkaSchemaHistory|string|
|schemaHistoryInternalFileFilename|The path to the file that will be used to record the database schema history||string|
|schemaHistoryInternalSkipUnparseableDdl|Controls the action Debezium will take when it meets a DDL statement in binlog, that it cannot parse.By default the connector will stop operating but by changing the setting it can ignore the statements which it cannot parse. If skipping is enabled then Debezium can miss metadata changes.|false|boolean|
|schemaHistoryInternalStoreOnlyCapturedDatabasesDdl|Controls what DDL will Debezium store in database schema history. By default (true) only DDL that manipulates a table from captured schema/database will be stored. If set to false, then Debezium will store all incoming DDL statements.|false|boolean|
|schemaHistoryInternalStoreOnlyCapturedTablesDdl|Controls what DDL will Debezium store in database schema history. By default (false) Debezium will store all incoming DDL statements. If set to true, then only DDL that manipulates a captured table will be stored.|false|boolean|
|schemaNameAdjustmentMode|Specify how schema names should be adjusted for compatibility with the message converter used by the connector, including: 'avro' replaces the characters that cannot be used in the Avro type name with underscore; 'avro\_unicode' replaces the underscore or characters that cannot be used in the Avro type name with corresponding unicode like \_uxxxx. Note: \_ is an escape sequence like backslash in Java;'none' does not apply any adjustment (default)|none|string|
|signalDataCollection|The name of the data collection that is used to send signals/commands to Debezium. Signaling is disabled when not set.||string|
|signalEnabledChannels|List of channels names that are enabled. Source channel is enabled by default|source|string|
|signalPollIntervalMs|Interval for looking for new signals in registered channels, given in milliseconds. Defaults to 5 seconds.|5s|duration|
|skippedOperations|The comma-separated list of operations to skip during streaming, defined as: 'c' for inserts/create; 'u' for updates; 'd' for deletes, 't' for truncates, and 'none' to indicate nothing skipped. By default, only truncate operations will be skipped.|t|string|
|snapshotDatabaseErrorsMaxRetries|The number of attempts to retry database errors during snapshots before failing.|0|integer|
|snapshotDelayMs|A delay period before a snapshot will begin, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|snapshotFetchSize|The maximum number of records that should be loaded into memory while performing a snapshot.||integer|
|snapshotIncludeCollectionList|This setting must be set to specify a list of tables/collections whose snapshot must be taken on creating or restarting the connector.||string|
|snapshotLockingMode|Controls how the connector holds locks on tables while performing the schema snapshot. The default is 'shared', which means the connector will hold a table lock that prevents exclusive table access for just the initial portion of the snapshot while the database schemas and other metadata are being read. The remaining work in a snapshot involves selecting all rows from each table, and this is done using a flashback query that requires no locks. However, in some cases it may be desirable to avoid locks entirely which can be done by specifying 'none'. This mode is only safe to use if no schema changes are happening while the snapshot is taken.|shared|string|
|snapshotLockTimeoutMs|The maximum number of millis to wait for table locks at the beginning of a snapshot. If locks cannot be acquired in this time frame, the snapshot will be aborted. Defaults to 10 seconds|10s|duration|
|snapshotMaxThreads|The maximum number of threads used to perform the snapshot. Defaults to 1.|1|integer|
|snapshotMode|The criteria for running a snapshot upon startup of the connector. Select one of the following snapshot options: 'always': The connector runs a snapshot every time that it starts. After the snapshot completes, the connector begins to stream changes from the redo logs.; 'initial' (default): If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures the current full state of the configured tables. After the snapshot completes, the connector begins to stream changes from the redo logs. 'initial\_only': The connector performs a snapshot as it does for the 'initial' option, but after the connector completes the snapshot, it stops, and does not stream changes from the redo logs.; 'schema\_only': If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures only the schema (table structures), but not any table data. After the snapshot completes, the connector begins to stream changes from the redo logs.; 'schema\_only\_recovery': The connector performs a snapshot that captures only the database schema history. The connector then transitions to streaming from the redo logs. Use this setting to restore a corrupted or lost database schema history topic. Do not use if the database schema was modified after the connector stopped.|initial|string|
|snapshotModeConfigurationBasedSnapshotData|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnDataError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnSchemaError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotSchema|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedStartStream|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the stream should start or not after snapshot.|false|boolean|
|snapshotModeCustomName|When 'snapshot.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'Snapshotter' interface and is called on each app boot to determine whether to do a snapshot.||string|
|snapshotSelectStatementOverrides|This property contains a comma-separated list of fully-qualified tables (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connectors. Select statements for the individual tables are specified in further configuration properties, one for each table, identified by the id 'snapshot.select.statement.overrides.DB\_NAME.TABLE\_NAME' or 'snapshot.select.statement.overrides.SCHEMA\_NAME.TABLE\_NAME', respectively. The value of those properties is the select statement to use when retrieving data from the specific table during snapshotting. A possible use case for large append-only tables is setting a specific point where to start (resume) snapshotting, in case a previous snapshotting was interrupted.||string|
|snapshotTablesOrderByRowCount|Controls the order in which tables are processed in the initial snapshot. A descending value will order the tables by row count descending. A ascending value will order the tables by row count ascending. A value of disabled (the default) will disable ordering by row count.|disabled|string|
|sourceinfoStructMaker|The name of the SourceInfoStructMaker class that returns SourceInfo schema and struct.|io.debezium.connector.oracle.OracleSourceInfoStructMaker|string|
|streamingDelayMs|A delay period after the snapshot is completed and the streaming begins, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|tableExcludeList|A comma-separated list of regular expressions that match the fully-qualified names of tables to be excluded from monitoring||string|
|tableIncludeList|The tables for which changes are to be captured||string|
|timePrecisionMode|Time, date, and timestamps can be represented with different kinds of precisions, including: 'adaptive' (the default) bases the precision of time, date, and timestamp values on the database column's precision; 'adaptive\_time\_microseconds' like 'adaptive' mode, but TIME fields always use microseconds precision; 'connect' always represents time, date, and timestamp values using Kafka Connect's built-in representations for Time, Date, and Timestamp, which uses millisecond precision regardless of the database columns' precision.|adaptive|string|
|tombstonesOnDelete|Whether delete operations should be represented by a delete event and a subsequent tombstone event (true) or only by a delete event (false). Emitting the tombstone event (the default behavior) allows Kafka to completely delete all events pertaining to the given key once the source record got deleted.|false|boolean|
|topicNamingStrategy|The name of the TopicNamingStrategy class that should be used to determine the topic name for data change, schema change, transaction, heartbeat event etc.|io.debezium.schema.SchemaTopicNamingStrategy|string|
|topicPrefix|Topic prefix that identifies and provides a namespace for the particular database server/cluster is capturing changes. The topic prefix should be unique across all other connectors, since it is used as a prefix for all Kafka topic names that receive events emitted by this connector. Only alphanumeric characters, hyphens, dots and underscores must be accepted.||string|
|transactionMetadataFactory|Class to make transaction context \& transaction struct/schemas|io.debezium.pipeline.txmetadata.DefaultTransactionMetadataFactory|string|
|unavailableValuePlaceholder|Specify the constant that will be provided by Debezium to indicate that the original value is unavailable and not provided by the database.|\_\_debezium\_unavailable\_value|string|

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
|archiveDestinationName|Sets the specific archive log destination as the source for reading archive logs.When not set, the connector will automatically select the first LOCAL and VALID destination.||string|
|archiveLogHours|The number of hours in the past from SYSDATE to mine archive logs. Using 0 mines all available archive logs|0|integer|
|binaryHandlingMode|Specify how binary (blob, binary, etc.) columns should be represented in change events, including: 'bytes' represents binary data as byte array (default); 'base64' represents binary data as base64-encoded string; 'base64-url-safe' represents binary data as base64-url-safe-encoded string; 'hex' represents binary data as hex-encoded (base16) string|bytes|string|
|columnExcludeList|Regular expressions matching columns to exclude from change events||string|
|columnIncludeList|Regular expressions matching columns to include in change events||string|
|columnPropagateSourceType|A comma-separated list of regular expressions matching fully-qualified names of columns that adds the columns original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|converters|Optional list of custom converters that would be used instead of default ones. The converters are defined using '.type' config option and configured using options '.'||string|
|customMetricTags|The custom metric tags will accept key-value pairs to customize the MBean object name which should be appended the end of regular name, each key would represent a tag for the MBean object name, and the corresponding value would be the value of that tag the key is. For example: k1=v1,k2=v2||string|
|databaseConnectionAdapter|The adapter to use when capturing changes from the database. Options include: 'logminer': (the default) to capture changes using native Oracle LogMiner; 'xstream' to capture changes using Oracle XStreams|LogMiner|string|
|databaseDbname|The name of the database from which the connector should capture changes||string|
|databaseHostname|Resolvable hostname or IP address of the database server.||string|
|databaseOutServerName|Name of the XStream Out server to connect to.||string|
|databasePassword|Password of the database user to be used when connecting to the database.||string|
|databasePdbName|Name of the pluggable database when working with a multi-tenant set-up. The CDB name must be given via database.dbname in this case.||string|
|databasePort|Port of the database server.|1528|integer|
|databaseQueryTimeoutMs|Time to wait for a query to execute, given in milliseconds. Defaults to 600 seconds (600,000 ms); zero means there is no limit.|10m|duration|
|databaseUrl|Complete JDBC URL as an alternative to specifying hostname, port and database provided as a way to support alternative connection scenarios.||string|
|databaseUser|Name of the database user to be used when connecting to the database.||string|
|datatypePropagateSourceType|A comma-separated list of regular expressions matching the database-specific data type names that adds the data type's original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|decimalHandlingMode|Specify how DECIMAL and NUMERIC columns should be represented in change events, including: 'precise' (the default) uses java.math.BigDecimal to represent values, which are encoded in the change events using a binary representation and Kafka Connect's 'org.apache.kafka.connect.data.Decimal' type; 'string' uses string to represent values; 'double' represents values using Java's 'double', which may not offer the precision but will be far easier to use in consumers.|precise|string|
|errorsMaxRetries|The maximum number of retries on connection errors before failing (-1 = no limit, 0 = disabled, 0 = num of retries).|-1|integer|
|eventProcessingFailureHandlingMode|Specify how failures during processing of events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its position is raised, causing the connector to be stopped; 'warn' the problematic event and its position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|heartbeatActionQuery|The query executed with every heartbeat.||string|
|heartbeatIntervalMs|Length of an interval in milli-seconds in in which the connector periodically sends heartbeat messages to a heartbeat topic. Use 0 to disable heartbeat messages. Disabled by default.|0ms|duration|
|heartbeatTopicsPrefix|The prefix that is used to name heartbeat topics.Defaults to \_\_debezium-heartbeat.|\_\_debezium-heartbeat|string|
|includeSchemaChanges|Whether the connector should publish changes in the database schema to a Kafka topic with the same name as the database server ID. Each schema change will be recorded using a key that contains the database name and whose value include logical description of the new schema and optionally the DDL statement(s). The default is 'true'. This is independent of how the connector internally records database schema history.|true|boolean|
|includeSchemaComments|Whether the connector parse table and column's comment to metadata object. Note: Enable this option will bring the implications on memory usage. The number and size of ColumnImpl objects is what largely impacts how much memory is consumed by the Debezium connectors, and adding a String to each of them can potentially be quite heavy. The default is 'false'.|false|boolean|
|incrementalSnapshotWatermarkingStrategy|Specify the strategy used for watermarking during an incremental snapshot: 'insert\_insert' both open and close signal is written into signal data collection (default); 'insert\_delete' only open signal is written on signal data collection, the close will delete the relative open signal;|INSERT\_INSERT|string|
|intervalHandlingMode|Specify how INTERVAL columns should be represented in change events, including: 'string' represents values as an exact ISO formatted string; 'numeric' (default) represents values using the inexact conversion into microseconds|numeric|string|
|lobEnabled|When set to 'false', the default, LOB fields will not be captured nor emitted. When set to 'true', the connector will capture LOB fields and emit changes for those fields like any other column type.|false|boolean|
|logMiningArchiveLogOnlyMode|When set to 'false', the default, the connector will mine both archive log and redo logs to emit change events. When set to 'true', the connector will only mine archive logs. There are circumstances where its advantageous to only mine archive logs and accept latency in event emission due to frequent revolving redo logs.|false|boolean|
|logMiningArchiveLogOnlyScnPollIntervalMs|The interval in milliseconds to wait between polls checking to see if the SCN is in the archive logs.|10s|duration|
|logMiningBatchSizeDefault|The starting SCN interval size that the connector will use for reading data from redo/archive logs.|20000|integer|
|logMiningBatchSizeMax|The maximum SCN interval size that this connector will use when reading from redo/archive logs.|100000|integer|
|logMiningBatchSizeMin|The minimum SCN interval size that this connector will try to read from redo/archive logs. Active batch size will be also increased/decreased by this amount for tuning connector throughput when needed.|1000|integer|
|logMiningBufferDropOnStop|When set to true the underlying buffer cache is not retained when the connector is stopped. When set to false (the default), the buffer cache is retained across restarts.|false|boolean|
|logMiningBufferInfinispanCacheEvents|Specifies the XML configuration for the Infinispan 'events' cache||string|
|logMiningBufferInfinispanCacheGlobal|Specifies the XML configuration for the Infinispan 'global' configuration||string|
|logMiningBufferInfinispanCacheProcessedTransactions|Specifies the XML configuration for the Infinispan 'processed-transactions' cache||string|
|logMiningBufferInfinispanCacheSchemaChanges|Specifies the XML configuration for the Infinispan 'schema-changes' cache||string|
|logMiningBufferInfinispanCacheTransactions|Specifies the XML configuration for the Infinispan 'transactions' cache||string|
|logMiningBufferTransactionEventsThreshold|The number of events a transaction can include before the transaction is discarded. This is useful for managing buffer memory and/or space when dealing with very large transactions. Defaults to 0, meaning that no threshold is applied and transactions can have unlimited events.|0|integer|
|logMiningBufferType|The buffer type controls how the connector manages buffering transaction data. memory - Uses the JVM process' heap to buffer all transaction data. infinispan\_embedded - This option uses an embedded Infinispan cache to buffer transaction data and persist it to disk. infinispan\_remote - This option uses a remote Infinispan cluster to buffer transaction data and persist it to disk.|memory|string|
|logMiningFlushTableName|The name of the flush table used by the connector, defaults to LOG\_MINING\_FLUSH.|LOG\_MINING\_FLUSH|string|
|logMiningIncludeRedoSql|When enabled, the transaction log REDO SQL will be included in the source information block.|false|boolean|
|logMiningQueryFilterMode|Specifies how the filter configuration is applied to the LogMiner database query. none - The query does not apply any schema or table filters, all filtering is at runtime by the connector. in - The query uses SQL in-clause expressions to specify the schema or table filters. regex - The query uses Oracle REGEXP\_LIKE expressions to specify the schema or table filters.|none|string|
|logMiningRestartConnection|Debezium opens a database connection and keeps that connection open throughout the entire streaming phase. In some situations, this can lead to excessive SGA memory usage. By setting this option to 'true' (the default is 'false'), the connector will close and re-open a database connection after every detected log switch or if the log.mining.session.max.ms has been reached.|false|boolean|
|logMiningScnGapDetectionGapSizeMin|Used for SCN gap detection, if the difference between current SCN and previous end SCN is bigger than this value, and the time difference of current SCN and previous end SCN is smaller than log.mining.scn.gap.detection.time.interval.max.ms, consider it a SCN gap.|1000000|integer|
|logMiningScnGapDetectionTimeIntervalMaxMs|Used for SCN gap detection, if the difference between current SCN and previous end SCN is bigger than log.mining.scn.gap.detection.gap.size.min, and the time difference of current SCN and previous end SCN is smaller than this value, consider it a SCN gap.|20s|duration|
|logMiningSessionMaxMs|The maximum number of milliseconds that a LogMiner session lives for before being restarted. Defaults to 0 (indefinite until a log switch occurs)|0ms|duration|
|logMiningSleepTimeDefaultMs|The amount of time that the connector will sleep after reading data from redo/archive logs and before starting reading data again. Value is in milliseconds.|1s|duration|
|logMiningSleepTimeIncrementMs|The maximum amount of time that the connector will use to tune the optimal sleep time when reading data from LogMiner. Value is in milliseconds.|200ms|duration|
|logMiningSleepTimeMaxMs|The maximum amount of time that the connector will sleep after reading data from redo/archive logs and before starting reading data again. Value is in milliseconds.|3s|duration|
|logMiningSleepTimeMinMs|The minimum amount of time that the connector will sleep after reading data from redo/archive logs and before starting reading data again. Value is in milliseconds.|0ms|duration|
|logMiningStrategy|There are strategies: Online catalog with faster mining but no captured DDL. Another - with data dictionary loaded into REDO LOG files|redo\_log\_catalog|string|
|logMiningTransactionRetentionMs|Duration in milliseconds to keep long running transactions in transaction buffer between log mining sessions. By default, all transactions are retained.|0ms|duration|
|logMiningUsernameExcludeList|Comma separated list of usernames to exclude from LogMiner query.||string|
|logMiningUsernameIncludeList|Comma separated list of usernames to include from LogMiner query.||string|
|maxBatchSize|Maximum size of each batch of source records. Defaults to 2048.|2048|integer|
|maxQueueSize|Maximum size of the queue for change events read from the database log but not yet recorded or forwarded. Defaults to 8192, and should always be larger than the maximum batch size.|8192|integer|
|maxQueueSizeInBytes|Maximum size of the queue in bytes for change events read from the database log but not yet recorded or forwarded. Defaults to 0. Mean the feature is not enabled|0|integer|
|messageKeyColumns|A semicolon-separated list of expressions that match fully-qualified tables and column(s) to be used as message key. Each expression must match the pattern ':', where the table names could be defined as (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connector, and the key columns are a comma-separated list of columns representing the custom key. For any table without an explicit key configuration the table's primary key column(s) will be used as message key. Example: dbserver1.inventory.orderlines:orderId,orderLineId;dbserver1.inventory.orders:id||string|
|notificationEnabledChannels|List of notification channels names that are enabled.||string|
|notificationSinkTopicName|The name of the topic for the notifications. This is required in case 'sink' is in the list of enabled channels||string|
|openlogreplicatorHost|The hostname of the OpenLogReplicator network service||string|
|openlogreplicatorPort|The port of the OpenLogReplicator network service||integer|
|openlogreplicatorSource|The configured logical source name in the OpenLogReplicator configuration that is to stream changes||string|
|pollIntervalMs|Time to wait for new change events to appear after receiving no events, given in milliseconds. Defaults to 500 ms.|500ms|duration|
|postProcessors|Optional list of post processors. The processors are defined using '.type' config option and configured using options ''||string|
|provideTransactionMetadata|Enables transaction metadata extraction together with event counting|false|boolean|
|queryFetchSize|The maximum number of records that should be loaded into memory while streaming. A value of '0' uses the default JDBC fetch size, defaults to '2000'.|10000|integer|
|racNodes|A comma-separated list of RAC node hostnames or ip addresses||string|
|retriableRestartConnectorWaitMs|Time to wait before restarting connector after retriable exception occurs. Defaults to 10000ms.|10s|duration|
|schemaHistoryInternal|The name of the SchemaHistory class that should be used to store and recover database schema changes. The configuration properties for the history are prefixed with the 'schema.history.internal.' string.|io.debezium.storage.kafka.history.KafkaSchemaHistory|string|
|schemaHistoryInternalFileFilename|The path to the file that will be used to record the database schema history||string|
|schemaHistoryInternalSkipUnparseableDdl|Controls the action Debezium will take when it meets a DDL statement in binlog, that it cannot parse.By default the connector will stop operating but by changing the setting it can ignore the statements which it cannot parse. If skipping is enabled then Debezium can miss metadata changes.|false|boolean|
|schemaHistoryInternalStoreOnlyCapturedDatabasesDdl|Controls what DDL will Debezium store in database schema history. By default (true) only DDL that manipulates a table from captured schema/database will be stored. If set to false, then Debezium will store all incoming DDL statements.|false|boolean|
|schemaHistoryInternalStoreOnlyCapturedTablesDdl|Controls what DDL will Debezium store in database schema history. By default (false) Debezium will store all incoming DDL statements. If set to true, then only DDL that manipulates a captured table will be stored.|false|boolean|
|schemaNameAdjustmentMode|Specify how schema names should be adjusted for compatibility with the message converter used by the connector, including: 'avro' replaces the characters that cannot be used in the Avro type name with underscore; 'avro\_unicode' replaces the underscore or characters that cannot be used in the Avro type name with corresponding unicode like \_uxxxx. Note: \_ is an escape sequence like backslash in Java;'none' does not apply any adjustment (default)|none|string|
|signalDataCollection|The name of the data collection that is used to send signals/commands to Debezium. Signaling is disabled when not set.||string|
|signalEnabledChannels|List of channels names that are enabled. Source channel is enabled by default|source|string|
|signalPollIntervalMs|Interval for looking for new signals in registered channels, given in milliseconds. Defaults to 5 seconds.|5s|duration|
|skippedOperations|The comma-separated list of operations to skip during streaming, defined as: 'c' for inserts/create; 'u' for updates; 'd' for deletes, 't' for truncates, and 'none' to indicate nothing skipped. By default, only truncate operations will be skipped.|t|string|
|snapshotDatabaseErrorsMaxRetries|The number of attempts to retry database errors during snapshots before failing.|0|integer|
|snapshotDelayMs|A delay period before a snapshot will begin, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|snapshotFetchSize|The maximum number of records that should be loaded into memory while performing a snapshot.||integer|
|snapshotIncludeCollectionList|This setting must be set to specify a list of tables/collections whose snapshot must be taken on creating or restarting the connector.||string|
|snapshotLockingMode|Controls how the connector holds locks on tables while performing the schema snapshot. The default is 'shared', which means the connector will hold a table lock that prevents exclusive table access for just the initial portion of the snapshot while the database schemas and other metadata are being read. The remaining work in a snapshot involves selecting all rows from each table, and this is done using a flashback query that requires no locks. However, in some cases it may be desirable to avoid locks entirely which can be done by specifying 'none'. This mode is only safe to use if no schema changes are happening while the snapshot is taken.|shared|string|
|snapshotLockTimeoutMs|The maximum number of millis to wait for table locks at the beginning of a snapshot. If locks cannot be acquired in this time frame, the snapshot will be aborted. Defaults to 10 seconds|10s|duration|
|snapshotMaxThreads|The maximum number of threads used to perform the snapshot. Defaults to 1.|1|integer|
|snapshotMode|The criteria for running a snapshot upon startup of the connector. Select one of the following snapshot options: 'always': The connector runs a snapshot every time that it starts. After the snapshot completes, the connector begins to stream changes from the redo logs.; 'initial' (default): If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures the current full state of the configured tables. After the snapshot completes, the connector begins to stream changes from the redo logs. 'initial\_only': The connector performs a snapshot as it does for the 'initial' option, but after the connector completes the snapshot, it stops, and does not stream changes from the redo logs.; 'schema\_only': If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures only the schema (table structures), but not any table data. After the snapshot completes, the connector begins to stream changes from the redo logs.; 'schema\_only\_recovery': The connector performs a snapshot that captures only the database schema history. The connector then transitions to streaming from the redo logs. Use this setting to restore a corrupted or lost database schema history topic. Do not use if the database schema was modified after the connector stopped.|initial|string|
|snapshotModeConfigurationBasedSnapshotData|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnDataError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnSchemaError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotSchema|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedStartStream|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the stream should start or not after snapshot.|false|boolean|
|snapshotModeCustomName|When 'snapshot.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'Snapshotter' interface and is called on each app boot to determine whether to do a snapshot.||string|
|snapshotSelectStatementOverrides|This property contains a comma-separated list of fully-qualified tables (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connectors. Select statements for the individual tables are specified in further configuration properties, one for each table, identified by the id 'snapshot.select.statement.overrides.DB\_NAME.TABLE\_NAME' or 'snapshot.select.statement.overrides.SCHEMA\_NAME.TABLE\_NAME', respectively. The value of those properties is the select statement to use when retrieving data from the specific table during snapshotting. A possible use case for large append-only tables is setting a specific point where to start (resume) snapshotting, in case a previous snapshotting was interrupted.||string|
|snapshotTablesOrderByRowCount|Controls the order in which tables are processed in the initial snapshot. A descending value will order the tables by row count descending. A ascending value will order the tables by row count ascending. A value of disabled (the default) will disable ordering by row count.|disabled|string|
|sourceinfoStructMaker|The name of the SourceInfoStructMaker class that returns SourceInfo schema and struct.|io.debezium.connector.oracle.OracleSourceInfoStructMaker|string|
|streamingDelayMs|A delay period after the snapshot is completed and the streaming begins, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|tableExcludeList|A comma-separated list of regular expressions that match the fully-qualified names of tables to be excluded from monitoring||string|
|tableIncludeList|The tables for which changes are to be captured||string|
|timePrecisionMode|Time, date, and timestamps can be represented with different kinds of precisions, including: 'adaptive' (the default) bases the precision of time, date, and timestamp values on the database column's precision; 'adaptive\_time\_microseconds' like 'adaptive' mode, but TIME fields always use microseconds precision; 'connect' always represents time, date, and timestamp values using Kafka Connect's built-in representations for Time, Date, and Timestamp, which uses millisecond precision regardless of the database columns' precision.|adaptive|string|
|tombstonesOnDelete|Whether delete operations should be represented by a delete event and a subsequent tombstone event (true) or only by a delete event (false). Emitting the tombstone event (the default behavior) allows Kafka to completely delete all events pertaining to the given key once the source record got deleted.|false|boolean|
|topicNamingStrategy|The name of the TopicNamingStrategy class that should be used to determine the topic name for data change, schema change, transaction, heartbeat event etc.|io.debezium.schema.SchemaTopicNamingStrategy|string|
|topicPrefix|Topic prefix that identifies and provides a namespace for the particular database server/cluster is capturing changes. The topic prefix should be unique across all other connectors, since it is used as a prefix for all Kafka topic names that receive events emitted by this connector. Only alphanumeric characters, hyphens, dots and underscores must be accepted.||string|
|transactionMetadataFactory|Class to make transaction context \& transaction struct/schemas|io.debezium.pipeline.txmetadata.DefaultTransactionMetadataFactory|string|
|unavailableValuePlaceholder|Specify the constant that will be provided by Debezium to indicate that the original value is unavailable and not provided by the database.|\_\_debezium\_unavailable\_value|string|
