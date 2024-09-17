# Milvus

**Since Camel 4.5**

**Only producer is supported**

The Milvus Component provides support for interacting with the [Milvus
Vector Database](https://https://milvus.io/).

# URI format

    milvus:collection[?options]

Where **collection** represents a named set of points (vectors with a
payload) defined in your database.

# Examples

## Collection Examples

In the route below, we use the milvus component to create a collection
named *test* with the given parameters:

Java  
FieldType fieldType1 = FieldType.newBuilder()
.withName("userID")
.withDescription("user identification")
.withDataType(DataType.Int64)
.withPrimaryKey(true)
.withAutoID(true)
.build();

    FieldType fieldType2 = FieldType.newBuilder()
                    .withName("userFace")
                    .withDescription("face embedding")
                    .withDataType(DataType.FloatVector)
                    .withDimension(64)
                    .build();
    
    FieldType fieldType3 = FieldType.newBuilder()
                    .withName("userAge")
                    .withDescription("user age")
                    .withDataType(DataType.Int8)
                    .build();
    
    from("direct:in")
        .setHeader(Milvus.Headers.ACTION)
            .constant(MilvusAction.CREATE_COLLECTION)
        .setBody()
            .constant(
                    CreateCollectionParam.newBuilder()
                        .withCollectionName("test")
                        .withDescription("customer info")
                        .withShardsNum(2)
                        .withEnableDynamicField(false)
                        .addFieldType(fieldType1)
                        .addFieldType(fieldType2)
                        .addFieldType(fieldType3)
                        .build())
        .to("milvus:test");

## Points Examples

### Upsert

In the route below we use the milvus component to perform insert on
points in the collection named *test*:

Java  
private List\<List<Float>\> generateFloatVectors(int count) {
Random ran = new Random();
List\<List<Float>\> vectors = new ArrayList\<\>();
for (int n = 0; n \< count; ++n) {
List<Float> vector = new ArrayList\<\>();
for (int i = 0; i \< 64; ++i) {
vector.add(ran.nextFloat());
}
vectors.add(vector);
}

            return vectors;
    }
    
    
    Random ran = new Random();
    List<Integer> ages = new ArrayList<>();
    for (long i = 0L; i < 2; ++i) {
        ages.add(ran.nextInt(99));
    }
    List<InsertParam.Field> fields = new ArrayList<>();
    fields.add(new InsertParam.Field("userAge", ages));
    fields.add(new InsertParam.Field("userFace", generateFloatVectors(2)));
    
    from("direct:in")
        .setHeader(Milvus.Headers.ACTION)
            .constant(MilvusAction.INSERT)
        .setBody()
            .constant(
                InsertParam.newBuilder()
                    .withCollectionName("test")
                    .withFields(fields)
                    .build())
        .to("milvus:test");

## Search

In the route below, we use the milvus component to retrieve information
by query from the collection named *test*:

Java  
private List<Float> generateFloatVector() {
Random ran = new Random();
List<Float> vector = new ArrayList\<\>();
for (int i = 0; i \< 64; ++i) {
vector.add(ran.nextFloat());
}
return vector;
}

    from("direct:in")
        .setHeader(Milvus.Headers.ACTION)
            .constant(MilvusAction.SEARCH)
        .setBody()
            .constant(SearchSimpleParam.newBuilder()
                    .withCollectionName("test")
                    .withVectors(generateFloatVector())
                    .withFilter("userAge>0")
                    .withLimit(100L)
                    .withOffset(0L)
                    .withOutputFields(Lists.newArrayList("userAge"))
                    .withConsistencyLevel(ConsistencyLevelEnum.STRONG)
                    .build())
        .to("milvus:myCollection");

## Relation with Langchain4j-Embeddings component

The Milvus component provides a datatype transformer, from
langchain4j-embeddings to an insert/upsert object compatible with
Milvus.

As an example, you could think about these routes:

Java

<!-- -->

        protected RoutesBuilder createRouteBuilder() {
            return new RouteBuilder() {
                public void configure() {
                    from("direct:in")
                            .to("langchain4j-embeddings:test")
                            .setHeader(Milvus.Headers.ACTION).constant(MilvusAction.INSERT)
                            .setHeader(Milvus.Headers.KEY_NAME).constant("userID")
                            .setHeader(Milvus.Headers.KEY_VALUE).constant(Long.valueOf("3"))
                            .transform(new org.apache.camel.spi.DataType("milvus:embeddings"))
                            .to(MILVUS_URI);
    
                    from("direct:up")
                            .to("langchain4j-embeddings:test")
                            .setHeader(Milvus.Headers.ACTION).constant(MilvusAction.UPSERT)
                            .setHeader(Milvus.Headers.KEY_NAME).constant("userID")
                            .setHeader(Milvus.Headers.KEY_VALUE).constant(Long.valueOf("3"))
                            .transform(new org.apache.camel.spi.DataType("milvus:embeddings"))
                            .to(MILVUS_URI);
                }
            };
        }

It’s important to note that Milvus SDK doesn’t support upsert for autoID
fields. This means if you set a field as key, and you set the autoID to
true, the upsert won’t be possible.

That’s the reason why, in the example, we are setting the userID as
keyName with a keyValue of 3. This is particularly important when you
design your Milvus database.

The transformer only supports insert/upsert objects, so the only
operation you can set via header are INSERT and UPSERT, otherwise the
transformer will fail with an error log.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The configuration;||object|
|host|The host to connect to.|localhost|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|port|The port to connect to.|19530|integer|
|timeout|Sets a default timeout for all requests||integer|
|token|Sets the API key to use for authentication||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|collection|The collection Name||string|
|host|The host to connect to.|localhost|string|
|port|The port to connect to.|19530|integer|
|timeout|Sets a default timeout for all requests||integer|
|token|Sets the API key to use for authentication||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
