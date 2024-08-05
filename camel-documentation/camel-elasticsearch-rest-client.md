# Elasticsearch-rest-client

**Since Camel 4.3**

**Only producer is supported**

The ElasticSearch component allows you to interface with
[ElasticSearch](https://www.elastic.co/products/elasticsearch) 8.x API
or [OpenSearch](https://opensearch.org/) using the ElasticSearch Java
Low level Rest Client.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-elasticsearch-rest-client</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    elasticsearch-rest-client://clusterName[?options]

# Elasticsearch Low level Rest Client Operations

The following operations are currently supported.

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
<td style="text-align: left;"><p><code>INDEX_OR_UPDATE</code></p></td>
<td style="text-align: left;"><p><code>String</code>,
<code>byte[]</code>, <code>Reader</code> or <code>InputStream</code>
content to index or update</p></td>
<td style="text-align: left;"><p>Adds or updates content to an index and
returns the resulting <code>id</code> in the message body. You can set
the name of the target index from the <code>indexName</code> URI
parameter option, or by providing a message header with the key
<code>INDEX_NAME</code>. When updating indexed content, you must provide
its id via a message header with the key <code>ID</code> .</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>GET_BY_ID</code></p></td>
<td style="text-align: left;"><p><code>String</code> id of content to
retrieve</p></td>
<td style="text-align: left;"><p>Retrieves a JSON String representation
of the indexed document, corresponding to the given index id and sets it
as the message exchange body. You can set the name of the target index
from the <code>indexName</code> URI parameter option, or by providing a
message header with the key <code>INDEX_NAME</code>. You must provide
the index id of the content to retrieve either in the message body, or
via a message header with the key <code>ID</code> .</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>DELETE</code></p></td>
<td style="text-align: left;"><p><code>String</code> id of content to
delete</p></td>
<td style="text-align: left;"><p>Deletes the specified
<code>indexName</code> and returns a <code>boolean</code> value as the
message exchange body, indicating whether the operation was successful.
You can set the name of the target index from the <code>indexName</code>
URI parameter option, or by providing a message header with the key
<code>INDEX_NAME</code>. You must provide the index id of the content to
delete either in the message body, or via a message header with the key
<code>ID</code> .</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>CREATE_INDEX</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Creates the specified
<code>indexName</code> and returns a <code>boolean</code> value as the
message exchange body, indicating whether the operation was successful.
You can set the name of the target index to create from the
<code>indexName</code> URI parameter option, or by providing a message
header with the key <code>INDEX_NAME</code>. You may also provide a
header with the key <code>INDEX_SETTINGS</code> where the value is a
JSON String representation of the index settings.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>DELETE_INDEX</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Deletes the specified
<code>indexName</code> and returns a <code>boolean</code> value as the
message exchange body, indicating whether the operation was successful.
You can set the name of the target index to create from the
<code>indexName</code> URI parameter option, or by providing a message
header with the key <code>INDEX_NAME</code>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>SEARCH</code></p></td>
<td style="text-align: left;"><p><code>Map</code> (optional)</p></td>
<td style="text-align: left;"><p>Search for content with either a
<code>Map</code> of <code>String</code> keys &amp; values of query
criteria. Or a JSON string representation of the query. Matching
documents are returned as a JSON string set on the message exchange
body. You can set the JSON query String by providing a message header
with the key <code>SEARCH_QUERY</code>. You can set the message exchange
body to a <code>Map</code> of <code>String</code> keys &amp; values for
the query criteria.</p></td>
</tr>
</tbody>
</table>

# Index Content Example

To index some content.

    from("direct:index")
        .setBody().constant("{\"content\": \"ElasticSearch With Camel\"}")
        .to("elasticsearch-rest-client://myCluster?operation=INDEX_OR_UPDATE&indexName=myIndex");

To update existing indexed content, provide the `ID` message header and
the message body with the updated content.

    from("direct:index")
        .setHeader("ID").constant("1")
        .setBody().constant("{\"content\": \"ElasticSearch REST Client With Camel\"}")
        .to("elasticsearch-rest-client://myCluster?operation=INDEX_OR_UPDATE&indexName=myIndex");

# Get By ID Example

    from("direct:getById")
        .setHeader("ID").constant("1")
        .to("elasticsearch-rest-client://myCluster?operation=GET_BY_ID&indexName=myIndex");

# Delete Example

To delete indexed content, provide the `ID` message header.

    from("direct:getById")
        .setHeader("ID").constant("1")
        .to("elasticsearch-rest-client://myCluster?operation=DELETE&indexName=myIndex");

# Create Index Example

To create a new index.

    from("direct:createIndex")
        .to("elasticsearch-rest-client://myCluster?operation=CREATE_INDEX&indexName=myIndex");

To create a new index with some custom settings.

    String indexSettings = "{\"settings\":{\"number_of_replicas\": 1,\"number_of_shards\": 3,\"analysis\": {},\"refresh_interval\": \"1s\"},\"mappings\":{\"dynamic\": false,\"properties\": {\"title\": {\"type\": \"text\", \"analyzer\": \"english\"}}}}";
    
    from("direct:createIndex")
        .setHeader("INDEX_SETTINGS").constant(indexSettings)
        .to("elasticsearch-rest-client://myCluster?operation=CREATE_INDEX&indexName=myIndex");

# Delete Index Example

To delete an index.

    from("direct:deleteIndex")
        .to("elasticsearch-rest-client://myCluster?operation=DELETE_INDEX&indexName=myIndex");

# Search Example

Search with a JSON query.

    from("direct:search")
        .setHeader("SEARCH_QUERY").constant("{\"query\":{\"match\":{\"content\":\"ElasticSearch With Camel\"}}}")
        .to("elasticsearch-rest-client://myCluster?operation=SEARCH&indexName=myIndex");

Search on specific field(s) using `Map`.

    Map<String, String> criteria = new HashMap<>();
    criteria.put("content", "Camel");
    
    from("direct:search")
        .setBody().constant(criteria)
        .to("elasticsearch-rest-client://myCluster?operation=SEARCH&indexName=myIndex");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|connectionTimeout|Connection timeout|30000|integer|
|hostAddressesList|List of host Addresses, multiple hosts can be separated by comma.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|socketTimeout|Socket timeout|30000|integer|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|enableSniffer|Enabling Sniffer|false|boolean|
|restClient|Rest Client of type org.elasticsearch.client.RestClient. This is only for advanced usage||object|
|sniffAfterFailureDelay|Sniffer after failure delay (in millis)|60000|integer|
|snifferInterval|Sniffer interval (in millis)|60000|integer|
|certificatePath|Certificate Path||string|
|password|Password||string|
|user|Username||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clusterName|Cluster Name||string|
|connectionTimeout|Connection timeout|30000|integer|
|hostAddressesList|List of host Addresses, multiple hosts can be separated by comma.||string|
|indexName|Index Name||string|
|operation|Operation||object|
|socketTimeout|Socket timeout|30000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|enableSniffer|Enabling Sniffer|false|boolean|
|restClient|Rest Client of type org.elasticsearch.client.RestClient. This is only for advanced usage||object|
|sniffAfterFailureDelay|Sniffer after failure delay (in millis)|60000|integer|
|snifferInterval|Sniffer interval (in millis)|60000|integer|
|certificatePath|Certificate Path||string|
|password|Password||string|
|user|Username||string|
