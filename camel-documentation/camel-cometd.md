# Cometd

**Since Camel 2.0**

**Both producer and consumer are supported**

The Cometd component is a transport mechanism for working with the
[jetty](http://www.mortbay.org/jetty) implementation of the
[cometd/bayeux
protocol](http://docs.codehaus.org/display/JETTY/Cometd+%28aka+Bayeux%29).  
Using this component in combination with the dojo toolkit library, it’s
possible to push Camel messages directly into the browser using an
AJAX-based mechanism.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-cometd</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    cometd://host:port/channelName[?options]

The **channelName** represents a topic that can be subscribed to by the
Camel endpoints.

    cometd://localhost:8080/service/mychannel
    cometds://localhost:8443/service/mychannel

where `cometds:` represents an SSL configured endpoint.

# Examples

Below, you can find some examples of how to pass the parameters.

For file, for webapp resources located in the Web Application directory
\-→ `cometd://localhost:8080?resourceBase=file./webapp`.

For classpath, when, for example, the web resources are packaged inside
the webapp folder -→
`cometd://localhost:8080?resourceBase=classpath:webapp`

## Authentication

You can configure custom `SecurityPolicy` and `Extension`'s to the
`CometdComponent` which allows you to use authentication as [documented
here](http://cometd.org/documentation/howtos/authentication)

## Setting up SSL for Cometd Component

### Using the JSSE Configuration Utility

The Cometd component supports SSL/TLS configuration through the [Camel
JSSE Configuration
Utility](#manual::camel-configuration-utilities.adoc). This utility
greatly decreases the amount of component-specific code you need to
write and is configurable at the endpoint and component levels. The
following examples demonstrate how to use the utility with the Cometd
component. You need to configure SSL on the CometdComponent.x

Java  
Programmatic configuration of the component:

    KeyStoreParameters ksp = new KeyStoreParameters();
    ksp.setResource("/users/home/server/keystore.jks");
    ksp.setPassword("keystorePassword");
    
    KeyManagersParameters kmp = new KeyManagersParameters();
    kmp.setKeyStore(ksp);
    kmp.setKeyPassword("keyPassword");
    
    TrustManagersParameters tmp = new TrustManagersParameters();
    tmp.setKeyStore(ksp);
    
    SSLContextParameters scp = new SSLContextParameters();
    scp.setKeyManagers(kmp);
    scp.setTrustManagers(tmp);
    
    CometdComponent commetdComponent = getContext().getComponent("cometds", CometdComponent.class);
    commetdComponent.setSslContextParameters(scp);

Spring XML  
\<camel:sslContextParameters
id="sslContextParameters"\>
\<camel:keyManagers
keyPassword="keyPassword"\>
\<camel:keyStore
resource="/users/home/server/keystore.jks"
password="keystorePassword"/\>
\</camel:keyManagers\>
[camel:trustManagers](camel:trustManagers)
\<camel:keyStore
resource="/users/home/server/keystore.jks"
password="keystorePassword"/\>
\</camel:keyManagers\>
\</camel:sslContextParameters\>

      <bean id="cometd" class="org.apache.camel.component.cometd.CometdComponent">
        <property name="sslContextParameters" ref="sslContextParameters"/>
      </bean>
    
      <to uri="cometds://127.0.0.1:443/service/test?baseResource=file:./target/test-classes/webapp&timeout=240000&interval=0&maxInterval=30000&multiFrameInterval=1500&jsonCommented=true&logLevel=2"/>...

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|extensions|To use a list of custom BayeuxServer.Extension that allows modifying incoming and outgoing requests.||array|
|securityPolicy|To use a custom configured SecurityPolicy to control authorization||object|
|sslContextParameters|To configure security using SSLContextParameters||object|
|sslKeyPassword|The password for the keystore when using SSL.||string|
|sslKeystore|The path to the keystore.||string|
|sslPassword|The password when using SSL.||string|
|useGlobalSslContextParameters|Enable usage of global SSL context parameters.|false|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|host|Hostname||string|
|port|Host port number||integer|
|channelName|The channelName represents a topic that can be subscribed to by the Camel endpoints.||string|
|allowedOrigins|The origins domain that support to cross, if the crosssOriginFilterOn is true|\*|string|
|baseResource|The root directory for the web resources or classpath. Use the protocol file: or classpath: depending if you want that the component loads the resource from file system or classpath. Classpath is required for OSGI deployment where the resources are packaged in the jar||string|
|crossOriginFilterOn|If true, the server will support for cross-domain filtering|false|boolean|
|filterPath|The filterPath will be used by the CrossOriginFilter, if the crosssOriginFilterOn is true||string|
|interval|The client side poll timeout in milliseconds. How long a client will wait between reconnects||integer|
|jsonCommented|If true, the server will accept JSON wrapped in a comment and will generate JSON wrapped in a comment. This is a defence against Ajax Hijacking.|true|boolean|
|logLevel|Logging level. 0=none, 1=info, 2=debug.|1|integer|
|maxInterval|The max client side poll timeout in milliseconds. A client will be removed if a connection is not received in this time.|30000|integer|
|multiFrameInterval|The client side poll timeout, if multiple connections are detected from the same browser.|1500|integer|
|timeout|The server side poll timeout in milliseconds. This is how long the server will hold a reconnect request before responding.|240000|integer|
|sessionHeadersEnabled|Whether to include the server session headers in the Camel message when creating a Camel Message for incoming requests.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|disconnectLocalSession|Whether to disconnect local sessions after publishing a message to its channel. Disconnecting local session is needed as they are not swept by default by CometD, and therefore you can run out of memory.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
