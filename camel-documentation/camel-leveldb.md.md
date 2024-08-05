# Leveldb.md

**Since Camel 2.10**

[Leveldb](https://github.com/google/leveldb) is a very lightweight and
embeddable key value database. It allows, together with Camel, providing
persistent support for various Camel features such as Aggregator.

Current features it provides:

-   LevelDBAggregationRepository

# Using LevelDBAggregationRepository

`LevelDBAggregationRepository` is an `AggregationRepository` which on
the fly persists the aggregated messages. This ensures that you will not
lose messages, as the default aggregator will use an in-memory only
`AggregationRepository`.

It has the following options:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>repositoryName</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A mandatory repository name. Allows you
to use a shared <code>LevelDBFile</code> for multiple
repositories.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>persistentFileName</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Filename for the persistent storage. If
no file exists on startup, a new file is created.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>levelDBFile</code></p></td>
<td style="text-align: left;"><p>LevelDBFile</p></td>
<td style="text-align: left;"><p>Use an existing configured
<code>org.apache.camel.component.leveldb.LevelDBFile</code>
instance.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>sync</code></p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Whether the LevelDBFile should sync on
writing or not. Default is false. By sync on writing ensures that it’s
always waiting for all writes to be spooled to disk and thus will not
lose updates. See <a
href="http://leveldb.googlecode.com/svn/trunk/doc/index.html">LevelDB
docs</a> for more details about async vs. sync writes.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>returnOldExchange</code></p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Whether the get operation should return
the old existing Exchange if any existed. By default, this option is
<code>false</code> to optimize as we do not need the old exchange when
aggregating.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>useRecovery</code></p></td>
<td style="text-align: left;"><p>boolean</p></td>
<td style="text-align: left;"><p>Whether recovery is enabled. This
option is by default <code>true</code>. When enabled, the Camel
Aggregator automatically recovers failed aggregated exchange and have
them resubmitted.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>recoveryInterval</code></p></td>
<td style="text-align: left;"><p>long</p></td>
<td style="text-align: left;"><p>If recovery is enabled, then a
background task is run every x’th time to scan for failed exchanges to
recover and resubmit. By default, this interval is 5000
milliseconds.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>maximumRedeliveries</code></p></td>
<td style="text-align: left;"><p>int</p></td>
<td style="text-align: left;"><p>Allows you to limit the maximum number
of redelivery attempts for a recovered exchange. If enabled, then the
Exchange will be moved to the dead letter channel if all redelivery
attempts failed. By default, this option is disabled. If this option is
used then the <code>deadLetterUri</code> option must also be
provided.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>deadLetterUri</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>An endpoint uri for a Dead Letter
Channel where exhausted recovered Exchanges will be moved. If this
option is used then the <code>maximumRedeliveries</code> option must
also be provided.</p></td>
</tr>
</tbody>
</table>

The `repositoryName` option must be provided. Then either the
`persistentFileName` or the `levelDBFile` must be provided.

## What is preserved when persisting

`LevelDBAggregationRepository` will only preserve any `Serializable`
compatible message body data types. Message headers must be primitive /
string / numbers / etc. If a data type is not such a type its dropped
and a `WARN` is logged. And it only persists the `Message` body and the
`Message` headers. The `Exchange` properties are **not** persisted.

## Recovery

The `LevelDBAggregationRepository` will by default recover any failed
Exchange. It does this by having a background task that scans for failed
Exchanges in the persistent store. You can use the `checkInterval`
option to set how often this task runs. The recovery works as
transactional which ensures that Camel will try to recover and redeliver
the failed Exchange. Any Exchange found to be recovered will be restored
from the persistent store and resubmitted and send out again.

The following headers are set when an Exchange is being
recovered/redelivered:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>Exchange.REDELIVERED</code></p></td>
<td style="text-align: left;"><p>Boolean</p></td>
<td style="text-align: left;"><p>It is set to true to indicate the
Exchange is being redelivered.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>Exchange.REDELIVERY_COUNTER</code></p></td>
<td style="text-align: left;"><p>Integer</p></td>
<td style="text-align: left;"><p>The redelivery attempt, starting from
1.</p></td>
</tr>
</tbody>
</table>

Only when an Exchange has been successfully processed it will be marked
as complete which happens when the `confirm` method is invoked on the
`AggregationRepository`. This means if the same Exchange fails again, it
will be kept retried until it succeeds.

You can use option `maximumRedeliveries` to limit the maximum number of
redelivery attempts for a given recovered Exchange. You must also set
the `deadLetterUri` option so Camel knows where to send the Exchange
when the `maximumRedeliveries` was hit.

You can see some examples in the unit tests of camel-leveldb, for
example, [this
test](https://svn.apache.org/repos/asf/camel/trunk/components/camel-leveldb/src/test/java/org/apache/camel/component/leveldb/LevelDBAggregateRecoverTest.java).

## Serialization mechanism

Component serializes by using Java serialization mechanism by default.

You can use serialization via Jackson (using json). Jackson’s
serialization brings better performance, but also several limitations.

Example of jackson serialization:

    LevelDBAggregationRepository repo = ...; //initialization of repository
    repo.setSerializer(new JacksonLevelDBSerializer());

Limitation of jackson serializer is caused by binary data:

-   If payload is a raw data (byte\[\]), it is saved into DB without
    using Jackson

-   If payload contains objects with binary fields. Those fields won’t
    be serialized/deserialized correctly. Customized serializer can be
    used to solve this problem. Please use custom serializer with
    Jackson by providing own Module:

<!-- -->

    SimpleModule simpleModule = new SimpleModule();
    simpleModule.addSerializer(ObjectWithBinaryField.class, new ObjectWithBinaryFieldSerializer()); //custom serializer
    simpleModule.addDeserializer(ObjectWithBinaryField.class, new ObjectWithBinaryFieldDeserializer()); //custom deserializer
    
    repo.setSerializer(new JacksonLevelDBSerializer(simpleModule));

# Using LevelDBAggregationRepository in Java DSL

In this example we want to persist aggregated messages in the
`target/data/leveldb.dat` file.

# Using LevelDBAggregationRepository in Spring XML

The same example but using Spring XML instead:

# Dependencies

To use LevelDB in your Camel routes, you need to add a dependency on
**camel-leveldb**.

If you use Maven, you could add the following to your pom.xml,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-leveldb</artifactId>
      <version>x.y.z</version>
    </dependency>
