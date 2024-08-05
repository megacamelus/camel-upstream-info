# Stomp

**Since Camel 2.12**

**Both producer and consumer are supported**

The Stomp component is used for communicating with
[Stomp](http://stomp.github.io/) compliant message brokers, like [Apache
ActiveMQ](http://activemq.apache.org) or [ActiveMQ
Apollo](http://activemq.apache.org/apollo/)

Since STOMP specification is not actively maintained, please note [STOMP
JMS
client](https://github.com/fusesource/stompjms/tree/master/stompjms-client)
is not as well actively maintained. However, we hope for the community
to step up to help in maintaining the STOMP JMS project in the near
future.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-stomp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    stomp:queue:destination[?options]

Where **destination** is the name of the queue.

# Samples

Sending messages:

    from("direct:foo").to("stomp:queue:test");

Consuming messages:

    from("stomp:queue:test").transform(body().convertToString()).to("mock:result")

# Endpoints

Camel supports the Message Endpoint pattern using the
[Endpoint](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html)
interface. Endpoints are usually created by a Component, and Endpoints
are usually referred to in the DSL via their URIs.

From an Endpoint you can use the following methods

-   [createProducer()](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html#createProducer--)
    will create a
    [Producer](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Producer.html)
    for sending message exchanges to the endpoint

-   [createConsumer()](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html#createConsumer-org.apache.camel.Processor-)
    implements the Event Driven Consumer pattern for consuming message
    exchanges from the endpoint via a
    [Processor](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Processor.html)
    when creating a
    [Consumer](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Consumer.html)

-   [createPollingConsumer()](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/Endpoint.html#createPollingConsumer--)
    implements the Polling Consumer pattern for consuming message
    exchanges from the endpoint via a
    [PollingConsumer](https://www.javadoc.io/doc/org.apache.camel/camel-api/current/org/apache/camel/PollingConsumer.html)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|brokerURL|The URI of the Stomp broker to connect to|tcp://localhost:61613|string|
|customHeaders|To set custom headers||object|
|host|The virtual host name||string|
|version|The stomp version (1.1, or 1.2)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|Component configuration.||object|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|login|The username||string|
|passcode|The password||string|
|sslContextParameters|To configure security using SSLContextParameters||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|destination|Name of the queue||string|
|brokerURL|The URI of the Stomp broker to connect to|tcp://localhost:61613|string|
|customHeaders|To set custom headers||object|
|host|The virtual host name||string|
|version|The stomp version (1.1, or 1.2)||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|login|The username||string|
|passcode|The password||string|
|sslContextParameters|To configure security using SSLContextParameters||object|
