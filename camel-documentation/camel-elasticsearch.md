# Elasticsearch

**Since Camel 3.19**

**Only producer is supported**

The ElasticSearch component allows you to interface with an
[ElasticSearch](https://www.elastic.co/products/elasticsearch) 8.x API
using the Java API Client library.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-elasticsearch</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    elasticsearch://clusterName[?options]

# Message Operations

The following ElasticSearch operations are currently supported. Set an
endpoint URI option or exchange header with a key of "operation" and a
value set to one of the following. Some operations also require other
parameters or the message body to be set.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">operation</th>
<th style="text-align: left;">message body</th>
<th style="text-align: left;">description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>Index</p></td>
<td style="text-align: left;"><p><strong>Map</strong>,
<strong>String</strong>, <strong>byte[]</strong>,
<strong>Reader</strong>, <strong>InputStream</strong> or
<strong>IndexRequest.Builder</strong> content to index</p></td>
<td style="text-align: left;"><p>Adds content to an index and returns
the content’s indexId in the body. You can set the name of the target
index by setting the message header with the key "indexName". You can
set the indexId by setting the message header with the key
"indexId".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>GetById</p></td>
<td style="text-align: left;"><p><strong>String</strong> or
<strong>GetRequest.Builder</strong> index id of content to
retrieve</p></td>
<td style="text-align: left;"><p>Retrieves the document corresponding to
the given index id and returns a <code>GetResponse</code> object in the
body. You can set the name of the target index by setting the message
header with the key "indexName". You can set the type of document by
setting the message header with the key "documentClass".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Delete</p></td>
<td style="text-align: left;"><p><strong>String</strong> or
<strong>DeleteRequest.Builder</strong> index id of content to
delete</p></td>
<td style="text-align: left;"><p>Deletes the specified indexName and
returns a Result object in the body. You can set the name of the target
index by setting the message header with the key "indexName".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>DeleteIndex</p></td>
<td style="text-align: left;"><p><strong>String</strong> or
<strong>DeleteIndexRequest.Builder</strong> index name of the index to
delete</p></td>
<td style="text-align: left;"><p>Deletes the specified indexName and
returns a status code in the body. You can set the name of the target
index by setting the message header with the key "indexName".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Bulk</p></td>
<td style="text-align: left;"><p><strong>Iterable</strong> or
<strong>BulkRequest.Builder</strong> of any type that is already
accepted (DeleteOperation.Builder for delete operation,
UpdateOperation.Builder for update operation, CreateOperation.Builder
for create operation, byte[], InputStream, String, Reader, Map or any
document type for index operation)</p></td>
<td style="text-align: left;"><p>Adds/Updates/Deletes content from/to an
index and returns a List&lt;BulkResponseItem&gt; object in the body You
can set the name of the target index by setting the message header with
the key "indexName".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Search</p></td>
<td style="text-align: left;"><p><strong>Map</strong>,
<strong>String</strong> or
<strong>SearchRequest.Builder</strong></p></td>
<td style="text-align: left;"><p>Search the content with the map of
query string. You can set the name of the target index by setting the
message header with the key "indexName". You can set the number of hits
to return by setting the message header with the key "size". You can set
the starting document offset by setting the message header with the key
"from".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>MultiSearch</p></td>
<td
style="text-align: left;"><p><strong>MsearchRequest.Builder</strong></p></td>
<td style="text-align: left;"><p>Multiple search in one</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>MultiGet</p></td>
<td style="text-align: left;"><p><strong>Iterable&lt;String&gt;</strong>
or <strong>MgetRequest.Builder</strong> the id of the document to
retrieve</p></td>
<td style="text-align: left;"><p>Multiple get in one</p>
<p>You can set the name of the target index by setting the message
header with the key "indexName".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Exists</p></td>
<td style="text-align: left;"><p>None</p></td>
<td style="text-align: left;"><p>Check whether the index exists or not
and returns a Boolean flag in the body.</p>
<p>You must set the name of the target index by setting the message
header with the key "indexName".</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Update</p></td>
<td style="text-align: left;"><p><strong>byte[]</strong>,
<strong>InputStream</strong>, <strong>String</strong>,
<strong>Reader</strong>, <strong>Map</strong> or any document type
content to update</p></td>
<td style="text-align: left;"><p>Updates content to an index and returns
the content’s indexId in the body. You can set the name of the target
index by setting the message header with the key "indexName". You can
set the indexId by setting the message header with the key "indexId". Be
aware of the fact that unlike the component
<em>camel-elasticsearch-rest</em>, by default, the expected content of
an update request must be the same as what the <a
href="https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html">Update
API expects</a>, consequently if you want to update one part of an
existing document, you need to embed the content to update into a "doc"
object. To change the default behavior, it is possible to configure it
globally at the component level thanks to the option
<em>enableDocumentOnlyMode</em> or by request by setting the header
<em>ElasticsearchConstants.PARAM_DOCUMENT_MODE</em> to true.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>Ping</p></td>
<td style="text-align: left;"><p>None</p></td>
<td style="text-align: left;"><p>Pings the Elasticsearch cluster and
returns true if the ping succeeded, false otherwise</p></td>
</tr>
</tbody>
</table>

# Configure the component and enable basic authentication

To use the Elasticsearch component, it has to be configured with a
minimum configuration.

    ElasticsearchComponent elasticsearchComponent = new ElasticsearchComponent();
    elasticsearchComponent.setHostAddresses("myelkhost:9200");
    camelContext.addComponent("elasticsearch", elasticsearchComponent);

For basic authentication with elasticsearch or using reverse http proxy
in front of the elasticsearch cluster, simply setup basic authentication
and SSL on the component like the example below

    ElasticsearchComponent elasticsearchComponent = new ElasticsearchComponent();
    elasticsearchComponent.setHostAddresses("myelkhost:9200");
    elasticsearchComponent.setUser("elkuser");
    elasticsearchComponent.setPassword("secure!!");
    elasticsearchComponent.setEnableSSL(true);
    elasticsearchComponent.setCertificatePath(certPath);
    
    camelContext.addComponent("elasticsearch", elasticsearchComponent);

# Index Example

Below is a simple INDEX example

    from("direct:index")
      .to("elasticsearch://elasticsearch?operation=Index&indexName=twitter");
    
    <route>
        <from uri="direct:index"/>
        <to uri="elasticsearch://elasticsearch?operation=Index&amp;indexName=twitter"/>
    </route>

**For this operation, you’ll need to specify an `indexId` header.**

A client would simply need to pass a body message containing a Map to
the route. The result body contains the indexId created.

    Map<String, String> map = new HashMap<String, String>();
    map.put("content", "test");
    String indexId = template.requestBody("direct:index", map, String.class);

# Search Example

Searching on specific field(s) and value use the Operation ´Search´.
Pass in the query JSON String or the Map

    from("direct:search")
      .to("elasticsearch://elasticsearch?operation=Search&indexName=twitter");
    
    <route>
        <from uri="direct:search"/>
        <to uri="elasticsearch://elasticsearch?operation=Search&amp;indexName=twitter"/>
    </route>
    
    String query = "{\"query\":{\"match\":{\"content\":\"new release of ApacheCamel\"}}}";
    HitsMetadata<?> response = template.requestBody("direct:search", query, HitsMetadata.class);

Search on specific field(s) using Map.

    Map<String, Object> actualQuery = new HashMap<>();
    actualQuery.put("content", "new release of ApacheCamel");
    
    Map<String, Object> match = new HashMap<>();
    match.put("match", actualQuery);
    
    Map<String, Object> query = new HashMap<>();
    query.put("query", match);
    HitsMetadata<?> response = template.requestBody("direct:search", query, HitsMetadata.class);

Search using Elasticsearch scroll api to fetch all results.

    from("direct:search")
      .to("elasticsearch://elasticsearch?operation=Search&indexName=twitter&useScroll=true&scrollKeepAliveMs=30000");
    
    <route>
        <from uri="direct:search"/>
        <to uri="elasticsearch://elasticsearch?operation=Search&amp;indexName=twitter&amp;useScroll=true&amp;scrollKeepAliveMs=30000"/>
    </route>
    
    String query = "{\"query\":{\"match\":{\"content\":\"new release of ApacheCamel\"}}}";
    try (ElasticsearchScrollRequestIterator response = template.requestBody("direct:search", query, ElasticsearchScrollRequestIterator.class)) {
        // do something smart with results
    }

[Split EIP](#eips:split-eip.adoc) can also be used.

    from("direct:search")
      .to("elasticsearch://elasticsearch?operation=Search&indexName=twitter&useScroll=true&scrollKeepAliveMs=30000")
      .split()
      .body()
      .streaming()
      .to("mock:output")
      .end();

# MultiSearch Example

MultiSearching on specific field(s) and value uses the Operation
´MultiSearch´. Pass in the MultiSearchRequest instance

    from("direct:multiSearch")
      .to("elasticsearch://elasticsearch?operation=MultiSearch");
    
    <route>
        <from uri="direct:multiSearch"/>
        <to uri="elasticsearch://elasticsearch?operation=MultiSearch"/>
    </route>

MultiSearch on specific field(s)

    MsearchRequest.Builder builder = new MsearchRequest.Builder().index("twitter").searches(
            new RequestItem.Builder().header(new MultisearchHeader.Builder().build())
                    .body(new MultisearchBody.Builder().query(b -> b.matchAll(x -> x)).build()).build(),
            new RequestItem.Builder().header(new MultisearchHeader.Builder().build())
                    .body(new MultisearchBody.Builder().query(b -> b.matchAll(x -> x)).build()).build());
    List<MultiSearchResponseItem<?>> response = template.requestBody("direct:multiSearch", builder, List.class);

# Document type

For all the search operations, it is possible to indicate the type of
document to retrieve to get the result already unmarshalled with the
expected type.

The document type can be set using the header "documentClass" or via the
uri parameter of the same name.

# Using Camel Elasticsearch with Spring Boot

When you use `camel-elasticsearch-starter` with Spring Boot v2, then you
must declare the following dependency in your own `pom.xml`.

    <dependency>
      <groupId>jakarta.json</groupId>
      <artifactId>jakarta.json-api</artifactId>
      <version>2.0.2</version>
    </dependency>

This is needed because Spring Boot v2 provides jakarta.json-api:1.1.6,
and Elasticsearch requires to use json-api v2.

## Use RestClient provided by Spring Boot

By default, Spring Boot will auto configure an Elasticsearch RestClient
that will be used by camel, it is possible to customize the client with
the following basic properties:

    spring.elasticsearch.uris=myelkhost:9200
    spring.elasticsearch.username=elkuser
    spring.elasticsearch.password=secure!!

More information can be found in
[https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#application-properties.data.spring.elasticsearch.connection-timeout](https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#application-properties.data.spring.elasticsearch.connection-timeout)

## Disable Sniffer when using Spring Boot

When Spring Boot is on the classpath, the Sniffer client for
Elasticsearch is enabled by default. This option can be disabled in the
Spring Boot Configuration:

    spring:
      autoconfigure:
        exclude: org.springframework.boot.autoconfigure.elasticsearch.ElasticsearchRestClientAutoConfiguration

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionTimeout|The time in ms to wait before connection will timeout.|30000|integer|
|enableDocumentOnlyMode|Indicates whether the body of the message contains only documents. By default, it is set to false to be able to do the same requests as what the Document API supports (see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html for more details). To ease the migration of routes based on the legacy component camel-elasticsearch-rest, you should consider enabling the mode especially if your routes do update operations.|false|boolean|
|hostAddresses|Comma separated list with ip:port formatted remote transport addresses to use. The ip and port options must be left blank for hostAddresses to be considered instead.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|maxRetryTimeout|The time in ms before retry|30000|integer|
|socketTimeout|The timeout in ms to wait before the socket will timeout.|30000|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|client|To use an existing configured Elasticsearch client, instead of creating a client per endpoint. This allow to customize the client with specific settings.||object|
|enableSniffer|Enable automatically discover nodes from a running Elasticsearch cluster. If this option is used in conjunction with Spring Boot then it's managed by the Spring Boot configuration (see: Disable Sniffer in Spring Boot).|false|boolean|
|sniffAfterFailureDelay|The delay of a sniff execution scheduled after a failure (in milliseconds)|60000|integer|
|snifferInterval|The interval between consecutive ordinary sniff executions in milliseconds. Will be honoured when sniffOnFailure is disabled or when there are no failures between consecutive sniff executions|300000|integer|
|certificatePath|The path of the self-signed certificate to use to access to Elasticsearch.||string|
|enableSSL|Enable SSL|false|boolean|
|password|Password for authenticate||string|
|user|Basic authenticate user||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clusterName|Name of the cluster||string|
|connectionTimeout|The time in ms to wait before connection will timeout.|30000|integer|
|disconnect|Disconnect after it finish calling the producer|false|boolean|
|enableDocumentOnlyMode|Indicates whether the body of the message contains only documents. By default, it is set to false to be able to do the same requests as what the Document API supports (see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html for more details). To ease the migration of routes based on the legacy component camel-elasticsearch-rest, you should consider enabling the mode especially if your routes do update operations.|false|boolean|
|from|Starting index of the response.||integer|
|hostAddresses|Comma separated list with ip:port formatted remote transport addresses to use.||string|
|indexName|The name of the index to act against||string|
|maxRetryTimeout|The time in ms before retry|30000|integer|
|operation|What operation to perform||object|
|scrollKeepAliveMs|Time in ms during which elasticsearch will keep search context alive|60000|integer|
|size|Size of the response.||integer|
|socketTimeout|The timeout in ms to wait before the socket will timeout.|30000|integer|
|useScroll|Enable scroll usage|false|boolean|
|waitForActiveShards|Index creation waits for the write consistency number of shards to be available|1|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|documentClass|The class to use when deserializing the documents.|ObjectNode|string|
|enableSniffer|Enable automatically discover nodes from a running Elasticsearch cluster. If this option is used in conjunction with Spring Boot then it's managed by the Spring Boot configuration (see: Disable Sniffer in Spring Boot).|false|boolean|
|sniffAfterFailureDelay|The delay of a sniff execution scheduled after a failure (in milliseconds)|60000|integer|
|snifferInterval|The interval between consecutive ordinary sniff executions in milliseconds. Will be honoured when sniffOnFailure is disabled or when there are no failures between consecutive sniff executions|300000|integer|
|certificatePath|The certificate that can be used to access the ES Cluster. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|enableSSL|Enable SSL|false|boolean|
