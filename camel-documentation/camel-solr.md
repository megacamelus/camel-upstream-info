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

# Message Operations

The following Solr operations are currently supported. Simply set an
exchange header with a key of "SolrOperation" and a value set to one of
the following. Some operations also require the message body to be set.

-   INSERT

-   INSERT\_STREAMING

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Operation</th>
<th style="text-align: left;">Message body</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>INSERT/INSERT_STREAMING</p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>adds an index using message headers
(must be prefixed with "SolrField.")</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>INSERT/INSERT_STREAMING</p></td>
<td style="text-align: left;"><p>File</p></td>
<td style="text-align: left;"><p>adds an index using the given File
(using ContentStreamUpdateRequest)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>INSERT/INSERT_STREAMING</p></td>
<td style="text-align: left;"><p>SolrInputDocument</p></td>
<td style="text-align: left;"><p>updates index based on the given
SolrInputDocument</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>INSERT/INSERT_STREAMING</p></td>
<td style="text-align: left;"><p>String XML</p></td>
<td style="text-align: left;"><p>updates index based on the given XML
(must follow SolrInputDocument format)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>ADD_BEAN</p></td>
<td style="text-align: left;"><p>bean instance</p></td>
<td style="text-align: left;"><p>adds an index based on values in an <a
href="http://wiki.apache.org/solr/Solrj#Directly_adding_POJOs_to_Solr">annotated
bean</a></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>ADD_BEANS</p></td>
<td style="text-align: left;"><p>collection&lt;bean&gt;</p></td>
<td style="text-align: left;"><p>adds index based on a collection of <a
href="http://wiki.apache.org/solr/Solrj#Directly_adding_POJOs_to_Solr">annotated
bean</a></p></td>
</tr>
<tr>
<td style="text-align: left;"><p>DELETE_BY_ID</p></td>
<td style="text-align: left;"><p>index id to delete</p></td>
<td style="text-align: left;"><p>delete a record by ID</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>DELETE_BY_QUERY</p></td>
<td style="text-align: left;"><p>query string</p></td>
<td style="text-align: left;"><p>delete a record by a query</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>COMMIT</p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a commit on any pending index
changes</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>SOFT_COMMIT</p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a <code>soft commit</code>
(without guarantee that Lucene index files are written to stable
storage; useful for Near Real Time operations) on any pending index
changes</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>ROLLBACK</p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a rollback on any pending
index changes</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>OPTIMIZE</p></td>
<td style="text-align: left;"><p>n/a</p></td>
<td style="text-align: left;"><p>performs a commit on any pending index
changes and then runs the optimize command (This command reorganizes the
Solr index and might be a heavy task)</p></td>
</tr>
</tbody>
</table>

# Example

Below is a simple INSERT, DELETE and COMMIT example

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

# Querying Solr

The components provide a producer operation to query Solr.

For more information:

[Solr Query
Syntax](https://solr.apache.org/guide/solr/latest/query-guide/standard-query-parser.html)

## Component ConfigurationsThere are no configurations for this component

## Endpoint ConfigurationsThere are no configurations for this component
