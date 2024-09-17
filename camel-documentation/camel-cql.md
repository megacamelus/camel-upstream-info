# Cql

**Since Camel 2.15**

**Both producer and consumer are supported**

[Apache Cassandra](http://cassandra.apache.org) is an open source NoSQL
database designed to handle large amounts on commodity hardware. Like
Amazon’s DynamoDB, Cassandra has a peer-to-peer and master-less
architecture to avoid a single point of failure and guaranty high
availability. Like Google’s BigTable, Cassandra data is structured using
column families which can be accessed through the Thrift RPC API or an
SQL-like API called CQL.

This component aims at integrating Cassandra 2.0+ using the CQL3 API
instead of the Thrift API. It’s based on [Cassandra Java
Driver](https://github.com/datastax/java-driver) provided by DataStax.

# Usage

## Endpoint Connection Syntax

The endpoint can initiate the Cassandra connection or use an existing
one.

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">URI</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>cql:localhost/keyspace</code></p></td>
<td style="text-align: left;"><p>Single host, default port, usual for
testing</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>cql:host1,host2/keyspace</code></p></td>
<td style="text-align: left;"><p>Multi host, default port</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cql:host1,host2:9042/keyspace</code></p></td>
<td style="text-align: left;"><p>Multi host, custom port</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>cql:host1,host2</code></p></td>
<td style="text-align: left;"><p>Default port and keyspace</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>cql:bean:sessionRef</code></p></td>
<td style="text-align: left;"><p>Provided Session reference</p></td>
</tr>
</tbody>
</table>

To fine-tune the Cassandra connection (SSL options, pooling options,
load balancing policy, retry policy, reconnection policy…), create your
own Cluster instance and give it to the Camel endpoint.

## Messages

### Incoming Message

The Camel Cassandra endpoint expects a bunch of simple objects (`Object`
or `Object[]` or `Collection<Object>`) which will be bound to the CQL
statement as query parameters. If the message body is null or empty,
then CQL query will be executed without binding parameters.

Headers:

-   `CamelCqlQuery` (optional, `String` or `RegularStatement`): CQL
    query either as a plain String or built using the `QueryBuilder`.

### Outgoing Message

The Camel Cassandra endpoint produces one or many a Cassandra Row
objects depending on the `resultSetConversionStrategy`:

-   `List<Row>` if `resultSetConversionStrategy` is `ALL` or
    `LIMIT_[0-9]+`

-   Single\` Row\` if `resultSetConversionStrategy` is `ONE`

-   Anything else, if `resultSetConversionStrategy` is a custom
    implementation of the `ResultSetConversionStrategy`

## Repositories

Cassandra can be used to store message keys or messages for the
idempotent and aggregation EIP.

Cassandra might not be the best tool for queuing use cases yet, read
[Cassandra anti-patterns queues and queue like
datasets](http://www.datastax.com/dev/blog/cassandra-anti-patterns-queues-and-queue-like-datasets).
It’s advised to use LeveledCompaction and a small GC grace setting for
these tables to allow tombstoned rows to be removed quickly.

### Idempotent repository

The `NamedCassandraIdempotentRepository` stores messages keys in a
Cassandra table like this:

**CAMEL\_IDEMPOTENT.cql**

    CREATE TABLE CAMEL_IDEMPOTENT (
      NAME varchar,   -- Repository name
      KEY varchar,    -- Message key
      PRIMARY KEY (NAME, KEY)
    ) WITH compaction = {'class':'LeveledCompactionStrategy'}
      AND gc_grace_seconds = 86400;

This repository implementation uses lightweight transactions, (also
known as Compare and Set) and requires Cassandra 2.0.7+.

Alternatively, the `CassandraIdempotentRepository` does not have a
`NAME` column and can be extended to use a different data model.

<table>
<colgroup>
<col style="width: 34%" />
<col style="width: 32%" />
<col style="width: 32%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>table</code></p></td>
<td style="text-align: left;"><p><code>CAMEL_IDEMPOTENT</code></p></td>
<td style="text-align: left;"><p>Table name</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>pkColumns</code></p></td>
<td style="text-align: left;"><p><code>NAME</code>,` KEY`</p></td>
<td style="text-align: left;"><p>Primary key columns</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>name</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Repository name, value used for
<code>NAME</code> column</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>ttl</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Key time to live</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>writeConsistencyLevel</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Consistency level used to insert/delete
key: <code>ANY</code>, <code>ONE</code>, <code>TWO</code>,
<code>QUORUM</code>, <code>LOCAL_QUORUM</code>…</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>readConsistencyLevel</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Consistency level used to read/check
key: <code>ONE</code>, <code>TWO</code>, <code>QUORUM</code>,
<code>LOCAL_QUORUM</code>…</p></td>
</tr>
</tbody>
</table>

### Aggregation repository

The `NamedCassandraAggregationRepository` stores exchanges by
correlation key in a Cassandra table like this:

**CAMEL\_AGGREGATION.cql**

    CREATE TABLE CAMEL_AGGREGATION (
      NAME varchar,        -- Repository name
      KEY varchar,         -- Correlation id
      EXCHANGE_ID varchar, -- Exchange id
      EXCHANGE blob,       -- Serialized exchange
      PRIMARY KEY (NAME, KEY)
    ) WITH compaction = {'class':'LeveledCompactionStrategy'}
      AND gc_grace_seconds = 86400;

Alternatively, the `CassandraAggregationRepository` does not have a
`NAME` column and can be extended to use a different data model.

<table>
<colgroup>
<col style="width: 34%" />
<col style="width: 32%" />
<col style="width: 32%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>table</code></p></td>
<td style="text-align: left;"><p><code>CAMEL_AGGREGATION</code></p></td>
<td style="text-align: left;"><p>Table name</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>pkColumns</code></p></td>
<td
style="text-align: left;"><p><code>NAME</code>,<code>KEY</code></p></td>
<td style="text-align: left;"><p>Primary key columns</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>exchangeIdColumn</code></p></td>
<td style="text-align: left;"><p><code>EXCHANGE_ID</code></p></td>
<td style="text-align: left;"><p>Exchange Id column</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>exchangeColumn</code></p></td>
<td style="text-align: left;"><p><code>EXCHANGE</code></p></td>
<td style="text-align: left;"><p>Exchange content column</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>name</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Repository name, value used for
<code>NAME</code> column</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>ttl</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Exchange time to live</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>writeConsistencyLevel</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Consistency level used to insert/delete
exchange: <code>ANY</code>, <code>ONE</code>, <code>TWO</code>,
<code>QUORUM</code>, <code>LOCAL_QUORUM</code>…</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>readConsistencyLevel</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Consistency level used to read/check
exchange: <code>ONE</code>, <code>TWO</code>, <code>QUORUM</code>,
<code>LOCAL_QUORUM</code>…</p></td>
</tr>
</tbody>
</table>

While deserializing, it’s important to notice that the
`unmarshallExchange` method will allow only all java packages and
subpackages and org.apache.camel packages and subpackages. The remaining
classes will be blacklisted. So you’ll need to change the filter in case
of need. This could be accomplished by changing the
deserializationFilter field in the repository.

# Examples

To insert something on a table, you can use the following code:

    String CQL = "insert into camel_user(login, first_name, last_name) values (?, ?, ?)";
    from("direct:input")
        .to("cql://localhost/camel_ks?cql=" + CQL);

At this point, you should be able to insert data by using a list as body

    Arrays.asList("davsclaus", "Claus", "Ibsen");

The same approach can be used for updating or querying the table.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|beanRef|beanRef is defined using bean:id||string|
|hosts|Hostname(s) Cassandra server(s). Multiple hosts can be separated by comma.||string|
|port|Port number of Cassandra server(s)||integer|
|keyspace|Keyspace to use||string|
|clusterName|Cluster name||string|
|cql|CQL query to perform. Can be overridden with the message header with key CamelCqlQuery.||string|
|datacenter|Datacenter to use|datacenter1|string|
|prepareStatements|Whether to use PreparedStatements or regular Statements|true|boolean|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|extraTypeCodecs|To use a specific comma separated list of Extra Type codecs. Possible values are: BLOB\_TO\_ARRAY, BOOLEAN\_LIST\_TO\_ARRAY, BYTE\_LIST\_TO\_ARRAY, SHORT\_LIST\_TO\_ARRAY, INT\_LIST\_TO\_ARRAY, LONG\_LIST\_TO\_ARRAY, FLOAT\_LIST\_TO\_ARRAY, DOUBLE\_LIST\_TO\_ARRAY, TIMESTAMP\_UTC, TIMESTAMP\_MILLIS\_SYSTEM, TIMESTAMP\_MILLIS\_UTC, ZONED\_TIMESTAMP\_SYSTEM, ZONED\_TIMESTAMP\_UTC, ZONED\_TIMESTAMP\_PERSISTED, LOCAL\_TIMESTAMP\_SYSTEM and LOCAL\_TIMESTAMP\_UTC||string|
|loadBalancingPolicyClass|To use a specific LoadBalancingPolicyClass||string|
|resultSetConversionStrategy|To use a custom class that implements logic for converting ResultSet into message body ALL, ONE, LIMIT\_10, LIMIT\_100...||object|
|session|To use the Session instance (you would normally not use this option)||object|
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
|password|Password for session authentication||string|
|username|Username for session authentication||string|
