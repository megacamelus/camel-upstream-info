# Nats

**Since Camel 2.17**

**Both producer and consumer are supported**

[NATS](http://nats.io/) is a fast and reliable messaging platform.

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-nats</artifactId>
        <!-- use the same version as your Camel core version -->
        <version>x.y.z</version>
    </dependency>

# URI format

    nats:topic[?options]

Where **topic** is the topic name

# Usage

## Configuring servers

You configure the NATS servers on either the component or the endpoint.

For example, to configure this once on the component, you can do:

    NatsComponent nats = context.getComponent("nats", NatsComponent.class);
    nats.setServers("someserver:4222,someotherserver:42222");

Notice how you can specify multiple servers separated by comma.

Or you can specify the servers in the endpoint URI

    from("direct:send").to("nats:test?servers=localhost:4222");

The endpoint configuration will override any server configuration on the
component level.

## Configuring username and password or token

You can specify username and password for the servers in the server
URLs, where its `username:password@url`, or `token@url` etc:

    NatsComponent nats = context.getComponent("nats", NatsComponent.class);
    nats.setServers("scott:tiger@someserver:4222,superman:123@someotherserver:42222");

If you are using Camel Main or Spring Boot, you can configure the server
urls in the `application.properties` file

    camel.component.nats.servers=scott:tiger@someserver:4222,superman:123@someotherserver:42222

## Request/Reply support

The producer supports request/reply where it can wait for an expected
reply message.

The consumer will, when routing the message is complete, send back the
message as reply-message if required.

# Examples

## Producer example

    from("direct:send")
      .to("nats:mytopic");

In case of using authorization, you can directly specify your
credentials in the server URL

    from("direct:send")
      .to("nats:mytopic?servers=username:password@localhost:4222");

or your token

    from("direct:send")
      .to("nats:mytopic?servers=token@localhost:4222);

## Consumer example

    from("nats:mytopic?maxMessages=5&queueName=myqueue")
      .to("mock:result");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|servers|URLs to one or more NAT servers. Use comma to separate URLs when specifying multiple servers.||string|
|verbose|Whether or not running in verbose mode|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|headerFilterStrategy|To use a custom org.apache.camel.spi.HeaderFilterStrategy to filter header to and from Camel message.||object|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|topic|The name of topic we want to use||string|
|connectionTimeout|Timeout for connection attempts. (in milliseconds)|2000|integer|
|flushConnection|Define if we want to flush connection when stopping or not|true|boolean|
|flushTimeout|Set the flush timeout (in milliseconds)|1000|integer|
|maxPingsOut|maximum number of pings have not received a response allowed by the client|2|integer|
|maxReconnectAttempts|Max reconnection attempts|60|integer|
|noEcho|Turn off echo. If supported by the gnatsd version you are connecting to this flag will prevent the server from echoing messages back to the connection if it has subscriptions on the subject being published to.|false|boolean|
|noRandomizeServers|Whether or not randomizing the order of servers for the connection attempts|false|boolean|
|pedantic|Whether or not running in pedantic mode (this affects performance)|false|boolean|
|pingInterval|Ping interval to be aware if connection is still alive (in milliseconds)|120000|integer|
|reconnect|Whether or not using reconnection feature|true|boolean|
|reconnectTimeWait|Waiting time before attempts reconnection (in milliseconds)|2000|integer|
|requestCleanupInterval|Interval to clean up cancelled/timed out requests.|5000|integer|
|servers|URLs to one or more NAT servers. Use comma to separate URLs when specifying multiple servers.||string|
|verbose|Whether or not running in verbose mode|false|boolean|
|maxMessages|Stop receiving messages from a topic we are subscribing to after maxMessages||string|
|poolSize|Consumer thread pool size (default is 10)|10|integer|
|queueName|The Queue name if we are using nats for a queue configuration||string|
|replyToDisabled|Can be used to turn off sending back reply message in the consumer.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|replySubject|the subject to which subscribers should send response||string|
|requestTimeout|Request timeout in milliseconds|20000|integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|connection|Reference an already instantiated connection to Nats server||object|
|headerFilterStrategy|Define the header filtering strategy||object|
|traceConnection|Whether or not connection trace messages should be printed to standard out for fine grained debugging of connection issues.|false|boolean|
|credentialsFilePath|If we use useCredentialsFile to true we'll need to set the credentialsFilePath option. It can be loaded by default from classpath, but you can prefix with classpath:, file:, or http: to load the resource from different systems.||string|
|secure|Set secure option indicating TLS is required|false|boolean|
|sslContextParameters|To configure security using SSLContextParameters||object|
