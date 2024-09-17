# Qdrant

**Since Camel 4.5**

**Only producer is supported**

The Qdrant Component provides support for interacting with the [Qdrant
Vector Database](https://qdrant.tech).

# URI format

    qdrant:collection[?options]

Where **collection** represents a named set of points (vectors with a
payload) defined in your database.

# Examples

## Collection Examples

In the route below, we use the qdrant component to create a collection
named *myCollection* with the given parameters:

### Create Collection

Java  
from("direct:in")
.setHeader(Qdrant.Headers.ACTION)
.constant(QdrantAction.CREATE\_COLLECTION)
.setBody()
.constant(
Collections.VectorParams.newBuilder()
.setSize(2)
.setDistance(Collections.Distance.Cosine).build())
.to("qdrant:myCollection");

### Delete Collection

In the route below, we use the qdrant component to delete a collection
named *myCollection*:

Java  
from("direct:in")
.setHeader(Qdrant.Headers.ACTION)
.constant(QdrantAction.DELETE\_COLLECTION)
.to("qdrant:myCollection");

### Collection Info

In the route below, we use the qdrant component to get information about
the collection named `myCollection`:

Java  
from("direct:in")
.setHeader(Qdrant.Headers.ACTION)
.constant(QdrantAction.COLLECTION\_INFO)
.to("qdrant:myCollection")
.process(this::process);

If there is a collection, you will receive a reply of type
`Collections.CollectionInfo`. If there is not, the exchange will contain
an exception of type `QdrantActionException` with a cause of type
`StatusRuntimeException statusRuntimeException` and status
`Status.NOT_FOUND`.

## Points Examples

### Upsert

In the route below we use the qdrant component to perform insert +
updates (upsert) on points in the collection named *myCollection*:

Java  
from("direct:in")
.setHeader(Qdrant.Headers.ACTION)
.constant(QdrantAction.UPSERT)
.setBody()
.constant(
Points.PointStruct.newBuilder()
.setId(id(8))
.setVectors(VectorsFactory.vectors(List.of(3.5f, 4.5f)))
.putAllPayload(Map.of(
"foo", value("hello"),
"bar", value(1)))
.build())
.to("qdrant:myCollection");

### Retrieve

In the route below, we use the qdrant component to retrieve information
of a single point by id from the collection named *myCollection*:

Java  
from("direct:in")
.setHeader(Qdrant.Headers.ACTION)
.constant(QdrantAction.RETRIEVE)
.setBody()
.constant(PointIdFactory.id(8))
.to("qdrant:myCollection");

### Delete

In the route below, we use the qdrant component to delete points from
the collection named `myCollection` according to a criteria:

Java  
from("direct:in")
.setHeader(Qdrant.Headers.ACTION)
.constant(QdrantAction.DELETE)
.setBody()
.constant(ConditionFactory.matchKeyword("foo", "hello"))
.to("qdrant:myCollection");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiKey|Sets the API key to use for authentication||string|
|configuration|The configuration;||object|
|host|The host to connect to.|localhost|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|port|The port to connect to.|6334|integer|
|timeout|Sets a default timeout for all requests||object|
|tls|Whether the client uses Transport Layer Security (TLS) to secure communications|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|collection|The collection Name||string|
|apiKey|Sets the API key to use for authentication||string|
|host|The host to connect to.|localhost|string|
|port|The port to connect to.|6334|integer|
|timeout|Sets a default timeout for all requests||object|
|tls|Whether the client uses Transport Layer Security (TLS) to secure communications|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
