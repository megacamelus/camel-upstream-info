# Chatscript

**Since Camel 3.0**

**Only producer is supported**

The ChatScript component allows you to interact with [ChatScript
Server](https://github.com/ChatScript/ChatScript) and have
conversations. This component is stateless and relies on ChatScript to
maintain chat history.

This component expects a JSON with the following fields:

    {
      "username": "name here",
      "botname": "name here",
      "body": "body here"
    }

Refer to the file
[`ChatScriptMessage.java`](https://github.com/apache/camel/blob/main/components/camel-chatscript/src/main/java/org/apache/camel/component/chatscript/ChatScriptMessage.java)
for details and samples.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname or IP of the server on which CS server is running||string|
|port|Port on which ChatScript is listening to|1024|integer|
|botName|Name of the Bot in CS to converse with||string|
|chatUserName|Username who initializes the CS conversation. To be set when chat is initialized from camel route||string|
|resetChat|Issues :reset command to start a new conversation everytime|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
