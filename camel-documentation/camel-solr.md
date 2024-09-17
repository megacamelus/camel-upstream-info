# Solr

**Since Camel 4.8**

**Only producer is supported**

The Solr component allows you to interface with an [Apache
Solr](https://solr.apache.org/) server.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-solr</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    solr://host[:port]/solr?[options]
    solrs://host[:port]/solr?[options]
    solrCloud://host[:port]/solr?[options]

# Usage

## Message Operations

The following Solr operations are currently supported. Set an exchange
header with a key of `SolrOperation` and a value set to one of the
following. Some operations also require the message body to be set.

-   `INSERT`

-   `INSERT_STREAMING`

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Message body</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>INSERT/INSERT_STREAMING</code></p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>adds an index using message headers
(must be prefixed with "SolrField.")</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>INSERT/INSERT_STREAMING</code></p></td>
<td style="text-align: left;"><p>File</p></td>
<td style="text-align: left;"><p>adds an index using the given File
(using <code>ContentStreamUpdateRequest</code>)</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>INSERT/INSERT_STREAMING</code></p></td>
<td style="text-align: left;"><p><code>SolrInputDocument</code></p></td>
<td style="text-align: left;"><p>updates index based on the given
<code>SolrInputDocument</code></p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>INSERT/INSERT_STREAMING</code></p></td>
<td style="text-align: left;"><p>String XML</p></td>
<td style="text-align: left;"><p>updates index based on the given XML
(must follow <code>SolrInputDocument</code> format)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>ADD_BEAN</code></p></td>
<td style="text-align: left;"><p>bean instance</p></td>
<td style="text-align: left;"><p>adds an index based on values in an <a
href="http://wiki.apache.org/solr/Solrj#Directly_adding_POJOs_to_Solr">annotated
bean</a></p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>ADD_BEANS</code></p></td>
<td
style="text-align: left;"><p><code>collection&lt;bean&gt;</code></p></td>
<td style="text-align: left;"><p>adds index based on a collection of <a
href="http://wiki.apache.org/solr/Solrj#Directly_adding_POJOs_to_Solr">annotated
bean</a></p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>DELETE_BY_ID</code></p></td>
<td style="text-align: left;"><p>index id to delete</p></td>
<td style="text-align: left;"><p>delete a record by ID</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>DELETE_BY_QUERY</code></p></td>
<td style="text-align: left;"><p>query string</p></td>
<td style="text-align: left;"><p>delete a record by a query</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>COMMIT</code></p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a commit on any pending index
changes</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>SOFT_COMMIT</code></p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a <code>soft commit</code>
(without guarantee that Lucene index files are written to stable
storage; useful for Near Real Time operations) on any pending index
changes</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>ROLLBACK</code></p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a rollback on any pending
index changes</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>OPTIMIZE</code></p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a commit on any pending index
changes and then runs the optimize command (This command reorganizes the
Solr index and might be a heavy task)</p></td>
</tr>
</tbody>
</table>

# Example

Below is a simple `INSERT`, `DELETE` and `COMMIT` example

    from("direct:insert")
        .setHeader(SolrConstants.OPERATION, constant(SolrConstants.OPERATION_INSERT))
        .setHeader(SolrConstants.FIELD + "id", body())
        .to("solr://localhost:8983/solr");
    
    from("direct:delete")
        .setHeader(SolrConstants.OPERATION, constant(SolrConstants.OPERATION_DELETE_BY_ID))
        .to("solr://localhost:8983/solr");
    
    from("direct:commit")
        .setHeader(SolrConstants.OPERATION, constant(SolrConstants.OPERATION_COMMIT))
        .to("solr://localhost:8983/solr");
    
    <route>
        <from uri="direct:insert"/>
        <setHeader name="SolrOperation">
            <constant>INSERT</constant>
        </setHeader>
        <setHeader name="SolrField.id">
            <simple>${body}</simple>
        </setHeader>
        <to uri="solr://localhost:8983/solr"/>
    </route>
    <route>
        <from uri="direct:delete"/>
        <setHeader name="SolrOperation">
            <constant>DELETE_BY_ID</constant>
        </setHeader>
        <to uri="solr://localhost:8983/solr"/>
    </route>
    <route>
        <from uri="direct:commit"/>
        <setHeader name="SolrOperation">
            <constant>COMMIT</constant>
        </setHeader>
        <to uri="solr://localhost:8983/solr"/>
    </route>

A client would simply need to pass a body message to the insert or
delete routes and then call the commit route.

    template.sendBody("direct:insert", "1234");
    template.sendBody("direct:commit", null);
    template.sendBody("direct:delete", "1234");
    template.sendBody("direct:commit", null);

## Querying Solr

The components provide a producer operation to query Solr.

For more information:

[Solr Query
Syntax](https://solr.apache.org/guide/solr/latest/query-guide/standard-query-parser.html)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|url|Hostname and port for the Solr server(s). Multiple hosts can be specified, separated with a comma. See the solrClient parameter for more information on the SolrClient used to connect to Solr.||string|
|autoCommit|If true, each producer operation will be automatically followed by a commit|false|boolean|
|connectionTimeout|Sets the connection timeout on the SolrClient||integer|
|defaultMaxConnectionsPerHost|maxConnectionsPerHost on the underlying HttpConnectionManager||integer|
|httpClient|Sets the http client to be used by the solrClient. This is only applicable when solrClient is not set.||object|
|maxRetries|Maximum number of retries to attempt in the event of transient errors||integer|
|maxTotalConnections|maxTotalConnection on the underlying HttpConnectionManager||integer|
|requestHandler|Set the request handler to be used||string|
|solrClient|Uses the provided solr client to connect to solr. When this parameter is not specified, camel applies the following rules to determine the SolrClient: 1) when zkHost or zkChroot (=zookeeper root) parameter is set, then the CloudSolrClient is used. 2) when multiple hosts are specified in the uri (separated with a comma), then the CloudSolrClient (uri scheme is 'solrCloud') or the LBHttpSolrClient (uri scheme is not 'solrCloud') is used. 3) when the solr operation is INSERT\_STREAMING, then the ConcurrentUpdateSolrClient is used. 4) otherwise, the HttpSolrClient is used. Note: A CloudSolrClient should point to zookeeper endpoint(s); other clients point to Solr endpoint(s). The SolrClient can also be set via the exchange header 'CamelSolrClient'.||object|
|soTimeout|Sets the socket timeout on the SolrClient||integer|
|streamingQueueSize|Sets the queue size for the ConcurrentUpdateSolrClient|10|integer|
|streamingThreadCount|Sets the number of threads for the ConcurrentUpdateSolrClient|2|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|collection|Set the default collection for SolrCloud||string|
|zkChroot|Set the chroot of the zookeeper connection (include the leading slash; e.g. '/mychroot')||string|
|zkHost|Set the ZooKeeper host(s) urls which the CloudSolrClient uses, e.g. zkHost=localhost:2181,localhost:2182. Optionally add the chroot, e.g. zkHost=localhost:2181,localhost:2182/rootformysolr. In case the first part of the url path (='contextroot') is set to 'solr' (e.g. 'localhost:2181/solr' or 'localhost:2181/solr/..'), then that path is not considered as zookeeper chroot for backward compatibility reasons (this behaviour can be overridden via zkChroot parameter).||string|
|allowCompression|Server side must support gzip or deflate for this to have any effect||boolean|
|followRedirects|Indicates whether redirects are used to get to the Solr server||boolean|
|password|Sets password for basic auth plugin enabled servers||string|
|username|Sets username for basic auth plugin enabled servers||string|
