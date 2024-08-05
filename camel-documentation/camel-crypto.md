# Crypto

**Since Camel 2.3**

**Only producer is supported**

With Camel cryptographic endpoints and Java’s Cryptographic extension,
it is possible to create Digital Signatures for Exchanges. Camel
provides a pair of flexible endpoints which get used in concert to
create a signature for an exchange in one part of the exchange’s
workflow and then verify the signature in a later part of the workflow.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-crypto</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# Introduction

Digital signatures make use of Asymmetric Cryptographic techniques to
sign messages. From a (very) high level, the algorithms use pairs of
complimentary keys with the special property that data encrypted with
one key can only be decrypted with the other. One, the private key, is
closely guarded and used to *sign* the message while the other, public
key, is shared around to anyone interested in verifying the signed
messages. Messages are signed by using the private key to encrypting a
digest of the message. This encrypted digest is transmitted along with
the message. On the other side, the verifier recalculates the message
digest and uses the public key to decrypt the digest in the signature.
If both digests match, the verifier knows only the holder of the private
key could have created the signature.

Camel uses the Signature service from the Java Cryptographic Extension
to do all the heavy cryptographic lifting required to create exchange
signatures. The following are some excellent resources for explaining
the mechanics of Cryptography, Message digests and Digital Signatures
and how to leverage them with the JCE.

-   Bruce Schneier’s Applied Cryptography

-   Beginning Cryptography with Java by David Hook

-   The ever insightful Wikipedia
    [Digital\_signatures](http://en.wikipedia.org/wiki/Digital_signature)

# URI format

As mentioned, Camel provides a pair of crypto endpoints to create and
verify signatures

    crypto:sign:name[?options]
    crypto:verify:name[?options]

-   `crypto:sign` creates the signature and stores it in the Header
    keyed by the constant
    `org.apache.camel.component.crypto.DigitalSignatureConstants.SIGNATURE`,
    i.e., `"CamelDigitalSignature"`.

-   `crypto:verify` will read in the contents of this header and do the
    verification calculation.

To correctly function, the sign and verify process needs a pair of keys
to be shared, signing requiring a `PrivateKey` and verifying a
`PublicKey` (or a `Certificate` containing one). Using the JCE it is
very simple to generate these key pairs, but it is usually most secure
to use a KeyStore to house and share your keys. The DSL is very flexible
about how keys are supplied and provides a number of mechanisms.

Note a `crypto:sign` endpoint is typically defined in one route and the
complimentary `crypto:verify` in another, though for simplicity in the
examples they appear one after the other. It goes without saying that
both signing and verifying should be configured identically.

# Using

## Raw keys

The most basic way to sign and verify an exchange is with a KeyPair as
follows.

    KeyPair keyPair = KeyGenerator.getInstance("RSA").generateKeyPair();
    
    from("direct:sign")
        .setHeader(DigitalSignatureConstants.SIGNATURE_PRIVATE_KEY, constant(keys.getPrivate()))
        .to("crypto:sign:message")
        .to("direct:verify");
    
    from("direct:verify")
        .setHeader(DigitalSignatureConstants.SIGNATURE_PUBLIC_KEY_OR_CERT, constant(keys.getPublic()))
        .to("crypto:verify:check");

The same can be achieved with the [Spring XML
Extensions](#manual::spring-xml-extensions.adoc) using references to
keys

## KeyStores and Aliases.

The JCE provides a very versatile keystore concept for housing pairs of
private keys and certificates, keeping them encrypted and password
protected. They can be retrieved by applying an alias to the retrieval
APIs. There are a number of ways to get keys and Certificates into a
keystore, most often this is done with the external *keytool*
application.

The following command will create a keystore containing a key and
certificate aliased by `bob`, which can be used in the following
examples. The password for the keystore and the key is `letmein`.

    keytool -genkey -keyalg RSA -keysize 2048 -keystore keystore.jks -storepass letmein -alias bob -dname "CN=Bob,OU=IT,O=Camel" -noprompt

The following route first signs an exchange using Bob’s alias from the
KeyStore bound into the Camel Registry, and then verifies it using the
same alias.

    from("direct:sign")
        .to("crypto:sign:keystoreSign?alias=bob&keystoreName=myKeystore&password=letmein")
        .log("Signature: ${header.CamelDigitalSignature}")
        .to("crypto:verify:keystoreVerify?alias=bob&keystoreName=myKeystore&password=letmein")
        .log("Verified: ${body}");

The following code shows how to load the keystore created using the
above `keytool` command and bind it into the registry with the name
`myKeystore` for use in the above route. The example makes use of the
`@Configuration` and `@BindToRegistry` annotations introduced in Camel 3
to instantiate the KeyStore and register it with the name `myKeyStore`.

    @Configuration
    public class KeystoreConfig {
    
        @BindToRegistry
        public KeyStore myKeystore() throws Exception {
            KeyStore store = KeyStore.getInstance("JKS");
            try (FileInputStream fis = new FileInputStream("keystore.jks")) {
                store.load(fis, "letmein".toCharArray());
            }
            return store;
        }
    }

Again in Spring, a ref is used to look up an actual keystore instance.

## Changing JCE Provider and Algorithm

Changing the Signature algorithm or the Security provider is a simple
matter of specifying their names. You will need to also use Keys that
are compatible with the algorithm you choose.

## Changing the Signature Message Header

It may be desirable to change the message header used to store the
signature. A different header name can be specified in the route
definition as follows

    from("direct:sign")
        .to("crypto:sign:keystoreSign?alias=bob&keystoreName=myKeystore&password=letmein&signatureHeaderName=mySignature")
        .log("Signature: ${header.mySignature}")
        .to("crypto:verify:keystoreVerify?alias=bob&keystoreName=myKeystore&password=letmein&signatureHeaderName=mySignature");

## Changing the bufferSize

In case you need to update the size of the buffer…

## Supplying Keys dynamically.

When using a Recipient list or similar EIP, the recipient of an exchange
can vary dynamically. Using the same key across all recipients may be
neither feasible nor desirable. It would be useful to be able to specify
signature keys dynamically on a per-exchange basis. The exchange could
then be dynamically enriched with the key of its target recipient prior
to signing. To facilitate this, the signature mechanisms allow for keys
to be supplied dynamically via the message headers below

-   `DigitalSignatureConstants.SIGNATURE_PRIVATE_KEY`,
    `"CamelSignaturePrivateKey"`

-   `DigitalSignatureConstants.SIGNATURE_PUBLIC_KEY_OR_CERT`,
    `"CamelSignaturePublicKeyOrCert"`

Even better would be to dynamically supply a keystore alias. Again, the
alias can be supplied in a message header

-   `DigitalSignatureConstants.KEYSTORE_ALIAS`,
    `"CamelSignatureKeyStoreAlias"`

The header would be set as follows:

    Exchange unsigned = getMandatoryEndpoint("direct:alias-sign").createExchange();
    unsigned.getIn().setBody(payload);
    unsigned.getIn().setHeader(DigitalSignatureConstants.KEYSTORE_ALIAS, "bob");
    unsigned.getIn().setHeader(DigitalSignatureConstants.KEYSTORE_PASSWORD, "letmein".toCharArray());
    template.send("direct:alias-sign", unsigned);
    Exchange signed = getMandatoryEndpoint("direct:alias-sign").createExchange();
    signed.getIn().copyFrom(unsigned.getMessage());
    signed.getIn().setHeader(DigitalSignatureConstants.KEYSTORE_ALIAS, "bob");
    template.send("direct:alias-verify", signed);

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|algorithm|Sets the JCE name of the Algorithm that should be used for the signer.|SHA256withRSA|string|
|alias|Sets the alias used to query the KeyStore for keys and {link java.security.cert.Certificate Certificates} to be used in signing and verifying exchanges. This value can be provided at runtime via the message header org.apache.camel.component.crypto.DigitalSignatureConstants#KEYSTORE\_ALIAS||string|
|certificateName|Sets the reference name for a PrivateKey that can be found in the registry.||string|
|keystore|Sets the KeyStore that can contain keys and Certficates for use in signing and verifying exchanges. A KeyStore is typically used with an alias, either one supplied in the Route definition or dynamically via the message header CamelSignatureKeyStoreAlias. If no alias is supplied and there is only a single entry in the Keystore, then this single entry will be used.||object|
|keystoreName|Sets the reference name for a Keystore that can be found in the registry.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|privateKey|Set the PrivateKey that should be used to sign the exchange||object|
|privateKeyName|Sets the reference name for a PrivateKey that can be found in the registry.||string|
|provider|Set the id of the security provider that provides the configured Signature algorithm.||string|
|publicKeyName|references that should be resolved when the context changes||string|
|secureRandomName|Sets the reference name for a SecureRandom that can be found in the registry.||string|
|signatureHeaderName|Set the name of the message header that should be used to store the base64 encoded signature. This defaults to 'CamelDigitalSignature'||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|bufferSize|Set the size of the buffer used to read in the Exchange payload data.|2048|integer|
|certificate|Set the Certificate that should be used to verify the signature in the exchange based on its payload.||object|
|clearHeaders|Determines if the Signature specific headers be cleared after signing and verification. Defaults to true, and should only be made otherwise at your extreme peril as vital private information such as Keys and passwords may escape if unset.|true|boolean|
|configuration|To use the shared DigitalSignatureConfiguration as configuration||object|
|keyStoreParameters|Sets the KeyStore that can contain keys and Certficates for use in signing and verifying exchanges based on the given KeyStoreParameters. A KeyStore is typically used with an alias, either one supplied in the Route definition or dynamically via the message header CamelSignatureKeyStoreAlias. If no alias is supplied and there is only a single entry in the Keystore, then this single entry will be used.||object|
|publicKey|Set the PublicKey that should be used to verify the signature in the exchange.||object|
|secureRandom|Set the SecureRandom used to initialize the Signature service||object|
|password|Sets the password used to access an aliased PrivateKey in the KeyStore.||string|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|cryptoOperation|Set the Crypto operation from that supplied after the crypto scheme in the endpoint uri e.g. crypto:sign sets sign as the operation.||object|
|name|The logical name of this operation.||string|
|algorithm|Sets the JCE name of the Algorithm that should be used for the signer.|SHA256withRSA|string|
|alias|Sets the alias used to query the KeyStore for keys and {link java.security.cert.Certificate Certificates} to be used in signing and verifying exchanges. This value can be provided at runtime via the message header org.apache.camel.component.crypto.DigitalSignatureConstants#KEYSTORE\_ALIAS||string|
|certificateName|Sets the reference name for a PrivateKey that can be found in the registry.||string|
|keystore|Sets the KeyStore that can contain keys and Certficates for use in signing and verifying exchanges. A KeyStore is typically used with an alias, either one supplied in the Route definition or dynamically via the message header CamelSignatureKeyStoreAlias. If no alias is supplied and there is only a single entry in the Keystore, then this single entry will be used.||object|
|keystoreName|Sets the reference name for a Keystore that can be found in the registry.||string|
|privateKey|Set the PrivateKey that should be used to sign the exchange||object|
|privateKeyName|Sets the reference name for a PrivateKey that can be found in the registry.||string|
|provider|Set the id of the security provider that provides the configured Signature algorithm.||string|
|publicKeyName|references that should be resolved when the context changes||string|
|secureRandomName|Sets the reference name for a SecureRandom that can be found in the registry.||string|
|signatureHeaderName|Set the name of the message header that should be used to store the base64 encoded signature. This defaults to 'CamelDigitalSignature'||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|bufferSize|Set the size of the buffer used to read in the Exchange payload data.|2048|integer|
|certificate|Set the Certificate that should be used to verify the signature in the exchange based on its payload.||object|
|clearHeaders|Determines if the Signature specific headers be cleared after signing and verification. Defaults to true, and should only be made otherwise at your extreme peril as vital private information such as Keys and passwords may escape if unset.|true|boolean|
|keyStoreParameters|Sets the KeyStore that can contain keys and Certficates for use in signing and verifying exchanges based on the given KeyStoreParameters. A KeyStore is typically used with an alias, either one supplied in the Route definition or dynamically via the message header CamelSignatureKeyStoreAlias. If no alias is supplied and there is only a single entry in the Keystore, then this single entry will be used.||object|
|publicKey|Set the PublicKey that should be used to verify the signature in the exchange.||object|
|secureRandom|Set the SecureRandom used to initialize the Signature service||object|
|password|Sets the password used to access an aliased PrivateKey in the KeyStore.||string|
