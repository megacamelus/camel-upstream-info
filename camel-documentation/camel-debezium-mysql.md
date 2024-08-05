# Debezium-mysql

**Since Camel 3.0**

**Only consumer is supported**

The Debezium MySQL component is wrapper around
[Debezium](https://debezium.io/) using [Debezium
Engine](https://debezium.io/documentation/reference/1.9/development/engine.html),
which enables Change Data Capture from MySQL database using Debezium
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
        <artifactId>camel-debezium-mysql</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    debezium-mysql:name[?options]

Due to licensing issues, you will need to add the dependency for
`mysql-connector-j` if you are using MySQL connector, add the following
to your POM file:

    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <version>8.0.15</version>
    </dependency>

For more information about configuration:
[https://debezium.io/documentation/reference/0.10/operations/embedded.html#engine-properties](https://debezium.io/documentation/reference/0.10/operations/embedded.html#engine-properties)
[https://debezium.io/documentation/reference/0.10/connectors/mysql.html#connector-properties](https://debezium.io/documentation/reference/0.10/connectors/mysql.html#connector-properties)

# Message body

The message body if is not `null` (in case of tombstones), it contains
the state of the row after the event occurred as `Struct` format or
`Map` format if you use the included Type Converter from `Struct` to
`Map`.

Check below for more details.

# Samples

## Consuming events

Here is a basic route that you can use to listen to Debezium events from
MySQL connector.

    from("debezium-mysql:dbz-test-1?offsetStorageFileName=/usr/offset-file-1.dat&databaseHostname=localhost&databaseUser=debezium&databasePassword=dbz&databaseServerName=my-app-connector&databaseHistoryFileFilename=/usr/history-file-1.dat")
        .log("Event received from Debezium : ${body}")
        .log("    with this identifier ${headers.CamelDebeziumIdentifier}")
        .log("    with these source metadata ${headers.CamelDebeziumSourceMetadata}")
        .log("    the event occurred upon this operation '${headers.CamelDebeziumSourceOperation}'")
        .log("    on this database '${headers.CamelDebeziumSourceMetadata[db]}' and this table '${headers.CamelDebeziumSourceMetadata[table]}'")
        .log("    with the key ${headers.CamelDebeziumKey}")
        .log("    the previous value is ${headers.CamelDebeziumBefore}")
        .log("    the ddl sql text is ${headers.CamelDebeziumDdlSQL}")

By default, the component will emit the events in the body and
`CamelDebeziumBefore` header as
[`Struct`](https://kafka.apache.org/22/javadoc/org/apache/kafka/connect/data/Struct.html)
data type, the reasoning behind this, is to perceive the schema
information in case is needed. However, the component as well contains a
[Type Converter](#manual::type-converter.adoc) that converts from
default output type of
[`Struct`](https://kafka.apache.org/22/javadoc/org/apache/kafka/connect/data/Struct.html)
to `Map` in order to leverage Camel’s rich [Data
Format](#manual::data-format.adoc) types. Many of them work out of box
with `Map` data type. To use it, you can either add `Map.class` type
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

    from("debezium-mysql:[name]?[options]])
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
|bigintUnsignedHandlingMode|Specify how BIGINT UNSIGNED columns should be represented in change events, including: 'precise' uses java.math.BigDecimal to represent values, which are encoded in the change events using a binary representation and Kafka Connect's 'org.apache.kafka.connect.data.Decimal' type; 'long' (the default) represents values using Java's 'long', which may not offer the precision but will be far easier to use in consumers.|long|string|
|binlogBufferSize|The size of a look-ahead buffer used by the binlog reader to decide whether the transaction in progress is going to be committed or rolled back. Use 0 to disable look-ahead buffering. Defaults to 0 (i.e. buffering is disabled.|0|integer|
|columnExcludeList|Regular expressions matching columns to exclude from change events||string|
|columnIncludeList|Regular expressions matching columns to include in change events||string|
|columnPropagateSourceType|A comma-separated list of regular expressions matching fully-qualified names of columns that adds the columns original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|connectKeepAlive|Whether a separate thread should be used to ensure the connection is kept alive.|true|boolean|
|connectKeepAliveIntervalMs|Interval for connection checking if keep alive thread is used, given in milliseconds Defaults to 1 minute (60,000 ms).|1m|duration|
|connectTimeoutMs|Maximum time to wait after trying to connect to the database before timing out, given in milliseconds. Defaults to 30 seconds (30,000 ms).|30s|duration|
|converters|Optional list of custom converters that would be used instead of default ones. The converters are defined using '.type' config option and configured using options '.'||string|
|customMetricTags|The custom metric tags will accept key-value pairs to customize the MBean object name which should be appended the end of regular name, each key would represent a tag for the MBean object name, and the corresponding value would be the value of that tag the key is. For example: k1=v1,k2=v2||string|
|databaseExcludeList|A comma-separated list of regular expressions that match database names to be excluded from monitoring||string|
|databaseHostname|Resolvable hostname or IP address of the database server.||string|
|databaseIncludeList|The databases for which changes are to be captured||string|
|databaseInitialStatements|A semicolon separated list of SQL statements to be executed when a JDBC connection (not binlog reading connection) to the database is established. Note that the connector may establish JDBC connections at its own discretion, so this should typically be used for configuration of session parameters only, but not for executing DML statements. Use doubled semicolon (';;') to use a semicolon as a character and not as a delimiter.||string|
|databaseJdbcDriver|JDBC Driver class name used to connect to the MySQL database server.|com.mysql.cj.jdbc.Driver|string|
|databasePassword|Password of the database user to be used when connecting to the database.||string|
|databasePort|Port of the database server.|3306|integer|
|databaseProtocol|JDBC protocol to use with the driver.|jdbc:mysql|string|
|databaseQueryTimeoutMs|Time to wait for a query to execute, given in milliseconds. Defaults to 600 seconds (600,000 ms); zero means there is no limit.|10m|duration|
|databaseServerId|A numeric ID of this database client, which must be unique across all currently-running database processes in the cluster. This connector joins the database cluster as another server (with this unique ID) so it can read the binlog.||integer|
|databaseServerIdOffset|Only relevant if parallel snapshotting is configured. During parallel snapshotting, multiple (4) connections open to the database client, and they each need their own unique connection ID. This offset is used to generate those IDs from the base configured cluster ID.|10000|integer|
|databaseSslKeystore|The location of the key store file. This is optional and can be used for two-way authentication between the client and the database.||string|
|databaseSslKeystorePassword|The password for the key store file. This is optional and only needed if 'database.ssl.keystore' is configured.||string|
|databaseSslMode|Whether to use an encrypted connection to the database. Options include: 'disabled' to use an unencrypted connection; 'preferred' (the default) to establish a secure (encrypted) connection if the server supports secure connections, but fall back to an unencrypted connection otherwise; 'required' to use a secure (encrypted) connection, and fail if one cannot be established; 'verify\_ca' like 'required' but additionally verify the server TLS certificate against the configured Certificate Authority (CA) certificates, or fail if no valid matching CA certificates are found; or 'verify\_identity' like 'verify\_ca' but additionally verify that the server certificate matches the host to which the connection is attempted.|preferred|string|
|databaseSslTruststore|The location of the trust store file for the server certificate verification.||string|
|databaseSslTruststorePassword|The password for the trust store file. Used to check the integrity of the truststore, and unlock the truststore.||string|
|databaseUser|Name of the database user to be used when connecting to the database.||string|
|datatypePropagateSourceType|A comma-separated list of regular expressions matching the database-specific data type names that adds the data type's original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|decimalHandlingMode|Specify how DECIMAL and NUMERIC columns should be represented in change events, including: 'precise' (the default) uses java.math.BigDecimal to represent values, which are encoded in the change events using a binary representation and Kafka Connect's 'org.apache.kafka.connect.data.Decimal' type; 'string' uses string to represent values; 'double' represents values using Java's 'double', which may not offer the precision but will be far easier to use in consumers.|precise|string|
|enableTimeAdjuster|The database allows the user to insert year value as either 2-digit or 4-digit. In case of two digit the value is automatically mapped into 1970 - 2069.false - delegates the implicit conversion to the database; true - (the default) Debezium makes the conversion|true|boolean|
|errorsMaxRetries|The maximum number of retries on connection errors before failing (-1 = no limit, 0 = disabled, 0 = num of retries).|-1|integer|
|eventDeserializationFailureHandlingMode|Specify how failures during deserialization of binlog events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its binlog position is raised, causing the connector to be stopped; 'warn' the problematic event and its binlog position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|eventProcessingFailureHandlingMode|Specify how failures during processing of events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its position is raised, causing the connector to be stopped; 'warn' the problematic event and its position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|gtidSourceExcludes|The source UUIDs used to exclude GTID ranges when determine the starting position in the MySQL server's binlog.||string|
|gtidSourceFilterDmlEvents|When set to true, only produce DML events for transactions that were written on the server with matching GTIDs defined by the gtid.source.includes or gtid.source.excludes, if they were specified.|true|boolean|
|gtidSourceIncludes|The source UUIDs used to include GTID ranges when determine the starting position in the MySQL server's binlog.||string|
|heartbeatActionQuery|The query executed with every heartbeat.||string|
|heartbeatIntervalMs|Length of an interval in milli-seconds in in which the connector periodically sends heartbeat messages to a heartbeat topic. Use 0 to disable heartbeat messages. Disabled by default.|0ms|duration|
|heartbeatTopicsPrefix|The prefix that is used to name heartbeat topics.Defaults to \_\_debezium-heartbeat.|\_\_debezium-heartbeat|string|
|includeQuery|Whether the connector should include the original SQL query that generated the change event. Note: This option requires the database to be configured using the server option binlog\_rows\_query\_log\_events (MySQL) or binlog\_annotate\_row\_events (MariaDB) set to ON.Query will not be present for events generated from snapshot. WARNING: Enabling this option may expose tables or fields explicitly excluded or masked by including the original SQL statement in the change event. For this reason the default value is 'false'.|false|boolean|
|includeSchemaChanges|Whether the connector should publish changes in the database schema to a Kafka topic with the same name as the database server ID. Each schema change will be recorded using a key that contains the database name and whose value include logical description of the new schema and optionally the DDL statement(s). The default is 'true'. This is independent of how the connector internally records database schema history.|true|boolean|
|includeSchemaComments|Whether the connector parse table and column's comment to metadata object. Note: Enable this option will bring the implications on memory usage. The number and size of ColumnImpl objects is what largely impacts how much memory is consumed by the Debezium connectors, and adding a String to each of them can potentially be quite heavy. The default is 'false'.|false|boolean|
|inconsistentSchemaHandlingMode|Specify how binlog events that belong to a table missing from internal schema representation (i.e. internal representation is not consistent with database) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its binlog position is raised, causing the connector to be stopped; 'warn' the problematic event and its binlog position will be logged and the event will be skipped; 'skip' the problematic event will be skipped.|fail|string|
|incrementalSnapshotAllowSchemaChanges|Detect schema change during an incremental snapshot and re-select a current chunk to avoid locking DDLs. Note that changes to a primary key are not supported and can cause incorrect results if performed during an incremental snapshot. Another limitation is that if a schema change affects only columns' default values, then the change won't be detected until the DDL is processed from the binlog stream. This doesn't affect the snapshot events' values, but the schema of snapshot events may have outdated defaults.|false|boolean|
|incrementalSnapshotChunkSize|The maximum size of chunk (number of documents/rows) for incremental snapshotting|1024|integer|
|incrementalSnapshotWatermarkingStrategy|Specify the strategy used for watermarking during an incremental snapshot: 'insert\_insert' both open and close signal is written into signal data collection (default); 'insert\_delete' only open signal is written on signal data collection, the close will delete the relative open signal;|INSERT\_INSERT|string|
|maxBatchSize|Maximum size of each batch of source records. Defaults to 2048.|2048|integer|
|maxQueueSize|Maximum size of the queue for change events read from the database log but not yet recorded or forwarded. Defaults to 8192, and should always be larger than the maximum batch size.|8192|integer|
|maxQueueSizeInBytes|Maximum size of the queue in bytes for change events read from the database log but not yet recorded or forwarded. Defaults to 0. Mean the feature is not enabled|0|integer|
|messageKeyColumns|A semicolon-separated list of expressions that match fully-qualified tables and column(s) to be used as message key. Each expression must match the pattern ':', where the table names could be defined as (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connector, and the key columns are a comma-separated list of columns representing the custom key. For any table without an explicit key configuration the table's primary key column(s) will be used as message key. Example: dbserver1.inventory.orderlines:orderId,orderLineId;dbserver1.inventory.orders:id||string|
|minRowCountToStreamResults|The number of rows a table must contain to stream results rather than pull all into memory during snapshots. Defaults to 1,000. Use 0 to stream all results and completely avoid checking the size of each table.|1000|integer|
|notificationEnabledChannels|List of notification channels names that are enabled.||string|
|notificationSinkTopicName|The name of the topic for the notifications. This is required in case 'sink' is in the list of enabled channels||string|
|pollIntervalMs|Time to wait for new change events to appear after receiving no events, given in milliseconds. Defaults to 500 ms.|500ms|duration|
|postProcessors|Optional list of post processors. The processors are defined using '.type' config option and configured using options ''||string|
|provideTransactionMetadata|Enables transaction metadata extraction together with event counting|false|boolean|
|queryFetchSize|The maximum number of records that should be loaded into memory while streaming. A value of '0' uses the default JDBC fetch size.|0|integer|
|retriableRestartConnectorWaitMs|Time to wait before restarting connector after retriable exception occurs. Defaults to 10000ms.|10s|duration|
|schemaHistoryInternal|The name of the SchemaHistory class that should be used to store and recover database schema changes. The configuration properties for the history are prefixed with the 'schema.history.internal.' string.|io.debezium.storage.kafka.history.KafkaSchemaHistory|string|
|schemaHistoryInternalFileFilename|The path to the file that will be used to record the database schema history||string|
|schemaHistoryInternalSkipUnparseableDdl|Controls the action Debezium will take when it meets a DDL statement in binlog, that it cannot parse.By default the connector will stop operating but by changing the setting it can ignore the statements which it cannot parse. If skipping is enabled then Debezium can miss metadata changes.|false|boolean|
|schemaHistoryInternalStoreOnlyCapturedDatabasesDdl|Controls what DDL will Debezium store in database schema history. By default (true) only DDL that manipulates a table from captured schema/database will be stored. If set to false, then Debezium will store all incoming DDL statements.|true|boolean|
|schemaHistoryInternalStoreOnlyCapturedTablesDdl|Controls what DDL will Debezium store in database schema history. By default (false) Debezium will store all incoming DDL statements. If set to true, then only DDL that manipulates a captured table will be stored.|false|boolean|
|schemaNameAdjustmentMode|Specify how schema names should be adjusted for compatibility with the message converter used by the connector, including: 'avro' replaces the characters that cannot be used in the Avro type name with underscore; 'avro\_unicode' replaces the underscore or characters that cannot be used in the Avro type name with corresponding unicode like \_uxxxx. Note: \_ is an escape sequence like backslash in Java;'none' does not apply any adjustment (default)|none|string|
|signalDataCollection|The name of the data collection that is used to send signals/commands to Debezium. Signaling is disabled when not set.||string|
|signalEnabledChannels|List of channels names that are enabled. Source channel is enabled by default|source|string|
|signalPollIntervalMs|Interval for looking for new signals in registered channels, given in milliseconds. Defaults to 5 seconds.|5s|duration|
|skippedOperations|The comma-separated list of operations to skip during streaming, defined as: 'c' for inserts/create; 'u' for updates; 'd' for deletes, 't' for truncates, and 'none' to indicate nothing skipped. By default, only truncate operations will be skipped.|t|string|
|snapshotDelayMs|A delay period before a snapshot will begin, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|snapshotFetchSize|The maximum number of records that should be loaded into memory while performing a snapshot.||integer|
|snapshotIncludeCollectionList|This setting must be set to specify a list of tables/collections whose snapshot must be taken on creating or restarting the connector.||string|
|snapshotLockingMode|Controls how long the connector holds onto the global read lock while it is performing a snapshot. The default is 'minimal', which means the connector holds the global read lock (and thus prevents any updates) for just the initial portion of the snapshot while the database schemas and other metadata are being read. The remaining work in a snapshot involves selecting all rows from each table, and this can be done using the snapshot process' REPEATABLE READ transaction even when the lock is no longer held and other operations are updating the database. However, in some cases it may be desirable to block all writes for the entire duration of the snapshot; in such cases set this property to 'extended'. Using a value of 'none' will prevent the connector from acquiring any table locks during the snapshot process. This mode can only be used in combination with snapshot.mode values of 'schema\_only' or 'schema\_only\_recovery' and is only safe to use if no schema changes are happening while the snapshot is taken.|minimal|string|
|snapshotLockTimeoutMs|The maximum number of millis to wait for table locks at the beginning of a snapshot. If locks cannot be acquired in this time frame, the snapshot will be aborted. Defaults to 10 seconds|10s|duration|
|snapshotMaxThreads|The maximum number of threads used to perform the snapshot. Defaults to 1.|1|integer|
|snapshotMode|The criteria for running a snapshot upon startup of the connector. Select one of the following snapshot options: 'when\_needed': On startup, the connector runs a snapshot if one is needed.; 'schema\_only': If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures only the schema (table structures), but not any table data. After the snapshot completes, the connector begins to stream changes from the binlog.; 'schema\_only\_recovery': The connector performs a snapshot that captures only the database schema history. The connector then transitions back to streaming. Use this setting to restore a corrupted or lost database schema history topic. Do not use if the database schema was modified after the connector stopped.; 'initial' (default): If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures the current full state of the configured tables. After the snapshot completes, the connector begins to stream changes from the binlog.; 'initial\_only': The connector performs a snapshot as it does for the 'initial' option, but after the connector completes the snapshot, it stops, and does not stream changes from the binlog.; 'never': The connector does not run a snapshot. Upon first startup, the connector immediately begins reading from the beginning of the binlog. The 'never' mode should be used with care, and only when the binlog is known to contain all history.|initial|string|
|snapshotModeConfigurationBasedSnapshotData|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnDataError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnSchemaError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotSchema|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedStartStream|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the stream should start or not after snapshot.|false|boolean|
|snapshotModeCustomName|When 'snapshot.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'Snapshotter' interface and is called on each app boot to determine whether to do a snapshot.||string|
|snapshotQueryMode|Controls query used during the snapshot|select\_all|string|
|snapshotQueryModeCustomName|When 'snapshot.query.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'SnapshotterQuery' interface and is called to determine how to build queries during snapshot.||string|
|snapshotSelectStatementOverrides|This property contains a comma-separated list of fully-qualified tables (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connectors. Select statements for the individual tables are specified in further configuration properties, one for each table, identified by the id 'snapshot.select.statement.overrides.DB\_NAME.TABLE\_NAME' or 'snapshot.select.statement.overrides.SCHEMA\_NAME.TABLE\_NAME', respectively. The value of those properties is the select statement to use when retrieving data from the specific table during snapshotting. A possible use case for large append-only tables is setting a specific point where to start (resume) snapshotting, in case a previous snapshotting was interrupted.||string|
|snapshotTablesOrderByRowCount|Controls the order in which tables are processed in the initial snapshot. A descending value will order the tables by row count descending. A ascending value will order the tables by row count ascending. A value of disabled (the default) will disable ordering by row count.|disabled|string|
|sourceinfoStructMaker|The name of the SourceInfoStructMaker class that returns SourceInfo schema and struct.|io.debezium.connector.mysql.MySqlSourceInfoStructMaker|string|
|streamingDelayMs|A delay period after the snapshot is completed and the streaming begins, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|tableExcludeList|A comma-separated list of regular expressions that match the fully-qualified names of tables to be excluded from monitoring||string|
|tableIgnoreBuiltin|Flag specifying whether built-in tables should be ignored.|true|boolean|
|tableIncludeList|The tables for which changes are to be captured||string|
|timePrecisionMode|Time, date and timestamps can be represented with different kinds of precisions, including: 'adaptive\_time\_microseconds': the precision of date and timestamp values is based the database column's precision; but time fields always use microseconds precision; 'connect': always represents time, date and timestamp values using Kafka Connect's built-in representations for Time, Date, and Timestamp, which uses millisecond precision regardless of the database columns' precision.|adaptive\_time\_microseconds|string|
|tombstonesOnDelete|Whether delete operations should be represented by a delete event and a subsequent tombstone event (true) or only by a delete event (false). Emitting the tombstone event (the default behavior) allows Kafka to completely delete all events pertaining to the given key once the source record got deleted.|false|boolean|
|topicNamingStrategy|The name of the TopicNamingStrategy class that should be used to determine the topic name for data change, schema change, transaction, heartbeat event etc.|io.debezium.schema.SchemaTopicNamingStrategy|string|
|topicPrefix|Topic prefix that identifies and provides a namespace for the particular database server/cluster is capturing changes. The topic prefix should be unique across all other connectors, since it is used as a prefix for all Kafka topic names that receive events emitted by this connector. Only alphanumeric characters, hyphens, dots and underscores must be accepted.||string|
|transactionMetadataFactory|Class to make transaction context \& transaction struct/schemas|io.debezium.pipeline.txmetadata.DefaultTransactionMetadataFactory|string|
|useNongracefulDisconnect|Whether to use socket.setSoLinger(true, 0) when BinaryLogClient keepalive thread triggers a disconnect for a stale connection.|false|boolean|

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
|bigintUnsignedHandlingMode|Specify how BIGINT UNSIGNED columns should be represented in change events, including: 'precise' uses java.math.BigDecimal to represent values, which are encoded in the change events using a binary representation and Kafka Connect's 'org.apache.kafka.connect.data.Decimal' type; 'long' (the default) represents values using Java's 'long', which may not offer the precision but will be far easier to use in consumers.|long|string|
|binlogBufferSize|The size of a look-ahead buffer used by the binlog reader to decide whether the transaction in progress is going to be committed or rolled back. Use 0 to disable look-ahead buffering. Defaults to 0 (i.e. buffering is disabled.|0|integer|
|columnExcludeList|Regular expressions matching columns to exclude from change events||string|
|columnIncludeList|Regular expressions matching columns to include in change events||string|
|columnPropagateSourceType|A comma-separated list of regular expressions matching fully-qualified names of columns that adds the columns original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|connectKeepAlive|Whether a separate thread should be used to ensure the connection is kept alive.|true|boolean|
|connectKeepAliveIntervalMs|Interval for connection checking if keep alive thread is used, given in milliseconds Defaults to 1 minute (60,000 ms).|1m|duration|
|connectTimeoutMs|Maximum time to wait after trying to connect to the database before timing out, given in milliseconds. Defaults to 30 seconds (30,000 ms).|30s|duration|
|converters|Optional list of custom converters that would be used instead of default ones. The converters are defined using '.type' config option and configured using options '.'||string|
|customMetricTags|The custom metric tags will accept key-value pairs to customize the MBean object name which should be appended the end of regular name, each key would represent a tag for the MBean object name, and the corresponding value would be the value of that tag the key is. For example: k1=v1,k2=v2||string|
|databaseExcludeList|A comma-separated list of regular expressions that match database names to be excluded from monitoring||string|
|databaseHostname|Resolvable hostname or IP address of the database server.||string|
|databaseIncludeList|The databases for which changes are to be captured||string|
|databaseInitialStatements|A semicolon separated list of SQL statements to be executed when a JDBC connection (not binlog reading connection) to the database is established. Note that the connector may establish JDBC connections at its own discretion, so this should typically be used for configuration of session parameters only, but not for executing DML statements. Use doubled semicolon (';;') to use a semicolon as a character and not as a delimiter.||string|
|databaseJdbcDriver|JDBC Driver class name used to connect to the MySQL database server.|com.mysql.cj.jdbc.Driver|string|
|databasePassword|Password of the database user to be used when connecting to the database.||string|
|databasePort|Port of the database server.|3306|integer|
|databaseProtocol|JDBC protocol to use with the driver.|jdbc:mysql|string|
|databaseQueryTimeoutMs|Time to wait for a query to execute, given in milliseconds. Defaults to 600 seconds (600,000 ms); zero means there is no limit.|10m|duration|
|databaseServerId|A numeric ID of this database client, which must be unique across all currently-running database processes in the cluster. This connector joins the database cluster as another server (with this unique ID) so it can read the binlog.||integer|
|databaseServerIdOffset|Only relevant if parallel snapshotting is configured. During parallel snapshotting, multiple (4) connections open to the database client, and they each need their own unique connection ID. This offset is used to generate those IDs from the base configured cluster ID.|10000|integer|
|databaseSslKeystore|The location of the key store file. This is optional and can be used for two-way authentication between the client and the database.||string|
|databaseSslKeystorePassword|The password for the key store file. This is optional and only needed if 'database.ssl.keystore' is configured.||string|
|databaseSslMode|Whether to use an encrypted connection to the database. Options include: 'disabled' to use an unencrypted connection; 'preferred' (the default) to establish a secure (encrypted) connection if the server supports secure connections, but fall back to an unencrypted connection otherwise; 'required' to use a secure (encrypted) connection, and fail if one cannot be established; 'verify\_ca' like 'required' but additionally verify the server TLS certificate against the configured Certificate Authority (CA) certificates, or fail if no valid matching CA certificates are found; or 'verify\_identity' like 'verify\_ca' but additionally verify that the server certificate matches the host to which the connection is attempted.|preferred|string|
|databaseSslTruststore|The location of the trust store file for the server certificate verification.||string|
|databaseSslTruststorePassword|The password for the trust store file. Used to check the integrity of the truststore, and unlock the truststore.||string|
|databaseUser|Name of the database user to be used when connecting to the database.||string|
|datatypePropagateSourceType|A comma-separated list of regular expressions matching the database-specific data type names that adds the data type's original type and original length as parameters to the corresponding field schemas in the emitted change records.||string|
|decimalHandlingMode|Specify how DECIMAL and NUMERIC columns should be represented in change events, including: 'precise' (the default) uses java.math.BigDecimal to represent values, which are encoded in the change events using a binary representation and Kafka Connect's 'org.apache.kafka.connect.data.Decimal' type; 'string' uses string to represent values; 'double' represents values using Java's 'double', which may not offer the precision but will be far easier to use in consumers.|precise|string|
|enableTimeAdjuster|The database allows the user to insert year value as either 2-digit or 4-digit. In case of two digit the value is automatically mapped into 1970 - 2069.false - delegates the implicit conversion to the database; true - (the default) Debezium makes the conversion|true|boolean|
|errorsMaxRetries|The maximum number of retries on connection errors before failing (-1 = no limit, 0 = disabled, 0 = num of retries).|-1|integer|
|eventDeserializationFailureHandlingMode|Specify how failures during deserialization of binlog events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its binlog position is raised, causing the connector to be stopped; 'warn' the problematic event and its binlog position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|eventProcessingFailureHandlingMode|Specify how failures during processing of events (i.e. when encountering a corrupted event) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its position is raised, causing the connector to be stopped; 'warn' the problematic event and its position will be logged and the event will be skipped; 'ignore' the problematic event will be skipped.|fail|string|
|gtidSourceExcludes|The source UUIDs used to exclude GTID ranges when determine the starting position in the MySQL server's binlog.||string|
|gtidSourceFilterDmlEvents|When set to true, only produce DML events for transactions that were written on the server with matching GTIDs defined by the gtid.source.includes or gtid.source.excludes, if they were specified.|true|boolean|
|gtidSourceIncludes|The source UUIDs used to include GTID ranges when determine the starting position in the MySQL server's binlog.||string|
|heartbeatActionQuery|The query executed with every heartbeat.||string|
|heartbeatIntervalMs|Length of an interval in milli-seconds in in which the connector periodically sends heartbeat messages to a heartbeat topic. Use 0 to disable heartbeat messages. Disabled by default.|0ms|duration|
|heartbeatTopicsPrefix|The prefix that is used to name heartbeat topics.Defaults to \_\_debezium-heartbeat.|\_\_debezium-heartbeat|string|
|includeQuery|Whether the connector should include the original SQL query that generated the change event. Note: This option requires the database to be configured using the server option binlog\_rows\_query\_log\_events (MySQL) or binlog\_annotate\_row\_events (MariaDB) set to ON.Query will not be present for events generated from snapshot. WARNING: Enabling this option may expose tables or fields explicitly excluded or masked by including the original SQL statement in the change event. For this reason the default value is 'false'.|false|boolean|
|includeSchemaChanges|Whether the connector should publish changes in the database schema to a Kafka topic with the same name as the database server ID. Each schema change will be recorded using a key that contains the database name and whose value include logical description of the new schema and optionally the DDL statement(s). The default is 'true'. This is independent of how the connector internally records database schema history.|true|boolean|
|includeSchemaComments|Whether the connector parse table and column's comment to metadata object. Note: Enable this option will bring the implications on memory usage. The number and size of ColumnImpl objects is what largely impacts how much memory is consumed by the Debezium connectors, and adding a String to each of them can potentially be quite heavy. The default is 'false'.|false|boolean|
|inconsistentSchemaHandlingMode|Specify how binlog events that belong to a table missing from internal schema representation (i.e. internal representation is not consistent with database) should be handled, including: 'fail' (the default) an exception indicating the problematic event and its binlog position is raised, causing the connector to be stopped; 'warn' the problematic event and its binlog position will be logged and the event will be skipped; 'skip' the problematic event will be skipped.|fail|string|
|incrementalSnapshotAllowSchemaChanges|Detect schema change during an incremental snapshot and re-select a current chunk to avoid locking DDLs. Note that changes to a primary key are not supported and can cause incorrect results if performed during an incremental snapshot. Another limitation is that if a schema change affects only columns' default values, then the change won't be detected until the DDL is processed from the binlog stream. This doesn't affect the snapshot events' values, but the schema of snapshot events may have outdated defaults.|false|boolean|
|incrementalSnapshotChunkSize|The maximum size of chunk (number of documents/rows) for incremental snapshotting|1024|integer|
|incrementalSnapshotWatermarkingStrategy|Specify the strategy used for watermarking during an incremental snapshot: 'insert\_insert' both open and close signal is written into signal data collection (default); 'insert\_delete' only open signal is written on signal data collection, the close will delete the relative open signal;|INSERT\_INSERT|string|
|maxBatchSize|Maximum size of each batch of source records. Defaults to 2048.|2048|integer|
|maxQueueSize|Maximum size of the queue for change events read from the database log but not yet recorded or forwarded. Defaults to 8192, and should always be larger than the maximum batch size.|8192|integer|
|maxQueueSizeInBytes|Maximum size of the queue in bytes for change events read from the database log but not yet recorded or forwarded. Defaults to 0. Mean the feature is not enabled|0|integer|
|messageKeyColumns|A semicolon-separated list of expressions that match fully-qualified tables and column(s) to be used as message key. Each expression must match the pattern ':', where the table names could be defined as (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connector, and the key columns are a comma-separated list of columns representing the custom key. For any table without an explicit key configuration the table's primary key column(s) will be used as message key. Example: dbserver1.inventory.orderlines:orderId,orderLineId;dbserver1.inventory.orders:id||string|
|minRowCountToStreamResults|The number of rows a table must contain to stream results rather than pull all into memory during snapshots. Defaults to 1,000. Use 0 to stream all results and completely avoid checking the size of each table.|1000|integer|
|notificationEnabledChannels|List of notification channels names that are enabled.||string|
|notificationSinkTopicName|The name of the topic for the notifications. This is required in case 'sink' is in the list of enabled channels||string|
|pollIntervalMs|Time to wait for new change events to appear after receiving no events, given in milliseconds. Defaults to 500 ms.|500ms|duration|
|postProcessors|Optional list of post processors. The processors are defined using '.type' config option and configured using options ''||string|
|provideTransactionMetadata|Enables transaction metadata extraction together with event counting|false|boolean|
|queryFetchSize|The maximum number of records that should be loaded into memory while streaming. A value of '0' uses the default JDBC fetch size.|0|integer|
|retriableRestartConnectorWaitMs|Time to wait before restarting connector after retriable exception occurs. Defaults to 10000ms.|10s|duration|
|schemaHistoryInternal|The name of the SchemaHistory class that should be used to store and recover database schema changes. The configuration properties for the history are prefixed with the 'schema.history.internal.' string.|io.debezium.storage.kafka.history.KafkaSchemaHistory|string|
|schemaHistoryInternalFileFilename|The path to the file that will be used to record the database schema history||string|
|schemaHistoryInternalSkipUnparseableDdl|Controls the action Debezium will take when it meets a DDL statement in binlog, that it cannot parse.By default the connector will stop operating but by changing the setting it can ignore the statements which it cannot parse. If skipping is enabled then Debezium can miss metadata changes.|false|boolean|
|schemaHistoryInternalStoreOnlyCapturedDatabasesDdl|Controls what DDL will Debezium store in database schema history. By default (true) only DDL that manipulates a table from captured schema/database will be stored. If set to false, then Debezium will store all incoming DDL statements.|true|boolean|
|schemaHistoryInternalStoreOnlyCapturedTablesDdl|Controls what DDL will Debezium store in database schema history. By default (false) Debezium will store all incoming DDL statements. If set to true, then only DDL that manipulates a captured table will be stored.|false|boolean|
|schemaNameAdjustmentMode|Specify how schema names should be adjusted for compatibility with the message converter used by the connector, including: 'avro' replaces the characters that cannot be used in the Avro type name with underscore; 'avro\_unicode' replaces the underscore or characters that cannot be used in the Avro type name with corresponding unicode like \_uxxxx. Note: \_ is an escape sequence like backslash in Java;'none' does not apply any adjustment (default)|none|string|
|signalDataCollection|The name of the data collection that is used to send signals/commands to Debezium. Signaling is disabled when not set.||string|
|signalEnabledChannels|List of channels names that are enabled. Source channel is enabled by default|source|string|
|signalPollIntervalMs|Interval for looking for new signals in registered channels, given in milliseconds. Defaults to 5 seconds.|5s|duration|
|skippedOperations|The comma-separated list of operations to skip during streaming, defined as: 'c' for inserts/create; 'u' for updates; 'd' for deletes, 't' for truncates, and 'none' to indicate nothing skipped. By default, only truncate operations will be skipped.|t|string|
|snapshotDelayMs|A delay period before a snapshot will begin, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|snapshotFetchSize|The maximum number of records that should be loaded into memory while performing a snapshot.||integer|
|snapshotIncludeCollectionList|This setting must be set to specify a list of tables/collections whose snapshot must be taken on creating or restarting the connector.||string|
|snapshotLockingMode|Controls how long the connector holds onto the global read lock while it is performing a snapshot. The default is 'minimal', which means the connector holds the global read lock (and thus prevents any updates) for just the initial portion of the snapshot while the database schemas and other metadata are being read. The remaining work in a snapshot involves selecting all rows from each table, and this can be done using the snapshot process' REPEATABLE READ transaction even when the lock is no longer held and other operations are updating the database. However, in some cases it may be desirable to block all writes for the entire duration of the snapshot; in such cases set this property to 'extended'. Using a value of 'none' will prevent the connector from acquiring any table locks during the snapshot process. This mode can only be used in combination with snapshot.mode values of 'schema\_only' or 'schema\_only\_recovery' and is only safe to use if no schema changes are happening while the snapshot is taken.|minimal|string|
|snapshotLockTimeoutMs|The maximum number of millis to wait for table locks at the beginning of a snapshot. If locks cannot be acquired in this time frame, the snapshot will be aborted. Defaults to 10 seconds|10s|duration|
|snapshotMaxThreads|The maximum number of threads used to perform the snapshot. Defaults to 1.|1|integer|
|snapshotMode|The criteria for running a snapshot upon startup of the connector. Select one of the following snapshot options: 'when\_needed': On startup, the connector runs a snapshot if one is needed.; 'schema\_only': If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures only the schema (table structures), but not any table data. After the snapshot completes, the connector begins to stream changes from the binlog.; 'schema\_only\_recovery': The connector performs a snapshot that captures only the database schema history. The connector then transitions back to streaming. Use this setting to restore a corrupted or lost database schema history topic. Do not use if the database schema was modified after the connector stopped.; 'initial' (default): If the connector does not detect any offsets for the logical server name, it runs a snapshot that captures the current full state of the configured tables. After the snapshot completes, the connector begins to stream changes from the binlog.; 'initial\_only': The connector performs a snapshot as it does for the 'initial' option, but after the connector completes the snapshot, it stops, and does not stream changes from the binlog.; 'never': The connector does not run a snapshot. Upon first startup, the connector immediately begins reading from the beginning of the binlog. The 'never' mode should be used with care, and only when the binlog is known to contain all history.|initial|string|
|snapshotModeConfigurationBasedSnapshotData|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnDataError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the data should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotOnSchemaError|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not in case of error.|false|boolean|
|snapshotModeConfigurationBasedSnapshotSchema|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the schema should be snapshotted or not.|false|boolean|
|snapshotModeConfigurationBasedStartStream|When 'snapshot.mode' is set as configuration\_based, this setting permits to specify whenever the stream should start or not after snapshot.|false|boolean|
|snapshotModeCustomName|When 'snapshot.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'Snapshotter' interface and is called on each app boot to determine whether to do a snapshot.||string|
|snapshotQueryMode|Controls query used during the snapshot|select\_all|string|
|snapshotQueryModeCustomName|When 'snapshot.query.mode' is set as custom, this setting must be set to specify a the name of the custom implementation provided in the 'name()' method. The implementations must implement the 'SnapshotterQuery' interface and is called to determine how to build queries during snapshot.||string|
|snapshotSelectStatementOverrides|This property contains a comma-separated list of fully-qualified tables (DB\_NAME.TABLE\_NAME) or (SCHEMA\_NAME.TABLE\_NAME), depending on the specific connectors. Select statements for the individual tables are specified in further configuration properties, one for each table, identified by the id 'snapshot.select.statement.overrides.DB\_NAME.TABLE\_NAME' or 'snapshot.select.statement.overrides.SCHEMA\_NAME.TABLE\_NAME', respectively. The value of those properties is the select statement to use when retrieving data from the specific table during snapshotting. A possible use case for large append-only tables is setting a specific point where to start (resume) snapshotting, in case a previous snapshotting was interrupted.||string|
|snapshotTablesOrderByRowCount|Controls the order in which tables are processed in the initial snapshot. A descending value will order the tables by row count descending. A ascending value will order the tables by row count ascending. A value of disabled (the default) will disable ordering by row count.|disabled|string|
|sourceinfoStructMaker|The name of the SourceInfoStructMaker class that returns SourceInfo schema and struct.|io.debezium.connector.mysql.MySqlSourceInfoStructMaker|string|
|streamingDelayMs|A delay period after the snapshot is completed and the streaming begins, given in milliseconds. Defaults to 0 ms.|0ms|duration|
|tableExcludeList|A comma-separated list of regular expressions that match the fully-qualified names of tables to be excluded from monitoring||string|
|tableIgnoreBuiltin|Flag specifying whether built-in tables should be ignored.|true|boolean|
|tableIncludeList|The tables for which changes are to be captured||string|
|timePrecisionMode|Time, date and timestamps can be represented with different kinds of precisions, including: 'adaptive\_time\_microseconds': the precision of date and timestamp values is based the database column's precision; but time fields always use microseconds precision; 'connect': always represents time, date and timestamp values using Kafka Connect's built-in representations for Time, Date, and Timestamp, which uses millisecond precision regardless of the database columns' precision.|adaptive\_time\_microseconds|string|
|tombstonesOnDelete|Whether delete operations should be represented by a delete event and a subsequent tombstone event (true) or only by a delete event (false). Emitting the tombstone event (the default behavior) allows Kafka to completely delete all events pertaining to the given key once the source record got deleted.|false|boolean|
|topicNamingStrategy|The name of the TopicNamingStrategy class that should be used to determine the topic name for data change, schema change, transaction, heartbeat event etc.|io.debezium.schema.SchemaTopicNamingStrategy|string|
|topicPrefix|Topic prefix that identifies and provides a namespace for the particular database server/cluster is capturing changes. The topic prefix should be unique across all other connectors, since it is used as a prefix for all Kafka topic names that receive events emitted by this connector. Only alphanumeric characters, hyphens, dots and underscores must be accepted.||string|
|transactionMetadataFactory|Class to make transaction context \& transaction struct/schemas|io.debezium.pipeline.txmetadata.DefaultTransactionMetadataFactory|string|
|useNongracefulDisconnect|Whether to use socket.setSoLinger(true, 0) when BinaryLogClient keepalive thread triggers a disconnect for a stale connection.|false|boolean|
