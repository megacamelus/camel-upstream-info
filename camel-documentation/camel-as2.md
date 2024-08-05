# As2

**Since Camel 2.22**

**Both producer and consumer are supported**

The AS2 component provides transport of EDI messages using the HTTP
transfer protocol as specified in
[RFC4130](https://tools.ietf.org/html/rfc4130).

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-as2</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    as2://apiName/methodName

apiName can be one of:

-   client

-   server

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|Component configuration||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|as2From|The value of the AS2From header of AS2 message.||string|
|as2MessageStructure|The structure of AS2 Message. One of: PLAIN - No encryption, no signature, SIGNED - No encryption, signature, ENCRYPTED - Encryption, no signature, ENCRYPTED\_SIGNED - Encryption, signature||object|
|as2To|The value of the AS2To header of AS2 message.||string|
|as2Version|The version of the AS2 protocol.|1.1|string|
|asyncMdnPortNumber|The port number of asynchronous MDN server.||integer|
|attachedFileName|The name of the attached file||string|
|clientFqdn|The Client Fully Qualified Domain Name (FQDN). Used in message ids sent by endpoint.|camel.apache.org|string|
|compressionAlgorithm|The algorithm used to compress EDI message.||object|
|dispositionNotificationTo|The value of the Disposition-Notification-To header. Assigning a value to this parameter requests a message disposition notification (MDN) for the AS2 message.||string|
|ediMessageTransferEncoding|The transfer encoding of EDI message.||string|
|ediMessageType|The content type of EDI message. One of application/edifact, application/edi-x12, application/edi-consent, application/xml||object|
|from|The value of the From header of AS2 message.||string|
|hostnameVerifier|Set hostname verifier for SSL session.||object|
|httpConnectionPoolSize|The maximum size of the connection pool for http connections (client only)|5|integer|
|httpConnectionPoolTtl|The time to live for connections in the connection pool (client only)|15m|object|
|httpConnectionTimeout|The timeout of the http connection (client only)|5s|object|
|httpSocketTimeout|The timeout of the underlying http socket (client only)|5s|object|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|mdnMessageTemplate|The template used to format MDN message||string|
|receiptDeliveryOption|The return URL that the message receiver should send an asynchronous MDN to. If not present the receipt is synchronous. (Client only)||string|
|requestUri|The request URI of EDI message.|/|string|
|server|The value included in the Server message header identifying the AS2 Server.|Camel AS2 Server Endpoint|string|
|serverFqdn|The Server Fully Qualified Domain Name (FQDN). Used in message ids sent by endpoint.|camel.apache.org|string|
|serverPortNumber|The port number of server.||integer|
|sslContext|Set SSL context for connection to remote server.||object|
|subject|The value of Subject header of AS2 message.||string|
|targetHostname|The host name (IP or DNS name) of target host.||string|
|targetPortNumber|The port number of target host. -1 indicates the scheme default port.|80|integer|
|userAgent|The value included in the User-Agent message header identifying the AS2 user agent.|Camel AS2 Client Endpoint|string|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|decryptingPrivateKey|The key used to encrypt the EDI message.||object|
|encryptingAlgorithm|The algorithm used to encrypt EDI message.||object|
|encryptingCertificateChain|The chain of certificates used to encrypt EDI message.||object|
|signedReceiptMicAlgorithms|The list of algorithms, in order of preference, requested to generate a message integrity check (MIC) returned in message dispostion notification (MDN)||array|
|signingAlgorithm|The algorithm used to sign EDI message.||object|
|signingCertificateChain|The chain of certificates used to sign EDI message.||object|
|signingPrivateKey|The key used to sign the EDI message.||object|
|validateSigningCertificateChain|Certificates to validate the message's signature against. If not supplied, validation will not take place. Server: validates the received message. Client: not yet implemented, should validate the MDN||object|
