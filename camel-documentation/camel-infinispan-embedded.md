# Infinispan-embedded

**Since Camel 2.13**

**Both producer and consumer are supported**

This component allows you to interact with
[Infinispan](http://infinispan.org/) distributed data grid / cache.
Infinispan is an extremely scalable, highly available key/value data
store and data grid platform written in Java.

The `camel-infinispan-embedded` component includes the following
features:

-   **Local Camel Consumer**: receives cache change notifications and
    sends them to be processed. This can be done synchronously or
    asynchronously, and is also supported with a replicated or
    distributed cache.

-   **Local Camel Producer**: a producer creates and sends messages to
    an endpoint. The `camel-infinispan` producer uses \`\`GET\`\`,
    \`\`PUT\`\`, \`\`REMOVE\`\`, and `CLEAR` operations. The local
    producer is also supported with a replicated or distributed cache.

The events are processed asynchronously.

If you use Maven, you must add the following dependency to your
`pom.xml`:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-infinispan-embedded</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    infinispan-embedded://cacheName?[options]

The producer allows sending messages to a local infinispan cache. The
consumer allows listening for events from local infinispan cache.

If no cache configuration is provided, embedded cacheContainer is
created directly in the component.

# Camel Operations

This section lists all available operations, along with their header
information.

<table>
<caption>Put Operations</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.PUT</code></p></td>
<td style="text-align: left;"><pre><code>Put a key/value pair in the cache, optionally with expiration</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.PUTASYNC</code></p></td>
<td style="text-align: left;"><pre><code>Asynchronously puts a key/value pair in the cache, optionally with expiration</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.PUTIFABSENT</code></p></td>
<td style="text-align: left;"><pre><code>Put a key/value pair in the cache if it did not exist, optionally with expiration</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.PUTIFABSENTASYNC</code></p></td>
<td style="text-align: left;"><pre><code>Asynchronously puts a key/value pair in the cache if it did not exist, optionally with expiration</code></pre></td>
</tr>
</tbody>
</table>

Put Operations

-   **Required Headers**:
    
    -   `CamelInfinispanKey`
    
    -   `CamelInfinispanValue`

-   **Optional Headers**:
    
    -   `CamelInfinispanLifespanTime`
    
    -   `CamelInfinispanLifespanTimeUnit`
    
    -   `CamelInfinispanMaxIdleTime`
    
    -   `CamelInfinispanMaxIdleTimeUnit`

-   **Result Header**:
    
    -   `CamelInfinispanOperationResult`

<table>
<caption>Put All Operations</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.PUTALL</code></p></td>
<td style="text-align: left;"><pre><code>Adds multiple entries to a cache, optionally with expiration</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>CamelInfinispanOperation.PUTALLASYNC</code></p></td>
<td style="text-align: left;"><pre><code>Asynchronously adds multiple entries to a cache, optionally with expiration</code></pre></td>
</tr>
</tbody>
</table>

Put All Operations

-   **Required Headers**:
    
    -   CamelInfinispanMap

-   **Optional Headers**:
    
    -   `CamelInfinispanLifespanTime`
    
    -   `CamelInfinispanLifespanTimeUnit`
    
    -   `CamelInfinispanMaxIdleTime`
    
    -   `CamelInfinispanMaxIdleTimeUnit`

<table>
<caption>Get Operations</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.GET</code></p></td>
<td style="text-align: left;"><pre><code>Retrieve the value associated with a specific key from the cache</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.GETORDEFAULT</code></p></td>
<td style="text-align: left;"><pre><code>Retrieves the value, or default value, associated with a specific key from the cache</code></pre></td>
</tr>
</tbody>
</table>

Get Operations

-   **Required Headers**:
    
    -   `CamelInfinispanKey`

<table>
<caption>Contains Key Operation</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.CONTAINSKEY</code></p></td>
<td style="text-align: left;"><pre><code>Determines whether a cache contains a specific key</code></pre></td>
</tr>
</tbody>
</table>

Contains Key Operation

-   **Required Headers**
    
    -   `CamelInfinispanKey`

-   **Result Header**
    
    -   `CamelInfinispanOperationResult`

<table>
<caption>Contains Value Operation</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.CONTAINSVALUE</code></p></td>
<td style="text-align: left;"><pre><code>Determines whether a cache contains a specific value</code></pre></td>
</tr>
</tbody>
</table>

Contains Value Operation

-   **Required Headers**:
    
    -   `CamelInfinispanKey`

<table>
<caption>Remove Operations</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.REMOVE</code></p></td>
<td style="text-align: left;"><pre><code>Removes an entry from a cache, optionally only if the value matches a given one</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.REMOVEASYNC</code></p></td>
<td style="text-align: left;"><pre><code>Asynchronously removes an entry from a cache, optionally only if the value matches a given one</code></pre></td>
</tr>
</tbody>
</table>

Remove Operations

-   **Required Headers**:
    
    -   `CamelInfinispanKey`

-   **Optional Headers**:
    
    -   `CamelInfinispanValue`

-   **Result Header**:
    
    -   `CamelInfinispanOperationResult`

<table>
<caption>Replace Operations</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.REPLACE</code></p></td>
<td style="text-align: left;"><pre><code>Conditionally replaces an entry in the cache, optionally with expiration</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.REPLACEASYNC</code></p></td>
<td style="text-align: left;"><pre><code>Asynchronously conditionally replaces an entry in the cache, optionally with expiration</code></pre></td>
</tr>
</tbody>
</table>

Replace Operations

-   **Required Headers**:
    
    -   `CamelInfinispanKey`
    
    -   `CamelInfinispanValue`
    
    -   `CamelInfinispanOldValue`

-   **Optional Headers**:
    
    -   `CamelInfinispanLifespanTime`
    
    -   `CamelInfinispanLifespanTimeUnit`
    
    -   `CamelInfinispanMaxIdleTime`
    
    -   `CamelInfinispanMaxIdleTimeUnit`

-   **Result Header**:
    
    -   `CamelInfinispanOperationResult`

<table>
<caption>Clear Operations</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.CLEAR</code></p></td>
<td style="text-align: left;"><pre><code>Clears the cache</code></pre></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.CLEARASYNC</code></p></td>
<td style="text-align: left;"><pre><code>Asynchronously clears the cache</code></pre></td>
</tr>
</tbody>
</table>

Clear Operations

<table>
<caption>Size Operation</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.SIZE</code></p></td>
<td style="text-align: left;"><pre><code>Returns the number of entries in the cache</code></pre></td>
</tr>
</tbody>
</table>

Size Operation

-   **Result Header**
    
    -   `CamelInfinispanOperationResult`

<table>
<caption>Stats Operation</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.STATS</code></p></td>
<td style="text-align: left;"><pre><code>Returns statistics about the cache</code></pre></td>
</tr>
</tbody>
</table>

Stats Operation

-   **Result Header**:
    
    -   `CamelInfinispanOperationResult`

<table>
<caption>Query Operation</caption>
<colgroup>
<col style="width: 40%" />
<col style="width: 60%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation Name</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><code>InfinispanOperation.QUERY</code></p></td>
<td style="text-align: left;"><pre><code>Executes a query on the cache</code></pre></td>
</tr>
</tbody>
</table>

Query Operation

-   **Required Headers**:
    
    -   `CamelInfinispanQueryBuilder`

-   **Result Header**:
    
    -   `CamelInfinispanOperationResult`

Write methods like put(key, value) and remove(key) do not return the
previous value by default.

# Examples

-   Put a key/value into a named cache:
    
        from("direct:start")
            .setHeader(InfinispanConstants.OPERATION).constant(InfinispanOperation.PUT) // 
            .setHeader(InfinispanConstants.KEY).constant("123") // 
            .to("infinispan:myCacheName&cacheContainer=#cacheContainer"); // 
    
    -   Set the operation to perform
    
    -   Set the key used to identify the element in the cache
    
    -   Use the configured cache manager `cacheContainer` from the
        registry to put an element to the cache named `myCacheName`
        
        It is possible to configure the lifetime and/or the idle time
        before the entry expires and gets evicted from the cache, as
        example:
        
            from("direct:start")
                .setHeader(InfinispanConstants.OPERATION).constant(InfinispanOperation.GET)
                .setHeader(InfinispanConstants.KEY).constant("123")
                .setHeader(InfinispanConstants.LIFESPAN_TIME).constant(100L) // 
                .setHeader(InfinispanConstants.LIFESPAN_TIME_UNIT).constant(TimeUnit.MILLISECONDS.toString()) // 
                .to("infinispan:myCacheName");
    
    -   Set the lifespan of the entry
    
    -   Set the time unit for the lifespan

-   Queries
    
        from("direct:start")
            .setHeader(InfinispanConstants.OPERATION, InfinispanConstants.QUERY)
            .setHeader(InfinispanConstants.QUERY_BUILDER, new InfinispanQueryBuilder() {
                @Override
                public Query build(QueryFactory<Query> qf) {
                    return qf.from(User.class).having("name").like("%abc%").build();
                }
            })
            .to("infinispan:myCacheName?cacheContainer=#cacheManager") ;

-   Custom Listeners
    
        from("infinispan://?cacheContainer=#cacheManager&customListener=#myCustomListener")
          .to("mock:result");
    
    The instance of `myCustomListener` must exist and Camel should be
    able to look it up from the `Registry`. Users are encouraged to
    extend the
    `org.apache.camel.component.infinispan.embedded.InfinispanEmbeddedCustomListener`
    class and annotate the resulting class with `@Listener` which can be
    found in the package `org.infinispan.notifications`.

# Using the Infinispan based idempotent repository

In this section, we will use the Infinispan based idempotent repository.

Java  
InfinispanEmbeddedConfiguration conf = new InfinispanEmbeddedConfiguration(); //
conf.setConfigurationUri("classpath:infinispan.xml")

    InfinispanEmbeddedIdempotentRepository repo = new InfinispanEmbeddedIdempotentRepository("idempotent");  // 
    repo.setConfiguration(conf);
    
    context.addRoutes(new RouteBuilder() {
        @Override
        public void configure() {
            from("direct:start")
                .idempotentConsumer(header("MessageID"), repo) // 
                .to("mock:result");
        }
    });

1.  Configure the cache

2.  Configure the repository bean

3.  Set the repository to the route

XML  
<bean id="infinispanRepo" class="org.apache.camel.component.infinispan.embedded.InfinispanEmbeddedIdempotentRepository" destroy-method="stop">  
<constructor-arg value="idempotent"/>
<property name="configuration">
<bean class="org.apache.camel.component.infinispan.embedded.InfinispanEmbeddedConfiguration">
<property name="configurationUrl" value="classpath:infinispan.xml"/>
</bean>
</property>
</bean>

    <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
            <from uri="direct:start" />
            <idempotentConsumer idempotentRepository="infinispanRepo"> 
                <header>MessageID</header>
                <to uri="mock:result" />
            </idempotentConsumer>
        </route>
    </camelContext>

1.  Set the name of the cache that will be used by the repository

2.  Configure the repository bean

3.  Set the repository to the route

# Using the Infinispan based aggregation repository

In this section, we will use the Infinispan based aggregation
repository.

Java  
InfinispanEmbeddedConfiguration conf = new InfinispanEmbeddedConfiguration(); //
conf.setConfigurationUri("classpath:infinispan.xml");

    InfinispanEmbeddedAggregationRepository repo = new InfinispanEmbeddedAggregationRepository("aggregation");  // 
    repo.setConfiguration(conf);
    
    context.addRoutes(new RouteBuilder() {
        @Override
        public void configure() {
            from("direct:start")
                    .aggregate(header("MessageID"))
                    .completionSize(3)
                    .aggregationRepository(repo) // 
                    .aggregationStrategy("myStrategy")
                    .to("mock:result");
        }
    });

1.  Configure the cache

2.  Create the repository bean

3.  Set the repository to the route

XML  
<bean id="infinispanRepo" class="org.apache.camel.component.infinispan.embedded.InfinispanEmbeddedAggregationRepository" destroy-method="stop">  
<constructor-arg value="aggregation"/>
<property name="configuration">
<bean class="org.apache.camel.component.infinispan.embedded.InfinispanEmbeddedConfiguration">
<property name="configurationUrl" value="classpath:infinispan.xml"/>
</bean>
</property>
</bean>

    <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
            <from uri="direct:start" />
            <aggregate aggregationStrategy="myStrategy"
                       completionSize="3"
                       aggregationRepository="infinispanRepo"> 
                <correlationExpression>
                    <header>MessageID</header>
                </correlationExpression>
                <to uri="mock:result"/>
            </aggregate>
        </route>
    </camelContext>

1.  Set the name of the cache that will be used by the repository

2.  Configure the repository bean

3.  Set the repository to the route

With the release of Infinispan 11, it is required to set the encoding
configuration on any cache created. This is critical for consuming
events too. For more information, have a look at [Data Encoding and
MediaTypes](https://infinispan.org/docs/stable/titles/developing/developing.html#data_encoding)
in the official Infinispan documentation.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|queryBuilder|Specifies the query builder.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|clusteredListener|If true, the listener will be installed for the entire cluster|false|boolean|
|customListener|Returns the custom listener in use, if provided||object|
|eventTypes|Specifies the set of event types to register by the consumer.Multiple event can be separated by comma. The possible event types are: CACHE\_ENTRY\_ACTIVATED, CACHE\_ENTRY\_PASSIVATED, CACHE\_ENTRY\_VISITED, CACHE\_ENTRY\_LOADED, CACHE\_ENTRY\_EVICTED, CACHE\_ENTRY\_CREATED, CACHE\_ENTRY\_REMOVED, CACHE\_ENTRY\_MODIFIED, TRANSACTION\_COMPLETED, TRANSACTION\_REGISTERED, CACHE\_ENTRY\_INVALIDATED, CACHE\_ENTRY\_EXPIRED, DATA\_REHASHED, TOPOLOGY\_CHANGED, PARTITION\_STATUS\_CHANGED, PERSISTENCE\_AVAILABILITY\_CHANGED||string|
|sync|If true, the consumer will receive notifications synchronously|true|boolean|
|defaultValue|Set a specific default value for some producer operations||object|
|key|Set a specific key for producer operations||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|oldValue|Set a specific old value for some producer operations||object|
|operation|The operation to perform|PUT|object|
|value|Set a specific value for producer operations||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|cacheContainer|Specifies the cache Container to connect||object|
|cacheContainerConfiguration|The CacheContainer configuration. Used if the cacheContainer is not defined.||object|
|configurationUri|An implementation specific URI for the CacheManager||string|
|flags|A comma separated list of org.infinispan.context.Flag to be applied by default on each cache invocation||string|
|remappingFunction|Set a specific remappingFunction to use in a compute operation.||object|
|resultHeader|Store the operation result in a header instead of the message body. By default, resultHeader == null and the query result is stored in the message body, any existing content in the message body is discarded. If resultHeader is set, the value is used as the name of the header to store the query result and the original message body is preserved. This value can be overridden by an in message header named: CamelInfinispanOperationResultHeader||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cacheName|The name of the cache to use. Use current to use the existing cache name from the currently configured cached manager. Or use default for the default cache manager name.||string|
|queryBuilder|Specifies the query builder.||object|
|clusteredListener|If true, the listener will be installed for the entire cluster|false|boolean|
|customListener|Returns the custom listener in use, if provided||object|
|eventTypes|Specifies the set of event types to register by the consumer.Multiple event can be separated by comma. The possible event types are: CACHE\_ENTRY\_ACTIVATED, CACHE\_ENTRY\_PASSIVATED, CACHE\_ENTRY\_VISITED, CACHE\_ENTRY\_LOADED, CACHE\_ENTRY\_EVICTED, CACHE\_ENTRY\_CREATED, CACHE\_ENTRY\_REMOVED, CACHE\_ENTRY\_MODIFIED, TRANSACTION\_COMPLETED, TRANSACTION\_REGISTERED, CACHE\_ENTRY\_INVALIDATED, CACHE\_ENTRY\_EXPIRED, DATA\_REHASHED, TOPOLOGY\_CHANGED, PARTITION\_STATUS\_CHANGED, PERSISTENCE\_AVAILABILITY\_CHANGED||string|
|sync|If true, the consumer will receive notifications synchronously|true|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|defaultValue|Set a specific default value for some producer operations||object|
|key|Set a specific key for producer operations||object|
|oldValue|Set a specific old value for some producer operations||object|
|operation|The operation to perform|PUT|object|
|value|Set a specific value for producer operations||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|cacheContainer|Specifies the cache Container to connect||object|
|cacheContainerConfiguration|The CacheContainer configuration. Used if the cacheContainer is not defined.||object|
|configurationUri|An implementation specific URI for the CacheManager||string|
|flags|A comma separated list of org.infinispan.context.Flag to be applied by default on each cache invocation||string|
|remappingFunction|Set a specific remappingFunction to use in a compute operation.||object|
|resultHeader|Store the operation result in a header instead of the message body. By default, resultHeader == null and the query result is stored in the message body, any existing content in the message body is discarded. If resultHeader is set, the value is used as the name of the header to store the query result and the original message body is preserved. This value can be overridden by an in message header named: CamelInfinispanOperationResultHeader||string|
