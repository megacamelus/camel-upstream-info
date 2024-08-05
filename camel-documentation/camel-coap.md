# Coap

**Since Camel 2.16**

**Both producer and consumer are supported**

Camel-CoAP is an [Apache Camel](http://camel.apache.org/) component that
allows you to work with CoAP, a lightweight REST-type protocol for
machine-to-machine operation. [CoAP](http://coap.technology/),
Constrained Application Protocol is a specialized web transfer protocol
for use with constrained nodes and constrained networks, and it is based
on RFC 7252.

Camel supports the DTLS, TCP and TLS protocols via the following URI
schemes:

<table>
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Scheme</th>
<th style="text-align: left;">Protocol</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>coap</p></td>
<td style="text-align: left;"><p>UDP</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>coaps</p></td>
<td style="text-align: left;"><p>UDP + DTLS</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>coap+tcp</p></td>
<td style="text-align: left;"><p>TCP</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>coaps+tcp</p></td>
<td style="text-align: left;"><p>TCP + TLS</p></td>
</tr>
</tbody>
</table>

There are a number of different configuration options to configure TLS.
For both DTLS (the "coaps" uri scheme) and TCP + TLS (the "coaps+tcp"
uri scheme), it is possible to use a "sslContextParameters" parameter,
from which the camel-coap component will extract the required truststore
/ keystores etc. to set up TLS. In addition, the DTLS protocol supports
two alternative configuration mechanisms. To use a pre-shared key,
configure a pskStore, and to work with raw public keys, configure
privateKey + publicKey objects.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
     <groupId>org.apache.camel</groupId>
     <artifactId>camel-coap</artifactId>
     <version>x.x.x</version>
     <!-- use the same version as your Camel core version -->
    </dependency>

# Configuring the CoAP producer request method

The following rules determine which request method the CoAP producer
will use to invoke the target URI:

1.  The value of the `CamelCoapMethod` header

2.  **GET** if a query string is provided on the target CoAP server URI.

3.  **POST** if the message exchange body is not null.

4.  **GET** otherwise.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|uri|The URI for the CoAP endpoint||string|
|coapMethodRestrict|Comma separated list of methods that the CoAP consumer will bind to. The default is to bind to all methods (DELETE, GET, POST, PUT).||string|
|observable|Make CoAP resource observable for source endpoint, based on RFC 7641.|false|boolean|
|observe|Send an observe request from a source endpoint, based on RFC 7641.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|notify|Notify observers that the resource of this URI has changed, based on RFC 7641. Use this flag on a destination endpoint, with a URI that matches an existing source endpoint URI.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|advancedCertificateVerifier|Set the AdvancedCertificateVerifier to use to determine trust in raw public keys.||object|
|advancedPskStore|Set the AdvancedPskStore to use for pre-shared key.||object|
|alias|Sets the alias used to query the KeyStore for the private key and certificate. This parameter is used when we are enabling TLS with certificates on the service side, and similarly on the client side when TLS is used with certificates and client authentication. If the parameter is not specified then the default behavior is to use the first alias in the keystore that contains a key entry. This configuration parameter does not apply to configuring TLS via a Raw Public Key or a Pre-Shared Key.||string|
|cipherSuites|Sets the cipherSuites String. This is a comma separated String of ciphersuites to configure. If it is not specified, then it falls back to getting the ciphersuites from the sslContextParameters object.||string|
|clientAuthentication|Sets the configuration options for server-side client-authentication requirements. The value must be one of NONE, WANT, REQUIRE. If this value is not specified, then it falls back to checking the sslContextParameters.getServerParameters().getClientAuthentication() value.||object|
|privateKey|Set the configured private key for use with Raw Public Key.||object|
|publicKey|Set the configured public key for use with Raw Public Key.||object|
|recommendedCipherSuitesOnly|The CBC cipher suites are not recommended. If you want to use them, you first need to set the recommendedCipherSuitesOnly option to false.|true|boolean|
|sslContextParameters|Set the SSLContextParameters object for setting up TLS. This is required for coapstcp, and for coaps when we are using certificates for TLS (as opposed to RPK or PKS).||object|
