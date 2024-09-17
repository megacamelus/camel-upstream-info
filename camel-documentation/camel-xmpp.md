# Xmpp

**Since Camel 1.0**

**Both producer and consumer are supported**

The XMPP component implements an XMPP (Jabber) transport.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-xmpp</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    xmpp://[login@]hostname[:port][/participant][?Options]

The component supports both room based and private person-person
conversations.  
The component supports both producer and consumer (you can get messages
from XMPP or send messages to XMPP). Consumer mode supports rooms
starting.

# Usage

## Headers and setting Subject or Language

Camel sets the message IN headers as properties on the XMPP message. You
can configure a `HeaderFilterStategy` if you need custom filtering of
headers. The **Subject** and **Language** of the XMPP message are also
set if they are provided as IN headers.

# Examples

User `superman` to join room `krypton` at `jabber` server with password,
`secret`:

    xmpp://superman@jabber.org/?room=krypton@conference.jabber.org&password=secret

User `superman` to send messages to `joker`:

    xmpp://superman@jabber.org/joker@jabber.org?password=secret

Routing example in Java:

    from("timer://kickoff?period=10000").
    setBody(constant("I will win!\n Your Superman.")).
    to("xmpp://superman@jabber.org/joker@jabber.org?password=secret");

Consumer configuration, which writes all messages from `joker` into the
queue, `evil.talk`.

    from("xmpp://superman@jabber.org/joker@jabber.org?password=secret").
    to("activemq:evil.talk");

Consumer configuration, which listens to room messages:

    from("xmpp://superman@jabber.org/?password=secret&room=krypton@conference.jabber.org").
    to("activemq:krypton.talk");

Room in short notation (no domain part):

    from("xmpp://superman@jabber.org/?password=secret&room=krypton").
    to("activemq:krypton.talk");

When connecting to the Google Chat service, you’ll need to specify the
`serviceName` as well as your credentials:

    from("direct:start").
      to("xmpp://talk.google.com:5222/touser@gmail.com?serviceName=gmail.com&user=fromuser&password=secret").
      to("mock:result");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname for the chat server||string|
|port|Port number for the chat server||integer|
|participant|JID (Jabber ID) of person to receive messages. room parameter has precedence over participant.||string|
|login|Whether to login the user.|true|boolean|
|nickname|Use nickname when joining room. If room is specified and nickname is not, user will be used for the nickname.||string|
|pubsub|Accept pubsub packets on input, default is false|false|boolean|
|room|If this option is specified, the component will connect to MUC (Multi User Chat). Usually, the domain name for MUC is different from the login domain. For example, if you are supermanjabber.org and want to join the krypton room, then the room URL is kryptonconference.jabber.org. Note the conference part. It is not a requirement to provide the full room JID. If the room parameter does not contain the symbol, the domain part will be discovered and added by Camel||string|
|serviceName|The name of the service you are connecting to. For Google Talk, this would be gmail.com.||string|
|testConnectionOnStartup|Specifies whether to test the connection on startup. This is used to ensure that the XMPP client has a valid connection to the XMPP server when the route starts. Camel throws an exception on startup if a connection cannot be established. When this option is set to false, Camel will attempt to establish a lazy connection when needed by a producer, and will poll for a consumer connection until the connection is established. Default is true.|true|boolean|
|createAccount|If true, an attempt to create an account will be made. Default is false.|false|boolean|
|resource|XMPP resource. The default is Camel.|Camel|string|
|connectionPollDelay|The amount of time in seconds between polls (in seconds) to verify the health of the XMPP connection, or between attempts to establish an initial consumer connection. Camel will try to re-establish a connection if it has become inactive. Default is 10 seconds.|10|integer|
|doc|Set a doc header on the IN message containing a Document form of the incoming packet; default is true if presence or pubsub are true, otherwise false|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|connectionConfig|To use an existing connection configuration. Currently org.jivesoftware.smack.tcp.XMPPTCPConnectionConfiguration is only supported (XMPP over TCP).||object|
|headerFilterStrategy|To use a custom HeaderFilterStrategy to filter header to and from Camel message.||object|
|password|Password for login||string|
|roomPassword|Password for room||string|
|user|User name (without server name). If not specified, anonymous login will be attempted.||string|
