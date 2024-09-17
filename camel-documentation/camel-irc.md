# Irc

**Since Camel 1.1**

**Both producer and consumer are supported**

The IRC component implements an
[IRC](http://en.wikipedia.org/wiki/Internet_Relay_Chat) (Internet Relay
Chat) transport.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-irc</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Usage

## SSL Support

### Using the JSSE Configuration Utility

The IRC component supports SSL/TLS configuration through the [Camel JSSE
Configuration Utility](#manual::camel-configuration-utilities.adoc).
This utility greatly decreases the amount of component-specific code you
need to write and is configurable at the endpoint and component levels.
The following examples demonstrate how to use the utility with the IRC
component.

Programmatic configuration of the endpoint

    KeyStoreParameters ksp = new KeyStoreParameters();
    ksp.setResource("/users/home/server/truststore.jks");
    ksp.setPassword("keystorePassword");
    
    TrustManagersParameters tmp = new TrustManagersParameters();
    tmp.setKeyStore(ksp);
    
    SSLContextParameters scp = new SSLContextParameters();
    scp.setTrustManagers(tmp);
    
    Registry registry = ...
    registry.bind("sslContextParameters", scp);
    
    ...
    
    from(...)
        .to("ircs://camel-prd-user@server:6669/#camel-test?nickname=camel-prd&password=password&sslContextParameters=#sslContextParameters");

Spring DSL based configuration of endpoint

    ...
      <camel:sslContextParameters
          id="sslContextParameters">
        <camel:trustManagers>
          <camel:keyStore
              resource="/users/home/server/truststore.jks"
              password="keystorePassword"/>
        </camel:keyManagers>
      </camel:sslContextParameters>...
    ...
      <to uri="ircs://camel-prd-user@server:6669/#camel-test?nickname=camel-prd&password=password&sslContextParameters=#sslContextParameters"/>...

## Using the legacy basic configuration options

You can also connect to an SSL enabled IRC server, as follows:

    ircs:host[:port]/#room?username=user&password=pass

By default, the IRC transport uses
[SSLDefaultTrustManager](http://moepii.sourceforge.net/irclib/javadoc/org/schwering/irc/lib/ssl/SSLDefaultTrustManager.html).
If you need to provide your own custom trust manager, use the
`trustManager` parameter as follows:

    ircs:host[:port]/#room?username=user&password=pass&trustManager=#referenceToMyTrustManagerBean

# Examples

## Using keys

Some IRC rooms require you to provide a key to be able to join that
channel. The key is just a secret word.

For example, we join three channels whereas only channel 1 and 3 use a
key.

    irc:nick@irc.server.org?channels=#chan1,#chan2,#chan3&keys=chan1Key,,chan3key

## Getting a list of channel users

Using the `namesOnJoin` option one can invoke the IRC-`NAMES` command
after the component has joined a channel. The server will reply with
`irc.num = 353`. So to process the result the property `onReply` has to
be `true`. Furthermore, one has to filter the `onReply` exchanges to get
the names.

For example, we want to get all exchanges that contain the usernames of
the channel:

    from("ircs:nick@myserver:1234/#mychannelname?namesOnJoin=true&onReply=true")
            .choice()
                    .when(header("irc.messageType").isEqualToIgnoreCase("REPLY"))
                            .filter(header("irc.num").isEqualTo("353"))
                            .to("mock:result").stop();

## Sending to a different channel or a person

If you need to send messages to a different channel (or a person) which
is not defined on IRC endpoint, you can specify a different destination
in a message header.

You can specify the destination in the following header:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>irc.sendTo</code></p></td>
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>The channel (or the person)
name.</p></td>
</tr>
</tbody>
</table>

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|hostname|Hostname for the IRC chat server||string|
|port|Port number for the IRC chat server. If no port is configured then a default port of either 6667, 6668 or 6669 is used.||integer|
|autoRejoin|Whether to auto re-join when being kicked|true|boolean|
|channels|Comma separated list of IRC channels.||string|
|commandTimeout|Delay in milliseconds before sending commands after the connection is established.|5000|integer|
|keys|Comma separated list of keys for channels.||string|
|namesOnJoin|Sends NAMES command to channel after joining it. onReply has to be true in order to process the result which will have the header value irc.num = '353'.|false|boolean|
|nickname|The nickname used in chat.||string|
|persistent|Use persistent messages.|true|boolean|
|realname|The IRC user's actual name.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|colors|Whether or not the server supports color codes.|true|boolean|
|onJoin|Handle user join events.|true|boolean|
|onKick|Handle kick events.|true|boolean|
|onMode|Handle mode change events.|true|boolean|
|onNick|Handle nickname change events.|true|boolean|
|onPart|Handle user part events.|true|boolean|
|onPrivmsg|Handle private message events.|true|boolean|
|onQuit|Handle user quit events.|true|boolean|
|onReply|Whether or not to handle general responses to commands or informational messages.|false|boolean|
|onTopic|Handle topic change events.|true|boolean|
|nickPassword|Your IRC server nickname password.||string|
|password|The IRC server password.||string|
|sslContextParameters|Used for configuring security using SSL. Reference to a org.apache.camel.support.jsse.SSLContextParameters in the Registry. This reference overrides any configured SSLContextParameters at the component level. Note that this setting overrides the trustManager option.||object|
|trustManager|The trust manager used to verify the SSL server's certificate.||object|
|username|The IRC server user name.||string|
