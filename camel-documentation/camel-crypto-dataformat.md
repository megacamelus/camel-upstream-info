# Crypto-dataformat.md

**Since Camel 2.3**

The Crypto Data Format integrates the Java Cryptographic Extension into
Camel, allowing simple and flexible encryption and decryption of
messages using Camel’s familiar marshall and unmarshal formatting
mechanism. It assumes marshaling to mean encryption to cyphertext and
unmarshalling to mean decryption back to the original plaintext. This
data format implements only symmetric (shared-key) encryption and
decyption.

# CryptoDataFormat Options

# Basic Usage

At its most basic, all that is required to encrypt/decrypt an exchange
is a shared secret key. If one or more instances of the Crypto data
format are configured with this key, the format can be used to encrypt
the payload in one route (or part of one) and decrypted in another. For
example, using the Java DSL as follows:

    KeyGenerator generator = KeyGenerator.getInstance("DES");
    
    CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES", generator.generateKey());
    
    from("direct:basic-encryption")
        .marshal(cryptoFormat)
        .to("mock:encrypted")
        .unmarshal(cryptoFormat)
        .to("mock:unencrypted");

In Spring the dataformat is configured first and then used in routes

    <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
      <dataFormats>
        <crypto id="basic" algorithm="DES" keyRef="desKey" />
      </dataFormats>
        ...
      <route>
        <from uri="direct:basic-encryption" />
        <marshal ref="basic" />
        <to uri="mock:encrypted" />
        <unmarshal ref="basic" />
        <to uri="mock:unencrypted" />
      </route>
    </camelContext>

# Specifying the Encryption Algorithm

Changing the algorithm is a matter of supplying the JCE algorithm name.
If you change the algorithm, you will need to use a compatible key.

    KeyGenerator generator = KeyGenerator.getInstance("DES");
    
    CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES", generator.generateKey());
    cryptoFormat.setShouldAppendHMAC(true);
    cryptoFormat.setMacAlgorithm("HmacMD5");
    
    from("direct:hmac-algorithm")
        .marshal(cryptoFormat)
        .to("mock:encrypted")
        .unmarshal(cryptoFormat)
        .to("mock:unencrypted");

A list of the available algorithms in Java 17 is available via the [Java
Security Standard Algorithm
Names](https://docs.oracle.com/en/java/javase/17/docs/specs/security/standard-names.html)
documentation.

# Specifying an Initialization Vector

Some crypto algorithms, particularly block algorithms, require
configuration with an initial block of data known as an Initialization
Vector. In the JCE this is passed as an AlgorithmParameterSpec when the
Cipher is initialized. To use such a vector with the CryptoDataFormat,
you can configure it with a byte\[\] containing the required data, e.g.

    KeyGenerator generator = KeyGenerator.getInstance("DES");
    byte[] initializationVector = new byte[] {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
    
    CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES/CBC/PKCS5Padding", generator.generateKey());
    cryptoFormat.setInitializationVector(initializationVector);
    
    from("direct:init-vector")
        .marshal(cryptoFormat)
        .to("mock:encrypted")
        .unmarshal(cryptoFormat)
        .to("mock:unencrypted");

or with spring, suppling a reference to a byte\[\]

    <crypto id="initvector" algorithm="DES/CBC/PKCS5Padding" keyRef="desKey" initVectorRef="initializationVector" />

The same vector is required in both the encryption and decryption
phases. As it is not necessary to keep the IV a secret, the DataFormat
allows for it to be inlined into the encrypted data and subsequently
read out in the decryption phase to initialize the Cipher. To inline the
IV set the `Inline` flag.

Java  
KeyGenerator generator = KeyGenerator.getInstance("DES");
byte\[\] initializationVector = new byte\[\] {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07};
SecretKey key = generator.generateKey();

    CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES/CBC/PKCS5Padding", key);
    cryptoFormat.setInitializationVector(initializationVector);
    cryptoFormat.setShouldInlineInitializationVector(true);
    CryptoDataFormat decryptFormat = new CryptoDataFormat("DES/CBC/PKCS5Padding", key);
    decryptFormat.setShouldInlineInitializationVector(true);
    
    from("direct:inline")
        .marshal(cryptoFormat)
        .to("mock:encrypted")
        .unmarshal(decryptFormat)
        .to("mock:unencrypted");

Spring XML  
<crypto id="inline" algorithm="DES/CBC/PKCS5Padding" keyRef="desKey" initVectorRef="initializationVector"
inline="true" />  
<crypto id="inline-decrypt" algorithm="DES/CBC/PKCS5Padding" keyRef="desKey" inline="true" />

For more information about the use of Initialization Vectors, consult

-   [http://en.wikipedia.org/wiki/Initialization\_vector](http://en.wikipedia.org/wiki/Initialization_vector)

-   [http://www.herongyang.com/Cryptography/](http://www.herongyang.com/Cryptography/)

-   [http://en.wikipedia.org/wiki/Block\_cipher\_mode\_of\_operation](http://en.wikipedia.org/wiki/Block_cipher_mode_of_operation)

# Hashed Message Authentication Codes (HMAC)

To avoid attacks against the encrypted data while it is in transit, the
CryptoDataFormat can also calculate a Message Authentication Code for
the encrypted exchange contents based on a configurable MAC algorithm.
The calculated HMAC is appended to the stream after encryption. It is
separated from the stream in the decryption phase. The MAC is
recalculated and verified against the transmitted version to ensure
nothing was tampered with in transit. For more information on Message
Authentication Codes see [http://en.wikipedia.org/wiki/HMAC](http://en.wikipedia.org/wiki/HMAC)

Java  
KeyGenerator generator = KeyGenerator.getInstance("DES");

    CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES", generator.generateKey());
    cryptoFormat.setShouldAppendHMAC(true);
    
    from("direct:hmac")
        .marshal(cryptoFormat)
        .to("mock:encrypted")
        .unmarshal(cryptoFormat)
        .to("mock:unencrypted");

Spring XML  
<crypto id="hmac" algorithm="DES" keyRef="desKey" shouldAppendHMAC="true" />

By default, the HMAC is calculated using the HmacSHA1 mac algorithm,
though this can be easily changed by supplying a different algorithm
name. See here for how to check what algorithms are available through
the configured security providers

Java  
KeyGenerator generator = KeyGenerator.getInstance("DES");

    CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES", generator.generateKey());
    cryptoFormat.setShouldAppendHMAC(true);
    cryptoFormat.setMacAlgorithm("HmacMD5");
    
    from("direct:hmac-algorithm")
        .marshal(cryptoFormat)
        .to("mock:encrypted")
        .unmarshal(cryptoFormat)
        .to("mock:unencrypted");

Spring XML  
<crypto id="hmac-algorithm" algorithm="DES" keyRef="desKey" macAlgorithm="HmacMD5" shouldAppendHMAC="true" />

# Supplying Keys Dynamically

When using a Recipient list or similar EIP, the recipient of an exchange
can vary dynamically. Using the same key across all recipients may
neither be feasible nor desirable. It would be useful to be able to
specify keys dynamically on a per-exchange basis. The exchange could
then be dynamically enriched with the key of its target recipient before
being processed by the data format. To facilitate this, the DataFormat
allows for keys to be supplied dynamically via the message headers below

-   CryptoDataFormat.KEY "CamelCryptoKey"

Java  
CryptoDataFormat cryptoFormat = new CryptoDataFormat("DES", null);
/\*\*
\* Note: the header containing the key should be cleared after
\* marshaling to stop it from leaking by accident and
\* potentially being compromised. The processor version below is
\* arguably better as the key is left in the header when you use
\* the DSL leaks the fact that camel encryption was used.
\*/
from("direct:key-in-header-encrypt")
.marshal(cryptoFormat)
.removeHeader(CryptoDataFormat.KEY)
.to("mock:encrypted");

    from("direct:key-in-header-decrypt").unmarshal(cryptoFormat).process(new Processor() {
        public void process(Exchange exchange) throws Exception {
            exchange.getIn().getHeaders().remove(CryptoDataFormat.KEY);
            exchange.getMessage().copyFrom(exchange.getIn());
        }
    }).to("mock:unencrypted");

Spring XML  
<crypto id="nokey" algorithm="DES" />

# Dependencies

To use the [Crypto](#ROOT:crypto-component.adoc) dataformat in your
camel routes, you need to add the following dependency to your pom.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-crypto</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
