# Langchain4j-chat

**Since Camel 4.5**

**Only producer is supported**

The LangChain4j Chat Component allows you to integrate with any LLM
supported by [LangChain4j](https://github.com/langchain4j/langchain4j).

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

# Using a specific Chat Model

The Camel LangChain4j chat component provides an abstraction for
interacting with various types of Large Language Models (LLMs) supported
by [LangChain4j](https://github.com/langchain4j/langchain4j).

To integrate with a specific Large Language Model, users should follow
these steps:

## Example of Integrating with OpenAI

Add the dependency for LangChain4j OpenAI support:

    <dependency>
          <groupId>dev.langchain4j</groupId>
          <artifactId>langchain4j-open-ai</artifactId>
        <version>x.x.x</version>
    </dependency>

Init the OpenAI Chat Language Model, and add it to the Camel Registry:

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

# Send a prompt with variables

To send a prompt with variables, use the Operation type
`LangChain4jChatOperations.CHAT_SINGLE_MESSAGE_WITH_PROMPT`. This
operation allows you to send a single prompt message with dynamic
variables, which will be replaced with values provided in the request.

Example of route :

     from("direct:chat")
          .to("langchain4j-chat:test?chatModel=#chatModel&chatOperation=CHAT_SINGLE_MESSAGE_WITH_PROMPT")

Example of usage:

    var promptTemplate = "Create a recipe for a {{dishType}} with the following ingredients: {{ingredients}}";
    
    Map<String, Object> variables = new HashMap<>();
    variables.put("dishType", "oven dish");
    variables.put("ingredients", "potato, tomato, feta, olive oil");
    
    String response = template.requestBodyAndHeader("direct:chat", variables,
                    LangChain4jChat.Headers.PROMPT_TEMPLATE, promptTemplate, String.class);

# Chat with history

You can send a new prompt along with the chat message history by passing
all messages in a list of type
`dev.langchain4j.data.message.ChatMessage`. Use the Operation type
`LangChain4jChatOperations.CHAT_MULTIPLE_MESSAGES`. This operation
allows you to continue the conversation with the context of previous
messages.

Example of route :

     from("direct:chat")
          .to("langchain4j-chat:test?chatModel=#chatModel&chatOperation=CHAT_MULTIPLE_MESSAGES")

Example of usage:

    List<ChatMessage> messages = new ArrayList<>();
    messages.add(new SystemMessage("You are asked to provide recommendations for a restaurant based on user reviews."));
    // Add more chat messages as needed
    
    String response = template.requestBody("direct:send-multiple", messages, String.class);

# Chat with Tool

Camel langchain4j-chat component as a consumer can be used to implement
a LangChain tool. Right now tools are supported only via the
OpenAiChatModel backed by OpenAI APIs.

Tool Input parameter can be defined as an Endpoint multiValue option in
the form of `parameter.<name>=<type>`, or via the endpoint option
camelToolParameter for a programmatic approach. The parameters can be
found as headers in the consumer route, in particular, if you define
`parameter.userId=5`, in the consumer route `${header.userId}` can be
used.

Example of a producer and a consumer:

    from("direct:test")
        .to("langchain4j-chat:test1?chatOperation=CHAT_MULTIPLE_MESSAGES");
    
    from("langchain4j-chat:test1?description=Query user database by number&parameter.number=integer")
        .to("sql:SELECT name FROM users WHERE id = :#number");

Example of usage:

    List<ChatMessage> messages = new ArrayList<>();
            messages.add(new SystemMessage("""
                    You provide information about specific user name querying the database given a number.
                    """));
            messages.add(new UserMessage("""
                    What is the name of the user 1?
                    """));
    
            Exchange message = fluentTemplate.to("direct:test").withBody(messages).request(Exchange.class);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|chatOperation|Operation in case of Endpoint of type CHAT. The value is one of the values of org.apache.camel.component.langchain4j.chat.LangChain4jChatOperations|CHAT\_SINGLE\_MESSAGE|object|
|configuration|The configuration.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|chatModel|Chat Language Model of type dev.langchain4j.model.chat.ChatLanguageModel||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|chatId|The id||string|
|chatOperation|Operation in case of Endpoint of type CHAT. The value is one of the values of org.apache.camel.component.langchain4j.chat.LangChain4jChatOperations|CHAT\_SINGLE\_MESSAGE|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|chatModel|Chat Language Model of type dev.langchain4j.model.chat.ChatLanguageModel||object|
