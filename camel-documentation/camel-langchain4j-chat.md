# Langchain4j-chat

**Since Camel 4.5**

**Both producer and consumer are supported**

The LangChain4j Chat Component allows you to integrate with any Large
Language Model (LLM) supported by
[LangChain4j](https://github.com/langchain4j/langchain4j).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-langchain4j-chat</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    langchain4j-chat:chatIdId[?options]

Where **chatId** can be any string to uniquely identify the endpoint

# Usage

## Using a specific Chat Model

The Camel LangChain4j chat component provides an abstraction for
interacting with various types of Large Language Models (LLMs) supported
by [LangChain4j](https://github.com/langchain4j/langchain4j).

### Integrating with specific LLM

To integrate with a specific LLM, users should follow the steps
described below, which explain how to integrate with OpenAI.

Add the dependency for LangChain4j OpenAI support:

**Example**

    <dependency>
          <groupId>dev.langchain4j</groupId>
          <artifactId>langchain4j-open-ai</artifactId>
        <version>x.x.x</version>
    </dependency>

Initialize the OpenAI Chat Language Model, and add it to the Camel
Registry:

    ChatLanguageModel model = OpenAiChatModel.builder()
                    .apiKey(openApiKey)
                    .modelName(GPT_3_5_TURBO)
                    .temperature(0.3)
                    .timeout(ofSeconds(3000))
                    .build();
    context.getRegistry().bind("chatModel", model);

Use the model in the Camel LangChain4j Chat Producer

     from("direct:chat")
          .to("langchain4j-chat:test?chatModel=#chatModel")

To switch to another Large Language Model and its corresponding
dependency, replace the `langchain4j-open-ai` dependency with the
appropriate dependency for the desired model. Update the initialization
parameters accordingly in the code snippet provided above.

## Send a prompt with variables

To send a prompt with variables, use the Operation type
`LangChain4jChatOperations.CHAT_SINGLE_MESSAGE_WITH_PROMPT`. This
operation allows you to send a single prompt message with dynamic
variables, which will be replaced with values provided in the request.

**Route example:**

     from("direct:chat")
          .to("langchain4j-chat:test?chatModel=#chatModel&chatOperation=CHAT_SINGLE_MESSAGE_WITH_PROMPT")

**Usage example:**

    var promptTemplate = "Create a recipe for a {{dishType}} with the following ingredients: {{ingredients}}";
    
    Map<String, Object> variables = new HashMap<>();
    variables.put("dishType", "oven dish");
    variables.put("ingredients", "potato, tomato, feta, olive oil");
    
    String response = template.requestBodyAndHeader("direct:chat", variables,
                    LangChain4jChat.Headers.PROMPT_TEMPLATE, promptTemplate, String.class);

## Chat with history

You can send a new prompt along with the chat message history by passing
all messages in a list of type
`dev.langchain4j.data.message.ChatMessage`. Use the Operation type
`LangChain4jChatOperations.CHAT_MULTIPLE_MESSAGES`. This operation
allows you to continue the conversation with the context of previous
messages.

**Route example:**

     from("direct:chat")
          .to("langchain4j-chat:test?chatModel=#chatModel&chatOperation=CHAT_MULTIPLE_MESSAGES")

**Usage example:**

    List<ChatMessage> messages = new ArrayList<>();
    messages.add(new SystemMessage("You are asked to provide recommendations for a restaurant based on user reviews."));
    // Add more chat messages as needed
    
    String response = template.requestBody("direct:send-multiple", messages, String.class);

## Chat with Tool

as of Camel 4.8.0 this feature is deprecated. Users should use the
[LangChain4j Tool component](#langchain4j-tools-component.adoc).

Camel langchain4j-chat component as a consumer can be used to implement
a LangChain tool. Right now tools are supported only via the
OpenAiChatModel backed by OpenAI APIs.

Tool Input parameter can be defined as an Endpoint multiValue option in
the form of `parameter.<name>=<type>`, or via the endpoint option
`camelToolParameter` for a programmatic approach. The parameters can be
found as headers in the consumer route, in particular, if you define
`parameter.userId=5`, in the consumer route `${header.userId}` can be
used.

**Producer and consumer example:**

    from("direct:test")
        .to("langchain4j-chat:test1?chatOperation=CHAT_MULTIPLE_MESSAGES");
    
    from("langchain4j-chat:test1?description=Query user database by number&parameter.number=integer")
        .to("sql:SELECT name FROM users WHERE id = :#number");

**Usage example:**

    List<ChatMessage> messages = new ArrayList<>();
            messages.add(new SystemMessage("""
                    You provide information about specific user name querying the database given a number.
                    """));
            messages.add(new UserMessage("""
                    What is the name of the user 1?
                    """));
    
            Exchange message = fluentTemplate.to("direct:test").withBody(messages).request(Exchange.class);

## Retrieval Augmented Generation (RAG)

Use the RAG feature to enrich exchanges with data retrieved from any
type of Camel endpoint. The feature is compatible with all LangChain4
Chat operations and is ideal for orchestrating the RAG workflow,
utilizing the extensive library of components and Enterprise Integration
Patterns (EIPs) available in Apache Camel.

There are two ways for utilizing the RAG feature:

### Using RAG with Content Enricher and LangChain4jRagAggregatorStrategy

Enrich the exchange by retrieving a list of strings using any Camel
producer. The `LangChain4jRagAggregatorStrategy` is specifically
designed to augment data within LangChain4j chat producers.

**Usage example:**

    // Create an instance of the RAG aggregator strategy
    LangChain4jRagAggregatorStrategy aggregatorStrategy = new LangChain4jRagAggregatorStrategy();
    
    from("direct:test")
         .enrich("direct:rag", aggregatorStrategy)
         .to("langchain4j-chat:test1?chatOperation=CHAT_SIMPLE_MESSAGE");
    
      from("direct:rag")
              .process(exchange -> {
                    List<String> augmentedData = List.of("data 1", "data 2" );
                    exchange.getIn().setBody(augmentedData);
                  });

This method leverages a separate Camel route to fetch and process the
augmented data.

It is possible to enrich the message from multiple sources within the
same exchange.

**Usage example:**

    // Create an instance of the RAG aggregator strategy
    LangChain4jRagAggregatorStrategy aggregatorStrategy = new LangChain4jRagAggregatorStrategy();
    
    from("direct:test")
         .enrich("direct:rag-from-source-1", aggregatorStrategy)
         .enrich("direct:rag-from-source-2", aggregatorStrategy)
         .to("langchain4j-chat:test1?chatOperation=CHAT_SIMPLE_MESSAGE");

### Using RAG with headers

Directly add augmented data into the header. This method is particularly
efficient for straightforward use cases where the augmented data is
predefined or static. You must add augmented data as a List of
`dev.langchain4j.rag.content.Content` directly inside the header
`CamelLangChain4jChatAugmentedData`.

**Usage example:**

    import dev.langchain4j.rag.content.Content;
    
    ...
    
    Content augmentedContent = new Content("data test");
    List<Content> contents = List.of(augmentedContent);
    
    String response = template.requestBodyAndHeader("direct:send-multiple", messages, LangChain4jChat.Headers.AUGMENTED_DATA , contents, String.class);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|chatOperation|Operation in case of Endpoint of type CHAT. The value is one of the values of org.apache.camel.component.langchain4j.chat.LangChain4jChatOperations|CHAT\_SINGLE\_MESSAGE|object|
|configuration|The configuration.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|chatModel|Chat Language Model of type dev.langchain4j.model.chat.ChatLanguageModel||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|chatId|The id||string|
|chatOperation|Operation in case of Endpoint of type CHAT. The value is one of the values of org.apache.camel.component.langchain4j.chat.LangChain4jChatOperations|CHAT\_SINGLE\_MESSAGE|object|
|description|Tool description||string|
|parameters|List of Tool parameters in the form of parameter.=||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|camelToolParameter|Tool's Camel Parameters, programmatically define Tool description and parameters||object|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|chatModel|Chat Language Model of type dev.langchain4j.model.chat.ChatLanguageModel||object|
