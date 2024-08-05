# Cm-sms

**Since Camel 2.18**

**Only producer is supported**

**Camel-Cm-Sms** is an [Apache Camel](http://camel.apache.org/)
component for the [CM SMS Gateway](https://www.cmtelecom.com)

It allows integrating [CM SMS
API](https://dashboard.onlinesmsgateway.com/docs) in an application as a
camel component.

You must have a valid account. More information is available at [CM
Telecom](https://www.cmtelecom.com/support).

# Sample

    cm-sms://sgw01.cm.nl/gateway.ashx?defaultFrom=DefaultSender&defaultMaxNumberOfParts=8&productToken=xxxxx

You can try [this project](https://github.com/oalles/camel-cm-sample) to
see how camel-cm-sms can be integrated in a camel route.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|SMS Provider HOST with scheme||string|
|defaultFrom|This is the sender name. The maximum length is 11 characters.||string|
|defaultMaxNumberOfParts|If it is a multipart message forces the max number. Message can be truncated. Technically the gateway will first check if a message is larger than 160 characters, if so, the message will be cut into multiple 153 characters parts limited by these parameters.|8|integer|
|productToken|The unique token to use||string|
|testConnectionOnStartup|Whether to test the connection to the SMS Gateway on startup|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
