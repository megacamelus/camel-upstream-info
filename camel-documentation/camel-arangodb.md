# Arangodb

**Since Camel 3.5**

**Only producer is supported**

The ArangoDb component is client for ArangoDb that uses the [arango java
driver](https://github.com/arangodb/arangodb-java-driver) to perform
queries on collections and graphs in the ArangoDb database.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-arangodb</artifactId>
        <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    arangodb:database[?options]

# Examples

## Producer Examples

### Save document on a collection

    from("direct:insert")
      .to("arangodb:testDb?documentCollection=collection&operation=SAVE_DOCUMENT");

And you can set as body a BaseDocument class

    BaseDocument myObject = new BaseDocument();
    myObject.addAttribute("a", "Foo");
    myObject.addAttribute("b", 42);

### Query a collection

    from("direct:query")
      .to("arangodb:testDb?operation=AQL_QUERY

And you can invoke an AQL Query in this way

    String query = "FOR t IN " + COLLECTION_NAME + " FILTER t.value == @value";
    Map<String, Object> bindVars = new MapBuilder().put("value", "hello")
            .get();
    
    Exchange result = template.request("direct:query", exchange -> {
        exchange.getMessage().setHeader(AQL_QUERY, query);
        exchange.getMessage().setHeader(AQL_QUERY_BIND_PARAMETERS, bindVars);
    });

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|Component configuration||object|
|documentCollection|Collection name, when using ArangoDb as a Document Database. Set the documentCollection name when using the CRUD operation on the document database collections (SAVE\_DOCUMENT , FIND\_DOCUMENT\_BY\_KEY, UPDATE\_DOCUMENT, DELETE\_DOCUMENT).||string|
|edgeCollection|Collection name of vertices, when using ArangoDb as a Graph Database. Set the edgeCollection name to perform CRUD operation on edges using these operations : SAVE\_VERTEX, FIND\_VERTEX\_BY\_KEY, UPDATE\_VERTEX, DELETE\_VERTEX. The graph attribute is mandatory.||string|
|graph|Graph name, when using ArangoDb as a Graph Database. Combine this attribute with one of the two attributes vertexCollection and edgeCollection.||string|
|host|ArangoDB host. If host and port are default, this field is Optional.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|operation|Operations to perform on ArangoDb. For the operation AQL\_QUERY, no need to specify a collection or graph.||object|
|port|ArangoDB exposed port. If host and port are default, this field is Optional.||integer|
|vertexCollection|Collection name of vertices, when using ArangoDb as a Graph Database. Set the vertexCollection name to perform CRUD operation on vertices using these operations : SAVE\_EDGE, FIND\_EDGE\_BY\_KEY, UPDATE\_EDGE, DELETE\_EDGE. The graph attribute is mandatory.||string|
|arangoDB|To use an existing ArangDB client.||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|vertx|To use an existing Vertx in the ArangoDB client.||object|
|password|ArangoDB password. If user and password are default, this field is Optional.||string|
|user|ArangoDB user. If user and password are default, this field is Optional.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|database|database name||string|
|documentCollection|Collection name, when using ArangoDb as a Document Database. Set the documentCollection name when using the CRUD operation on the document database collections (SAVE\_DOCUMENT , FIND\_DOCUMENT\_BY\_KEY, UPDATE\_DOCUMENT, DELETE\_DOCUMENT).||string|
|edgeCollection|Collection name of vertices, when using ArangoDb as a Graph Database. Set the edgeCollection name to perform CRUD operation on edges using these operations : SAVE\_VERTEX, FIND\_VERTEX\_BY\_KEY, UPDATE\_VERTEX, DELETE\_VERTEX. The graph attribute is mandatory.||string|
|graph|Graph name, when using ArangoDb as a Graph Database. Combine this attribute with one of the two attributes vertexCollection and edgeCollection.||string|
|host|ArangoDB host. If host and port are default, this field is Optional.||string|
|operation|Operations to perform on ArangoDb. For the operation AQL\_QUERY, no need to specify a collection or graph.||object|
|port|ArangoDB exposed port. If host and port are default, this field is Optional.||integer|
|vertexCollection|Collection name of vertices, when using ArangoDb as a Graph Database. Set the vertexCollection name to perform CRUD operation on vertices using these operations : SAVE\_EDGE, FIND\_EDGE\_BY\_KEY, UPDATE\_EDGE, DELETE\_EDGE. The graph attribute is mandatory.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|arangoDB|To use an existing ArangDB client.||object|
|vertx|To use an existing Vertx instance in the ArangoDB client.||object|
|password|ArangoDB password. If user and password are default, this field is Optional.||string|
|user|ArangoDB user. If user and password are default, this field is Optional.||string|
