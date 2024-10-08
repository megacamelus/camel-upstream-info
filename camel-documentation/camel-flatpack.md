# Flatpack

**Since Camel 1.4**

**Both producer and consumer are supported**

The Flatpack component supports fixed width and delimited file parsing
via the [FlatPack library](http://flatpack.sourceforge.net).  
**Notice:** This component only supports consuming from flatpack files
to Object model. You can not (yet) write from Object model to flatpack
format.

# URI format

    flatpack:[delim|fixed]:flatPackConfig.pzmap.xml[?options]

Or for a delimited file handler with no configuration file just use

    flatpack:someName[?options]

# Usage

-   `flatpack:fixed:foo.pzmap.xml` creates a fixed-width endpoint using
    the `foo.pzmap.xml` file configuration.

-   `flatpack:delim:bar.pzmap.xml` creates a delimited endpoint using
    the `bar.pzmap.xml` file configuration.

-   `flatpack:foo` creates a delimited endpoint called `foo` with no
    file configuration.

## Message Body

The component delivers the data in the IN message as a
`org.apache.camel.component.flatpack.DataSetList` object that has
converters for `java.util.Map` or `java.util.List`.  
Usually you want the `Map` if you process one row at a time
(`splitRows=true`). Use `List` for the entire content
(`splitRows=false`), where each element in the list is a `Map`.  
Each `Map` contains the key for the column name and its corresponding
value.

For example, to get the firstname from the sample below:

      Map row = exchange.getIn().getBody(Map.class);
      String firstName = row.get("FIRSTNAME");

However, you can also always get it as a `List` (even for
`splitRows=true`). The same example:

      List data = exchange.getIn().getBody(List.class);
      Map row = (Map)data.get(0);
      String firstName = row.get("FIRSTNAME");

## Header and Trailer records

The header and trailer notions in Flatpack are supported. However, you
**must** use fixed record IDs:

-   `header` for the header record (must be lowercase)

-   `trailer` for the trailer record (must be lowercase)

The example below illustrates this fact that we have a header and a
trailer. You can omit one or both of them if not needed.

        <RECORD id="header" startPosition="1" endPosition="3" indicator="HBT">
            <COLUMN name="INDICATOR" length="3"/>
            <COLUMN name="DATE" length="8"/>
        </RECORD>
    
        <COLUMN name="FIRSTNAME" length="35" />
        <COLUMN name="LASTNAME" length="35" />
        <COLUMN name="ADDRESS" length="100" />
        <COLUMN name="CITY" length="100" />
        <COLUMN name="STATE" length="2" />
        <COLUMN name="ZIP" length="5" />
    
        <RECORD id="trailer" startPosition="1" endPosition="3" indicator="FBT">
            <COLUMN name="INDICATOR" length="3"/>
            <COLUMN name="STATUS" length="7"/>
        </RECORD>

## Using as an Endpoint

A common use case is sending a file to this endpoint for further
processing in a separate route. For example:

      <camelContext xmlns="http://activemq.apache.org/camel/schema/spring">
        <route>
          <from uri="file://someDirectory"/>
          <to uri="flatpack:foo"/>
        </route>
    
        <route>
          <from uri="flatpack:foo"/>
          ...
        </route>
      </camelContext>

You can also convert the payload of each message created to a `Map` for
easy Bean Integration

## Flatpack DataFormat

The [Flatpack](#flatpack-component.adoc) component ships with the
Flatpack data format that can be used to format between fixed width or
delimited text messages to a `List` of rows as `Map`.

-   marshal = from `List<Map<String, Object>>` to `OutputStream` (can be
    converted to `String`)

-   unmarshal = from `java.io.InputStream` (such as a `File` or
    `String`) to a `java.util.List` as an
    `org.apache.camel.component.flatpack.DataSetList` instance.  
    The result of the operation will contain all the data. If you need
    to process each row one by one you can split the exchange, using
    Splitter.

**Notice:** The Flatpack library does currently not support header and
trailers for the marshal operation.

### Options

The data format has the following options:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
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
<td style="text-align: left;"><p><code>definition</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p>The flatpack pzmap configuration file.
Can be omitted in simpler situations, but its preferred to use the
pzmap.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>fixed</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Delimited or fixed.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>ignoreFirstRecord</code></p></td>
<td style="text-align: left;"><p><code>true</code></p></td>
<td style="text-align: left;"><p>Whether the first line is ignored for
delimited files (for the column headers).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>textQualifier</code></p></td>
<td style="text-align: left;"><p><code>"</code></p></td>
<td style="text-align: left;"><p>If the text is qualified with a char
such as <code>"</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>delimiter</code></p></td>
<td style="text-align: left;"><p><code>,</code></p></td>
<td style="text-align: left;"><p>The delimiter char (could be
<code>;</code> <code>,</code> or similar)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>parserFactory</code></p></td>
<td style="text-align: left;"><p><code>null</code></p></td>
<td style="text-align: left;"><p>Uses the default Flatpack parser
factory.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>allowShortLines</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Allows for lines to be shorter than
expected and ignores the extra characters.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>ignoreExtraColumns</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Allows for lines to be longer than
expected and ignores the extra characters.</p></td>
</tr>
</tbody>
</table>

## Using the data format

To use the data format, instantiate an instance and invoke the marshal
or unmarshal operation in the route builder:

      FlatpackDataFormat fp = new FlatpackDataFormat();
      fp.setDefinition(new ClassPathResource("INVENTORY-Delimited.pzmap.xml"));
      ...
      from("file:order/in").unmarshal(df).to("seda:queue:neworder");

The sample above will read files from the `order/in` folder and
unmarshal the input using the Flatpack configuration file
`INVENTORY-Delimited.pzmap.xml` that configures the structure of the
files. The result is a `DataSetList` object we store on the SEDA queue.

    FlatpackDataFormat df = new FlatpackDataFormat();
    df.setDefinition(new ClassPathResource("PEOPLE-FixedLength.pzmap.xml"));
    df.setFixed(true);
    df.setIgnoreFirstRecord(false);
    
    from("seda:people").marshal(df).convertBodyTo(String.class).to("jms:queue:people");

In the code above we marshal the data from an Object representation as a
`List` of rows as `Maps`. The rows as `Map` contains the column name as
the key, and the corresponding value. This structure can be created in
Java code from e.g., a processor. We marshal the data according to the
Flatpack format and convert the result as a `String` object and store it
on a JMS queue.

## Dependencies

To use Flatpack in your camel routes, you need to add a dependency on
**camel-flatpack** which implements this data format.

If you use maven, you could add the following to your `pom.xml`,
substituting the version number for the latest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-flatpack</artifactId>
      <version>x.x.x</version>
    </dependency>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|type|Whether to use fixed or delimiter|delim|object|
|resourceUri|URL for loading the flatpack mapping file from classpath or file system||string|
|allowShortLines|Allows for lines to be shorter than expected and ignores the extra characters|false|boolean|
|delimiter|The default character delimiter for delimited files.|,|string|
|ignoreExtraColumns|Allows for lines to be longer than expected and ignores the extra characters|false|boolean|
|ignoreFirstRecord|Whether the first line is ignored for delimited files (for the column headers).|true|boolean|
|splitRows|Sets the Component to send each row as a separate exchange once parsed|true|boolean|
|textQualifier|The text qualifier for delimited files.||string|
|sendEmptyMessageWhenIdle|If the polling consumer did not poll any files, you can enable this option to send an empty message (no body) instead.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|pollStrategy|A pluggable org.apache.camel.PollingConsumerPollingStrategy allowing you to provide your custom implementation to control error handling usually occurred during the poll operation before an Exchange have been created and being routed in Camel.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
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
