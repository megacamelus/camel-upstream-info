# Avro

**Since Camel 2.10**

**Both producer and consumer are supported**

This component provides support for Apache Avro’s rpc, by providing
producers and consumers endpoint for using avro over netty or http.
Before Camel 3.2 this functionality was a part of camel-avro component.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-avro-rpc</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Apache Avro Overview

Avro allows you to define message types and a protocol using a json like
format and then generate java code for the specified types and messages.
An example of how a schema looks like is below.

    {"namespace": "org.apache.camel.avro.generated",
     "protocol": "KeyValueProtocol",
    
     "types": [
         {"name": "Key", "type": "record",
          "fields": [
              {"name": "key",   "type": "string"}
          ]
         },
         {"name": "Value", "type": "record",
          "fields": [
              {"name": "value",   "type": "string"}
          ]
         }
     ],
    
     "messages": {
         "put": {
             "request": [{"name": "key", "type": "Key"}, {"name": "value", "type": "Value"} ],
             "response": "null"
         },
         "get": {
             "request": [{"name": "key", "type": "Key"}],
             "response": "Value"
         }
     }
    }

You can easily generate classes from a schema, using maven, ant etc.
More details can be found at the [Apache Avro
documentation](http://avro.apache.org/docs/current/).

However, it doesn’t enforce a schema-first approach, and you can create
schema for your existing classes. You can use existing protocol
interfaces to make RCP calls. You should use interface for the protocol
itself and POJO beans or primitive/String classes for parameter and
result types. Here is an example of the class that corresponds to the
schema above:

    package org.apache.camel.avro.reflection;
    
    public interface KeyValueProtocol {
        void put(String key, Value value);
        Value get(String key);
    }
    
    class Value {
        private String value;
        public String getValue() { return value; }
        public void setValue(String value) { this.value = value; }
    }

*Note: Existing classes can be used only for RPC (see below), not in
data format.*

# Usage

## Using Avro RPC in Camel

As mentioned above, Avro also provides RPC support over multiple
transports such as http and netty. Camel provides consumers and
producers for these two transports.

    avro:[transport]:[host]:[port][?options]

The supported transport values are currently http or netty.

You can specify the message name right in the URI:

    avro:[transport]:[host]:[port][/messageName][?options]

For consumers, this allows you to have multiple routes attached to the
same socket. Dispatching to the correct route will be done by the avro
component automatically. Route with no messageName specified (if any)
will be used as default.

When using camel producers for avro ipc, the "in" message body needs to
contain the parameters of the operation specified in the avro protocol.
The response will be added in the body of the "out" message.

In a similar manner when using camel avro consumers for avro ipc, the
request parameters will be placed inside the "in" message body of the
created exchange. Once the exchange is processed, the body of the "out"
message will be sent as a response.

**Note:** By default, consumer parameters are wrapped into an array. If
you’ve got only one parameter, **since 2.12** you can use
`singleParameter` URI option to receive it directly in the "in" message
body without array wrapping.

# Examples

An example of using camel avro producers via http:

            <route>
                <from uri="direct:start"/>
                <to uri="avro:http:localhost:{{avroport}}?protocolClassName=org.apache.camel.avro.generated.KeyValueProtocol"/>
                <to uri="log:avro"/>
            </route>

In the example above you need to fill `CamelAvroMessageName` header.

You can use the following syntax to call constant messages:

            <route>
                <from uri="direct:start"/>
                <to uri="avro:http:localhost:{{avroport}}/put?protocolClassName=org.apache.camel.avro.generated.KeyValueProtocol"/>
                <to uri="log:avro"/>
            </route>

An example of consuming messages using camel avro consumers via netty:

            <route>
                <from uri="avro:netty:localhost:{{avroport}}?protocolClassName=org.apache.camel.avro.generated.KeyValueProtocol"/>
                <choice>
                    <when>
                        <el>${in.headers.CamelAvroMessageName == 'put'}</el>
                        <process ref="putProcessor"/>
                    </when>
                    <when>
                        <el>${in.headers.CamelAvroMessageName == 'get'}</el>
                        <process ref="getProcessor"/>
                    </when>
                </choice>
            </route>

You can set up two distinct routes to perform the same task:

            <route>
                <from uri="avro:netty:localhost:{{avroport}}/put?protocolClassName=org.apache.camel.avro.generated.KeyValueProtocol">
                <process ref="putProcessor"/>
            </route>
            <route>
                <from uri="avro:netty:localhost:{{avroport}}/get?protocolClassName=org.apache.camel.avro.generated.KeyValueProtocol&singleParameter=true"/>
                <process ref="getProcessor"/>
            </route>

In the example above, get takes only one parameter, so `singleParameter`
is used and `getProcessor` will receive Value class directly in body,
while `putProcessor` will receive an array of size 2 with `String` key
and `Value` value filled as array contents.

## Avro via HTTP SPI

The Avro RPC component offers the
`org.apache.camel.component.avro.spi.AvroRpcHttpServerFactory` service
provider interface (SPI) so that various platforms can provide their own
implementation based on their native HTTP server.

The default implementation available in
`org.apache.camel:camel-avro-jetty` is based on
`org.apache.avro:avro-ipc-jetty`.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|protocol|Avro protocol to use||object|
|protocolClassName|Avro protocol to use defined by the FQN class name||string|
|protocolLocation|Avro protocol location||string|
|reflectionProtocol|If the protocol object provided is reflection protocol. Should be used only with protocol parameter because for protocolClassName protocol type will be auto-detected|false|boolean|
|singleParameter|If true, consumer parameter won't be wrapped into an array. Will fail if protocol specifies more than one parameter for the message|false|boolean|
|uriAuthority|Authority to use (username and password)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use a shared AvroConfiguration to configure options once||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|transport|Transport to use, can be either http or netty||object|
|port|Port number to use||integer|
|host|Hostname to use||string|
|messageName|The name of the message to send.||string|
|protocol|Avro protocol to use||object|
|protocolClassName|Avro protocol to use defined by the FQN class name||string|
|protocolLocation|Avro protocol location||string|
|reflectionProtocol|If the protocol object provided is reflection protocol. Should be used only with protocol parameter because for protocolClassName protocol type will be auto-detected|false|boolean|
|singleParameter|If true, consumer parameter won't be wrapped into an array. Will fail if protocol specifies more than one parameter for the message|false|boolean|
|uriAuthority|Authority to use (username and password)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
