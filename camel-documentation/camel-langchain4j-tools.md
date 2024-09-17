# Langchain4j-tools

**Since Camel 4.8**

**Both producer and consumer are supported**

The LangChain4j Tools Component allows you to use function calling
features from Large Language Models (LLMs) supported by
[LangChain4j](https://github.com/langchain4j/langchain4j).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-langchain4j-tools</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

**Producer**

    langchain4j-tools:toolSet[?options]

**Consumer**

    langchain4j-tools:toolSet[?options]

Where **toolSet** can be any string to uniquely identify the endpoint

# Usage

This component helps to use function-calling features from LLMs so that
models can decide what functions (routes, in case of Camel) can be
called (i.e.; routed).

Consider, for instance, two consumer routes capable of query an user
database by user ID or by social security number (SSN).

**Queries user by ID**

    from("langchain4j-tool:userInfo?tags=users&description=Query database by user ID")
        .to("sql:SELECT name FROM users WHERE id = :#number");

**Queries user by SSN**

    from("langchain4j-tool:userInfo?tags=users&description=Query database by user social security ID")
        .to("sql:SELECT name FROM users WHERE ssn = :#ssn");

Now, consider a producer route that receives unstructured data as input.
Such a route could consume this data, pass it to a LLM with
function-calling capabilities (such as
[llama3.1](https://huggingface.co/meta-llama/Meta-Llama-3.1-8B),
[Granite Code 20b function calling,
etc](https://huggingface.co/ibm-granite/granite-20b-functioncalling))
and have the model decide which route to call.

Such a route could receive questions in english such as:

-   *"What is the name of the user with user ID 1?"*

-   *"What is the name of the user with SSN 34.400.96?"*

**Produce**

    from(source)
        .to("langchain4j-tool:userInfo?tags=users");

## Tool Tags

Consumer routes must define tags that groups
[together](https://en.wikipedia.org/wiki/Set_theory). The aforementioned
routes would be part have the `users` tag. The `users` tag has two
routes: `queryById` and `queryBySSN`

## Parameters

The Tool Input parameter can be defined as an Endpoint multiValue option
in the form of `parameter.<name>=<type>`, or via the endpoint option
`camelToolParameter` for a programmatic approach. The parameters can be
found as headers in the consumer route, in particular, if you define
`parameter.userId=5`, in the consumer route `${header.userId}` can be
used.

**Producer and consumer example:**

    from("direct:test")
        .to("langchain4j-tools:test1?tags=users");
    
    from("langchain4j-chat:test1?tags=users&description=Query user database by user ID&parameter.userId=integer")
        .to("sql:SELECT name FROM users WHERE id = :#userId");

**Usage example:**

    List<ChatMessage> messages = new ArrayList<>();
            messages.add(new SystemMessage("""
                    You provide information about specific user name querying the database given a number.
                    """));
            messages.add(new UserMessage("""
                    What is the name of the user 1?
                    """));
    
            Exchange message = fluentTemplate.to("direct:test").withBody(messages).request(Exchange.class);

## Using a specific Model

The Camel LangChain4j tools component provides an abstraction for
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
                    .apiKey("NO_API_KEY")
                    .modelName("llama3.1:latest")
                    .temperature(0.0)
                    .timeout(ofSeconds(60000))
                    .build();
    context.getRegistry().bind("chatModel", model);

Use the model in the Camel LangChain4j Chat Producer

     from("direct:chat")
          .to("langchain4j-tools:test?tags=users&chatModel=#chatModel");

To switch to another Large Language Model and its corresponding
dependency, replace the `langchain4j-open-ai` dependency with the
appropriate dependency for the desired model. Update the initialization
parameters accordingly in the code snippet provided above.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|configuration|The configuration.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|chatModel|Chat Language Model of type dev.langchain4j.model.chat.ChatLanguageModel||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|toolId|The tool name||string|
|tags|The tags for the tools||string|
|description|Tool description||string|
|parameters|List of Tool parameters in the form of parameter.=||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|camelToolParameter|Tool's Camel Parameters, programmatically define Tool description and parameters||object|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|chatModel|Chat Language Model of type dev.langchain4j.model.chat.ChatLanguageModel||object|
