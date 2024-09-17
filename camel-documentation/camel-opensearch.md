# Opensearch

**Since Camel 4.0**

**Only producer is supported**

The OpenSearch component allows you to interface with an
[OpenSearch](https://opensearch.org/) 2.8.x API using the Java API
Client library.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-opensearch</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    opensearch://clusterName[?options]

# Usage

## Message Operations

The following [OpenSearch](https://opensearch.org/) operations are
currently supported. Set an endpoint URI option or exchange header with
a key of "operation" and a value set to one of the following. Some
operations also require other parameters or the message body to be set.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">operation</th>
<th style="text-align: left;">message body</th>
<th style="text-align: left;">description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>Index</code></p></td>
<td style="text-align: left;"><p><code>Map</code>, <code>String</code>,
<code>byte[]</code>, <code>Reader</code>, <code>InputStream</code> or
<code>IndexRequest.Builder</code> content to index</p></td>
<td style="text-align: left;"><p>Adds content to an index and returns
the content’s indexId in the body. You can set the name of the target
index by setting the message header with the key "indexName". You can
set the indexId by setting the message header with the key
"indexId".</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>GetById</code></p></td>
<td style="text-align: left;"><p><code>String</code> or
<code>GetRequest.Builder</code> index id of content to retrieve</p></td>
<td style="text-align: left;"><p>Retrieves the document corresponding to
the given index id and returns a GetResponse object in the body. You can
set the name of the target index by setting the message header with the
key "indexName". You can set the type of document by setting the message
header with the key "documentClass".</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>Delete</code></p></td>
<td style="text-align: left;"><p><code>String</code> or
<code>DeleteRequest.Builder</code> index id of content to
delete</p></td>
<td style="text-align: left;"><p>Deletes the specified indexName and
returns a Result object in the body. You can set the name of the target
index by setting the message header with the key "indexName".</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>DeleteIndex</code></p></td>
<td style="text-align: left;"><p><code>String</code> or
<code>DeleteIndexRequest.Builder</code> index name of the index to
delete</p></td>
<td style="text-align: left;"><p>Deletes the specified indexName and
returns a status code in the body. You can set the name of the target
index by setting the message header with the key "indexName".</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>Bulk</code> <code>Iterable</code>
or <code>BulkRequest.Builder</code> of any type that is already accepted
(DeleteOperation.Builder for delete operation, UpdateOperation.Builder
for update operation, CreateOperation.Builder for create operation,
byte[], InputStream, String, Reader, Map or any document type for index
operation)</p></td>
<td style="text-align: left;"><p>Adds/Updates/Deletes content from/to an
index and returns a List&lt;BulkResponseItem&gt; object in the body You
can set the name of the target index by setting the message header with
the key "indexName".</p></td>
<td style="text-align: left;"><p><code>Search</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>Map</code>, <code>String</code>
or <code>SearchRequest.Builder</code></p></td>
<td style="text-align: left;"><p>Search the content with the map of
query string. You can set the name of the target index by setting the
message header with the key "indexName". You can set the number of hits
to return by setting the message header with the key "size". You can set
the starting document offset by setting the message header with the key
"from".</p></td>
<td style="text-align: left;"><p><code>MultiSearch</code></p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>MsearchRequest.Builder</code></p></td>
<td style="text-align: left;"><p>Multiple search in one</p></td>
<td style="text-align: left;"><p><code>MultiGet</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>Iterable&lt;String&gt;</code> or
<code>MgetRequest.Builder</code> the id of the document to
retrieve</p></td>
<td style="text-align: left;"><p>Multiple get in one</p>
<p>You can set the name of the target index by setting the message
header with the key "indexName".</p></td>
<td style="text-align: left;"><p><code>Exists</code></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>None</p></td>
<td style="text-align: left;"><p>Checks whether the index exists or not
and returns a Boolean flag in the body.</p>
<p>You must set the name of the target index by setting the message
header with the key "indexName".</p></td>
<td style="text-align: left;"><p><code>Update</code></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>byte[]</code>,
<code>InputStream</code>, <code>String</code>, <code>Reader</code>,
<code>Map</code> or any document type content to update</p></td>
<td style="text-align: left;"><p>Updates content to an index and returns
the content’s indexId in the body. You can set the name of the target
index by setting the message header with the key "indexName". You can
set the indexId by setting the message header with the key
"indexId".</p></td>
<td style="text-align: left;"><p>Ping</p></td>
</tr>
</tbody>
</table>

## Configure the component and enable basic authentication

To use the OpenSearch component, it has to be configured with a minimum
configuration.

    OpensearchComponent opensearchComponent = new OpensearchComponent();
    opensearchComponent.setHostAddresses("opensearch-host:9200");
    camelContext.addComponent("opensearch", opensearchComponent);

For basic authentication with OpenSearch or using reverse http proxy in
front of the OpenSearch cluster, simply setup basic authentication and
SSL on the component like the example below

    OpenSearchComponent opensearchComponent = new OpenSearchComponent();
    opensearchComponent.setHostAddresses("opensearch-host:9200");
    opensearchComponent.setUser("opensearchuser");
    opensearchComponent.setPassword("secure!!");
    
    camelContext.addComponent("opensearch", opensearchComponent);

## Document type

For all the search operations, it is possible to indicate the type of
document to retrieve to get the result already unmarshalled with the
expected type.

The document type can be set using the header "documentClass" or via the
uri parameter of the same name.

# Examples

## Index Example

Below is a simple INDEX example

    from("direct:index")
      .to("opensearch://opensearch?operation=Index&indexName=twitter");
    
    <route>
        <from uri="direct:index"/>
        <to uri="opensearch://opensearch?operation=Index&amp;indexName=twitter"/>
    </route>

For this operation, you’ll need to specify an indexId header.

A client would simply need to pass a body message containing a Map to
the route. The result body contains the indexId created.

    Map<String, String> map = new HashMap<String, String>();
    map.put("content", "test");
    String indexId = template.requestBody("direct:index", map, String.class);

## Search Example

Searching on specific field(s) and value use the Operation ´Search´.
Pass in the query JSON String or the Map

    from("direct:search")
      .to("opensearch://opensearch?operation=Search&indexName=twitter");
    
    <route>
        <from uri="direct:search"/>
        <to uri="opensearch://opensearch?operation=Search&amp;indexName=twitter"/>
    </route>
    
    String query = "{\"query\":{\"match\":{\"doc.content\":\"new release of ApacheCamel\"}}}";
    HitsMetadata<?> response = template.requestBody("direct:search", query, HitsMetadata.class);

Search on specific field(s) using Map.

    Map<String, Object> actualQuery = new HashMap<>();
    actualQuery.put("doc.content", "new release of ApacheCamel");
    
    Map<String, Object> match = new HashMap<>();
    match.put("match", actualQuery);
    
    Map<String, Object> query = new HashMap<>();
    query.put("query", match);
    HitsMetadata<?> response = template.requestBody("direct:search", query, HitsMetadata.class);

Search using OpenSearch scroll api to fetch all results.

    from("direct:search")
      .to("opensearch://opensearch?operation=Search&indexName=twitter&useScroll=true&scrollKeepAliveMs=30000");
    
    <route>
        <from uri="direct:search"/>
        <to uri="opensearch://opensearch?operation=Search&amp;indexName=twitter&amp;useScroll=true&amp;scrollKeepAliveMs=30000"/>
    </route>
    
    String query = "{\"query\":{\"match\":{\"doc.content\":\"new release of ApacheCamel\"}}}";
    try (OpenSearchScrollRequestIterator response = template.requestBody("direct:search", query, OpenSearchScrollRequestIterator.class)) {
        // do something smart with results
    }

[Split EIP](#eips:split-eip.adoc) can also be used.

    from("direct:search")
      .to("opensearch://opensearch?operation=Search&indexName=twitter&useScroll=true&scrollKeepAliveMs=30000")
      .split()
      .body()
      .streaming()
      .to("mock:output")
      .end();

## MultiSearch Example

MultiSearching on specific field(s) and value uses the Operation
`MultiSearch`. Pass in the MultiSearchRequest instance

    from("direct:multiSearch")
      .to("opensearch://opensearch?operation=MultiSearch");
    
    <route>
        <from uri="direct:multiSearch"/>
        <to uri="opensearch://opensearch?operation=MultiSearch"/>
    </route>

MultiSearch on specific field(s)

    MsearchRequest.Builder builder = new MsearchRequest.Builder().index("twitter").searches(
            new RequestItem.Builder().header(new MultisearchHeader.Builder().build())
                    .body(new MultisearchBody.Builder().query(b -> b.matchAll(x -> x)).build()).build(),
            new RequestItem.Builder().header(new MultisearchHeader.Builder().build())
                    .body(new MultisearchBody.Builder().query(b -> b.matchAll(x -> x)).build()).build());
    List<MultiSearchResponseItem<?>> response = template.requestBody("direct:multiSearch", builder, List.class);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionTimeout|The time in ms to wait before connection will time out.|30000|integer|
|hostAddresses|Comma separated list with ip:port formatted remote transport addresses to use. The ip and port options must be left blank for hostAddresses to be considered instead.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxRetryTimeout|The time in ms before retry|30000|integer|
|socketTimeout|The timeout in ms to wait before the socket will time out.|30000|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|client|To use an existing configured OpenSearch client, instead of creating a client per endpoint. This allows customizing the client with specific settings.||object|
|enableSniffer|Enable automatically discover nodes from a running OpenSearch cluster. If this option is used in conjunction with Spring Boot, then it's managed by the Spring Boot configuration (see: Disable Sniffer in Spring Boot).|false|boolean|
|sniffAfterFailureDelay|The delay of a sniff execution scheduled after a failure (in milliseconds)|60000|integer|
|snifferInterval|The interval between consecutive ordinary sniff executions in milliseconds. Will be honoured when sniffOnFailure is disabled or when there are no failures between consecutive sniff executions|300000|integer|
|enableSSL|Enable SSL|false|boolean|
|password|Password for authenticating||string|
|user|Basic authenticate user||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clusterName|Name of the cluster||string|
|connectionTimeout|The time in ms to wait before connection will time out.|30000|integer|
|disconnect|Disconnect after it finish calling the producer|false|boolean|
|from|Starting index of the response.||integer|
|hostAddresses|Comma separated list with ip:port formatted remote transport addresses to use.||string|
|indexName|The name of the index to act against||string|
|maxRetryTimeout|The time in ms before retry|30000|integer|
|operation|What operation to perform||object|
|scrollKeepAliveMs|Time in ms during which OpenSearch will keep search context alive|60000|integer|
|size|Size of the response.||integer|
|socketTimeout|The timeout in ms to wait before the socket will time out.|30000|integer|
|useScroll|Enable scroll usage|false|boolean|
|waitForActiveShards|Index creation waits for the write consistency number of shards to be available|1|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|documentClass|The class to use when deserializing the documents.|ObjectNode|string|
|enableSniffer|Enable automatically discover nodes from a running OpenSearch cluster. If this option is used in conjunction with Spring Boot, then it's managed by the Spring Boot configuration (see: Disable Sniffer in Spring Boot).|false|boolean|
|sniffAfterFailureDelay|The delay of a sniff execution scheduled after a failure (in milliseconds)|60000|integer|
|snifferInterval|The interval between consecutive ordinary sniff executions in milliseconds. Will be honoured when sniffOnFailure is disabled or when there are no failures between consecutive sniff executions|300000|integer|
|certificatePath|The certificate that can be used to access the ES Cluster. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|enableSSL|Enable SSL|false|boolean|
