# Stitch

**Since Camel 3.8**

**Only producer is supported**

Stitch is a cloud ETL service, a developer-focused platform for rapidly
moving and replicates data from more than 90 applications and databases.
It integrates various data sources into a central data warehouse. Stitch
has integrations for many enterprise software data sources, and can
receive data via WebHooks and an API (Stitch Import API) which Camel
Stitch Component uses to produce the data to Stitch ETL.

For more info, feel free to visit their
[website](https://www.stitchdata.com/)

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-stitch</artifactId>
        <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    stitch:[tableName]//[?options]

# Usage

## Prerequisites

You must have a valid Stitch account, you will need to enable Stitch
Import API and generate a token for the integration, for more info,
please find more info
[here](https://www.stitchdata.com/docs/developers/import-api/guides/quick-start).

## Async Producer

This component implements the async Consumer and producer.

This allows camel route to consume and produce events asynchronously
without blocking any threads.

**Example showing how to produce data to Stitch from a custom
processor:**

    from("direct:sendStitch")
         .process(exchange -> {
             final StitchMessage stitchMessage = StitchMessage.builder()
                   .withData("field_1", "stitchMessage2-1")
                   .build();
    
             final StitchRequestBody stitchRequestBody = StitchRequestBody.builder()
                    .addMessage(stitchMessage)
                    .withSchema(StitchSchema.builder().addKeyword("field_1", "string").build())
                    .withTableName("table_1")
                    .withKeyNames(Collections.singleton("field_1"))
                    .build();
    
                    exchange.getMessage().setBody(stitchRequestBody);
         })
    .to("stitch:table_1?token=RAW({{token}})");

## Message body type

Currently, the component supports the following types for the body
message on the producer side when producing a message to Stitch
component:

-   `org.apache.camel.component.stitch.client.models.StitchRequestBody`:
    This represents this Stitch [JSON
    Message](https://www.stitchdata.com/docs/developers/import-api/api#batch-data—arguments).
    However, `StitchRequestBody` includes a type safe builder that helps
    on building the request body. Please note that, `tableName`,
    `keyNames` and `schema` options are no longer required if you send
    the data with `StitchRequestBody`, if you still set these options,
    they override whatever being set in message body
    `StitchRequestBody`.

-   `org.apache.camel.component.stitch.client.models.StitchMessage`:
    This represents [this Stitch message
    structure](https://www.stitchdata.com/docs/developers/import-api/api#message-object).
    If you choose to send your message as `StitchMessage`, **you will
    need** to add `tableName`, `keyNames` and `schema` options to either
    the Exchange headers or through the endpoint options.

-   `Map`: You can also send the data as `Map`, the data structure must
    follow this [JSON
    Message](https://www.stitchdata.com/docs/developers/import-api/api#batch-data—arguments)
    structure which is similar to `StitchRequestBody` but with drawback
    losing on all the type safety builder that is included with
    `StitchRequestBody`.

-   `Iterable`: You can send multiple Stitch messages that are
    aggregated by Camel or aggregated through custom processor. These
    aggregated messages can be type of `StitchMessage`,
    `StitchRequestBody` or `Map` but this Map here is similar to
    `StitchMessage`.

## Examples

Here is list of examples showing data that can be proceeded to Stitch:

### Input body type `org.apache.camel.component.stitch.client.models.StitchRequestBody`:

    from("direct:sendStitch")
         .process(exchange -> {
             final StitchMessage stitchMessage = StitchMessage.builder()
                   .withData("field_1", "stitchMessage2-1")
                   .build();
    
             final StitchRequestBody stitchRequestBody = StitchRequestBody.builder()
                    .addMessage(stitchMessage)
                    .withSchema(StitchSchema.builder().addKeyword("field_1", "string").build())
                    .withTableName("table_1")
                    .withKeyNames(Collections.singleton("field_1"))
                    .build();
    
                    exchange.getMessage().setBody(stitchRequestBody);
         })
    .to("stitch:table_1?token=RAW({{token}})");

### Input body type `org.apache.camel.component.stitch.client.models.StitchMessage`:

    from("direct:sendStitch")
         .process(exchange -> {
             exchange.getMessage().setHeader(StitchConstants.SCHEMA, StitchSchema.builder().addKeyword("field_1", "string").build());
             exchange.getMessage().setHeader(StitchConstants.KEY_NAMES, "field_1");
             exchange.getMessage().setHeader(StitchConstants.TABLE_NAME, "table_1");
    
             final StitchMessage stitchMessage = StitchMessage.builder()
                   .withData("field_1", "stitchMessage2-1")
                   .build();
    
                    exchange.getMessage().setBody(stitchMessage);
         })
    .to("stitch:table_1?token=RAW({{token}})");

### Input body type `Map`:

    from("direct:sendStitch")
         .process(exchange -> {
            final Map<String, Object> properties = new LinkedHashMap<>();
            properties.put("id", Collections.singletonMap("type", "integer"));
            properties.put("name", Collections.singletonMap("type", "string"));
            properties.put("age", Collections.singletonMap("type", "integer"));
            properties.put("has_magic", Collections.singletonMap("type", "boolean"));
    
            final Map<String, Object> data = new LinkedHashMap<>();
            data.put(StitchRequestBody.TABLE_NAME, "my_table");
            data.put(StitchRequestBody.SCHEMA, Collections.singletonMap("properties", properties));
            data.put(StitchRequestBody.MESSAGES,
                    Collections.singletonList(Collections.singletonMap("data", Collections.singletonMap("id", 2))));
            data.put(StitchRequestBody.KEY_NAMES, "test_key");
    
            exchange.getMessage().setBody(data);
         })
    .to("stitch:table_1?token=RAW({{token}})");

### Input body type `Iterable`:

    from("direct:sendStitch")
         .process(exchange -> {
             exchange.getMessage().setHeader(StitchConstants.SCHEMA, StitchSchema.builder().addKeyword("field_1", "string").build());
             exchange.getMessage().setHeader(StitchConstants.KEY_NAMES, "field_1");
             exchange.getMessage().setHeader(StitchConstants.TABLE_NAME, "table_1");
    
            final StitchMessage stitchMessage1 = StitchMessage.builder()
                    .withData("field_1", "stitchMessage1")
                    .build();
    
            final StitchMessage stitchMessage2 = StitchMessage.builder()
                    .withData("field_1", "stitchMessage2-1")
                    .build();
    
            final StitchRequestBody stitchMessage2RequestBody = StitchRequestBody.builder()
                    .addMessage(stitchMessage2)
                    .withSchema(StitchSchema.builder().addKeyword("field_1", "integer").build())
                    .withTableName("table_1")
                    .withKeyNames(Collections.singleton("field_1"))
                    .build();
    
            final Map<String, Object> stitchMessage3 = new LinkedHashMap<>();
            stitchMessage3.put(StitchMessage.DATA, Collections.singletonMap("field_1", "stitchMessage3"));
    
            final StitchMessage stitchMessage4 = StitchMessage.builder()
                    .withData("field_1", "stitchMessage4")
                    .build();
    
            final Exchange stitchMessage4Exchange = new DefaultExchange(context);
            stitchMessage4Exchange.getMessage().setBody(stitchMessage4);
    
            final StitchMessage stitchMessage5 = StitchMessage.builder()
                    .withData("field_1", "stitchMessage5")
                    .build();
    
            final Message stitchMessage5Message = new DefaultExchange(context).getMessage();
            stitchMessage5Message.setBody(stitchMessage5);
    
            final List<Object> inputMessages = new LinkedList<>();
            inputMessages.add(stitchMessage1);
            inputMessages.add(stitchMessage2RequestBody);
            inputMessages.add(stitchMessage3);
            inputMessages.add(stitchMessage4Exchange);
            inputMessages.add(stitchMessage5Message);
    
            exchange.getMessage().setBody(inputMessages);
         })
    .to("stitch:table_1?token=RAW({{token}})");

# Development Notes (Important)

When developing on this component, you will need to obtain a Stitch
token to run the integration tests. In addition to the mocked unit
tests, you **will need to run the integration tests with every change
you make** To run the integration tests, in this component directory,
run the following maven command:

    mvn verify -Dtoken=stitchToken

Whereby `token` is your Stitch token generated for Stitch Import API
integration.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The component configurations||object|
|keyNames|A collection of comma separated strings representing the Primary Key fields in the source table. Stitch use these Primary Keys to de-dupe data during loading If not provided, the table will be loaded in an append-only manner.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|region|Stitch account region, e.g: europe|EUROPE|object|
|stitchSchema|A schema that describes the record(s)||object|
|connectionProvider|ConnectionProvider contain configuration for the HttpClient like Maximum connection limit .. etc, you can inject this ConnectionProvider and the StitchClient will initialize HttpClient with this ConnectionProvider||object|
|httpClient|Reactor Netty HttpClient, you can injected it if you want to have custom HttpClient||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|stitchClient|Set a custom StitchClient that implements org.apache.camel.component.stitch.client.StitchClient interface||object|
|token|Stitch access token for the Stitch Import API||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|tableName|The name of the destination table the data is being pushed to. Table names must be unique in each destination schema, or loading issues will occur. Note: The number of characters in the table name should be within the destination's allowed limits or data will rejected.||string|
|keyNames|A collection of comma separated strings representing the Primary Key fields in the source table. Stitch use these Primary Keys to de-dupe data during loading If not provided, the table will be loaded in an append-only manner.||string|
|region|Stitch account region, e.g: europe|EUROPE|object|
|stitchSchema|A schema that describes the record(s)||object|
|connectionProvider|ConnectionProvider contain configuration for the HttpClient like Maximum connection limit .. etc, you can inject this ConnectionProvider and the StitchClient will initialize HttpClient with this ConnectionProvider||object|
|httpClient|Reactor Netty HttpClient, you can injected it if you want to have custom HttpClient||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|stitchClient|Set a custom StitchClient that implements org.apache.camel.component.stitch.client.StitchClient interface||object|
|token|Stitch access token for the Stitch Import API||string|
