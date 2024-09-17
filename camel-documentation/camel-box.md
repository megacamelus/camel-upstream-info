# Box

**Since Camel 2.14**

**Both producer and consumer are supported**

The Box component provides access to all the Box.com APIs accessible
using [Box Java SDK](https://github.com/box/box-java-sdk/). It allows
producing messages to upload and download files, create, edit, and
manage folders, etc. It also supports APIs that allow polling for
updates to user accounts and even changes to enterprise accounts, etc.

Box.com requires the use of OAuth2.0 for all client application
authentications. To use camel-box with your account, you’ll need to
create a new application within Box.com at
[https://developer.box.com](https://developer.box.com/). The Box
application’s client id and secret will allow access to Box APIs which
require a current user. A user access token is generated and managed by
the API for an end user.

Maven users will need to add the following dependency to their pom.xml
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-box</artifactId>
        <version>${camel-version}</version>
    </dependency>

# Usage

## Connection Authentication Types

The Box component supports three different types of authenticated
connections.

### Standard Authentication

**Standard Authentication** uses the **OAuth 2.0 three-legged
authentication process** to authenticate its connections with Box.com.
This type of authentication enables Box **managed users** and **external
users** to access, edit, and save their Box content through the Box
component.

### App Enterprise Authentication

**App Enterprise Authentication** uses the **OAuth 2.0 with JSON Web
Tokens (JWT)** to authenticate its connections as a **Service Account**
for a **Box Application**. This type of authentication enables a service
account to access, edit, and save the Box content of its **Box
Application** through the Box component.

### App User Authentication

**App User Authentication** uses the **OAuth 2.0 with JSON Web Tokens
(JWT)** to authenticate its connections as an **App User** for a **Box
Application**. This type of authentication enables app users to access,
edit, and save their Box content in its **Box Application** through the
Box component.

# Examples

The following route uploads new files to the user’s root folder:

    from("file:...")
        .to("box://files/upload/inBody=fileUploadRequest");

The following route polls user’s account for updates:

    from("box://events/listen?startingPosition=-1")
        .to("bean:blah");

The following route uses a producer with dynamic header options. The
**fileId** property has the Box file id and the **output** property has
the output stream of the file contents, so they are assigned to the
**CamelBox.fileId** header and **CamelBox.output** header respectively
as follows:

    from("direct:foo")
        .setHeader("CamelBox.fileId", header("fileId"))
        .setHeader("CamelBox.output", header("output"))
        .to("box://files/download")
        .to("file://...");

## More information

See more details at the Box API reference:
[https://developer.box.com/reference](https://developer.box.com/reference)

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|clientId|Box application client ID||string|
|configuration|To use the shared configuration||object|
|enterpriseId|The enterprise ID to use for an App Enterprise.||string|
|userId|The user ID to use for an App User.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|httpParams|Custom HTTP params for settings like proxy host||object|
|authenticationType|The type of authentication for connection. Types of Authentication: STANDARD\_AUTHENTICATION - OAuth 2.0 (3-legged) SERVER\_AUTHENTICATION - OAuth 2.0 with JSON Web Tokens|APP\_USER\_AUTHENTICATION|string|
|accessTokenCache|Custom Access Token Cache for storing and retrieving access tokens.||object|
|clientSecret|Box application client secret||string|
|encryptionAlgorithm|The type of encryption algorithm for JWT. Supported Algorithms: RSA\_SHA\_256 RSA\_SHA\_384 RSA\_SHA\_512|RSA\_SHA\_256|object|
|maxCacheEntries|The maximum number of access tokens in cache.|100|integer|
|privateKeyFile|The private key for generating the JWT signature.||string|
|privateKeyPassword|The password for the private key.||string|
|publicKeyId|The ID for public key for validating the JWT signature.||string|
|sslContextParameters|To configure security using SSLContextParameters.||object|
|userName|Box user name, MUST be provided||string|
|userPassword|Box user password, MUST be provided if authSecureStorage is not set, or returns null on first call||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|apiName|What kind of operation to perform||object|
|methodName|What sub operation to use for the selected operation||string|
|clientId|Box application client ID||string|
|enterpriseId|The enterprise ID to use for an App Enterprise.||string|
|inBody|Sets the name of a parameter to be passed in the exchange In Body||string|
|userId|The user ID to use for an App User.||string|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|httpParams|Custom HTTP params for settings like proxy host||object|
|authenticationType|The type of authentication for connection. Types of Authentication: STANDARD\_AUTHENTICATION - OAuth 2.0 (3-legged) SERVER\_AUTHENTICATION - OAuth 2.0 with JSON Web Tokens|APP\_USER\_AUTHENTICATION|string|
|accessTokenCache|Custom Access Token Cache for storing and retrieving access tokens.||object|
|clientSecret|Box application client secret||string|
|encryptionAlgorithm|The type of encryption algorithm for JWT. Supported Algorithms: RSA\_SHA\_256 RSA\_SHA\_384 RSA\_SHA\_512|RSA\_SHA\_256|object|
|maxCacheEntries|The maximum number of access tokens in cache.|100|integer|
|privateKeyFile|The private key for generating the JWT signature.||string|
|privateKeyPassword|The password for the private key.||string|
|publicKeyId|The ID for public key for validating the JWT signature.||string|
|sslContextParameters|To configure security using SSLContextParameters.||object|
|userName|Box user name, MUST be provided||string|
|userPassword|Box user password, MUST be provided if authSecureStorage is not set, or returns null on first call||string|
