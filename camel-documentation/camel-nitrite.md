# Nitrite

**Since Camel 3.0**

**Both producer and consumer are supported**

Nitrite component is used to access [Nitrite NoSQL
database](https://github.com/dizitart/nitrite-database)

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-nitrite</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

## Producer operations

The following Operations are available to specify as
`NitriteConstants.OPERATION` when producing to Nitrite.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 19%" />
<col style="width: 10%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Class</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Parameters</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>FindCollectionOperation</code></p></td>
<td style="text-align: left;"><p><code>collection</code></p></td>
<td
style="text-align: left;"><p><code>Filter(optional), FindOptions(optional)</code></p></td>
<td style="text-align: left;"><p>Find Documents in collection by Filter.
If not specified, returns all documents</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>RemoveCollectionOperation</code></p></td>
<td style="text-align: left;"><p><code>collection</code></p></td>
<td
style="text-align: left;"><p><code>Filter(required), RemoveOptions(optional)</code></p></td>
<td style="text-align: left;"><p>Remove documents matching
Filter</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>UpdateCollectionOperation</code></p></td>
<td style="text-align: left;"><p><code>collection</code></p></td>
<td
style="text-align: left;"><p><code>Filter(required), UpdateOptions(optional), Document(optional)</code></p></td>
<td style="text-align: left;"><p>Update documents matching Filter. If
Document not specified, the message body is used</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CreateIndexOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td
style="text-align: left;"><p><code>field:String(required), IndexOptions(required)</code></p></td>
<td style="text-align: left;"><p>Create index with IndexOptions on
field</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>DropIndexOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td
style="text-align: left;"><p><code>field:String(required)</code></p></td>
<td style="text-align: left;"><p>Drop index on field</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>ExportDatabaseOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td
style="text-align: left;"><p><code>ExportOptions(optional)</code></p></td>
<td style="text-align: left;"><p>Export full database to JSON and stores
result in body - see Nitrite docs for details about format</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>GetAttributesOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code></code></p></td>
<td style="text-align: left;"><p>Get attributes of a collection</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>GetByIdOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code>NitriteId</code></p></td>
<td style="text-align: left;"><p>Get Document by _id</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>ImportDatabaseOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code></code></p></td>
<td style="text-align: left;"><p>Import the full database from JSON in
body</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>InsertOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code>payload(optional)</code></p></td>
<td style="text-align: left;"><p>Insert document to collection or object
to ObjectRepository. If parameter is not specified, inserts message
body</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>ListIndicesOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code></code></p></td>
<td style="text-align: left;"><p>List indexes in collection and stores
<code>List&lt;Index&gt;</code> in message body</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>RebuildIndexOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td
style="text-align: left;"><p><code>field (required), async (optional)</code></p></td>
<td style="text-align: left;"><p>Rebuild existing index on
field</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>UpdateOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code>payload(optional)</code></p></td>
<td style="text-align: left;"><p>Update document in collection or object
in ObjectRepository. If parameter is not specified, updates document
from message body</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>UpsertOperation</code></p></td>
<td style="text-align: left;"><p><code>common</code></p></td>
<td style="text-align: left;"><p><code>payload(optional)</code></p></td>
<td style="text-align: left;"><p>Upsert (Insert or Update) document in
collection or object in ObjectRepository. If parameter is not specified,
updates document from message body</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>FindRepositoryOperation</code></p></td>
<td style="text-align: left;"><p><code>repository</code></p></td>
<td
style="text-align: left;"><p><code>ObjectFilter(optional), FindOptions(optional)</code></p></td>
<td style="text-align: left;"><p>Find objects in ObjectRepository by
ObjectFilter. If not specified, returns all objects in
repository</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>RemoveRepositoryOperation</code></p></td>
<td style="text-align: left;"><p><code>repository</code></p></td>
<td
style="text-align: left;"><p><code>ObjectFilter(required), RemoveOptions(optional)</code></p></td>
<td style="text-align: left;"><p>Remove objects in ObjectRepository
matched by ObjectFilter</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><code>UpdateRepositoryOperation</code></p></td>
<td style="text-align: left;"><p><code>repository</code></p></td>
<td
style="text-align: left;"><p><code>ObjectFilter(required), UpdateOptions(optional), payload(optional)</code></p></td>
<td style="text-align: left;"><p>Update objects matching ObjectFilter.
If payload not specified, the message body is used</p></td>
</tr>
</tbody>
</table>

# Examples

## Consume changes in a collection.

    from("nitrite:/path/to/database.db?collection=myCollection")
        .to("log:change");

## Consume changes in object repository.

    from("nitrite:/path/to/database.db?repositoryClass=my.project.MyPersistentObject")
        .to("log:change");
    
    package my.project;
    
    @Indices({
            @Index(value = "key1", type = IndexType.NonUnique)
    })
    public class MyPersistentObject {
        @Id
        private long id;
        private String key1;
        // Getters, setters
    }

## Insert or update document

    from("direct:upsert")
        .setBody(constant(Document.createDocument("key1", "val1")))
        .to("nitrite:/path/to/database.db?collection=myCollection");

## Get Document by id

    from("direct:getByID")
        .setHeader(NitriteConstants.OPERATION, () -> new GetByIdOperation(NitriteId.createId(123L)))
        .to("nitrite:/path/to/database.db?collection=myCollection")
        .to("log:result")

## Find Document in collection

    from("direct:getByID")
        .setHeader(NitriteConstants.OPERATION, () -> new FindCollectionOperation(Filters.eq("myKey", "withValue")))
        .to("nitrite:/path/to/database.db?collection=myCollection")
        .to("log:result");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|database|Path to database file. Will be created if not exists.||string|
|collection|Name of Nitrite collection. Cannot be used in combination with repositoryClass option.||string|
|repositoryClass|Class of Nitrite ObjectRepository. Cannot be used in combination with collection option.||string|
|repositoryName|Optional name of ObjectRepository. Can be only used in combination with repositoryClass, otherwise have no effect||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|password|Password for Nitrite database. Required, if option username specified.||string|
|username|Username for Nitrite database. Database is not secured if option not specified.||string|
