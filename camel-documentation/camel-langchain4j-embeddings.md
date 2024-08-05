# Langchain4j-embeddings

**Since Camel 4.5**

**Only producer is supported**

The LangChain4j embeddings component provides support for compute
embeddings using [LangChain4j](https://docs.langchain4j.dev/)
embeddings.

# URI format

    langchain4j-embeddings:embeddingId[?options]

Where **embeddingId** can be any string to uniquely identify the
endpoint

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The configuration.||object|
|embeddingModel|The EmbeddingModel engine to use.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|embeddingId|The id||string|
|embeddingModel|The EmbeddingModel engine to use.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
