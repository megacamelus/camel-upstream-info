# XmlSecurity-dataformat.md

**Since Camel 2.0**

The XMLSecurity Data Format facilitates encryption and decryption of XML
payloads at the Document, Element, and Element Content levels (including
simultaneous multi-node encryption/decryption using XPath). To sign
messages using the XML Signature specification, please see the Camel XML
Security component.

The encryption capability is based on formats supported using the Apache
XML Security (Santuario) project. Symmetric encryption/decryption is
currently supported using Triple-DES and AES (128, 192, and 256)
encryption formats. Additional formats can be easily added later as
needed. This capability allows Camel users to encrypt/decrypt payloads
while being dispatched or received along a route.

**Since Camel 2.9**  
The XMLSecurity Data Format supports asymmetric key encryption. In this
encryption model, a symmetric key is generated and used to perform XML
content encryption or decryption. This "content encryption key" is then
itself encrypted using an asymmetric encryption algorithm that leverages
the recipient’s public key as the "key encryption key". Use of an
asymmetric key encryption algorithm ensures that only the holder of the
recipient’s private key can access the generated symmetric encryption
key. Thus, only the private key holder can decode the message. The
XMLSecurity Data Format handles all the logic required to encrypt and
decrypt the message content and encryption key(s) using asymmetric key
encryption.

The XMLSecurity Data Format also has improved support for namespaces
when processing the XPath queries that select content for encryption. A
namespace definition mapping can be included as part of the data format
configuration. This enables true namespace matching, even if the prefix
values in the XPath query and the target XML document are not equivalent
strings.

# XMLSecurity Options

## Key Cipher Algorithm

The default Key Cipher Algorithm is now `XMLCipher.RSA_OAEP` instead of
`XMLCipher.RSA_v1dot5`. Usage of `XMLCipher.RSA_v1dot5` is discouraged
due to various attacks. Requests that use RSA v1.5 as the key cipher
algorithm will be rejected unless it has been explicitly configured as
the key cipher algorithm.

# Marshal

To encrypt the payload, the `marshal` processor needs to be applied on
the route followed by the **`xmlSecurity()`** tag.

# Unmarshal

To decrypt the payload, the `unmarshal` processor needs to be applied on
the route followed by the **`xmlSecurity()`** tag.

# Examples

Given below are several examples of how marshalling could be performed
at the Document, Element, and Content levels.

## Full Payload encryption/decryption

    KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
    keyGenerator.init(256);
    Key key = keyGenerator.generateKey();
    
    from("direct:start")
        .marshal().xmlSecurity(key.getEncoded())
        .unmarshal().xmlSecurity(key.getEncoded()
        .to("direct:end");

## Partial Payload Content Only encryption/decryption with choice of passPhrase(password)

    String tagXPATH = "//cheesesites/italy/cheese";
    boolean secureTagContent = true;
    ...
    String passPhrase = "Just another 24 Byte key";
    from("direct:start")
        .marshal().xmlSecurity(tagXPATH, secureTagContent, passPhrase)
        .unmarshal().xmlSecurity(tagXPATH, secureTagContent, passPhrase)
        .to("direct:end");

## Partial Payload Content Only encryption/decryption with passPhrase(password) and Algorithm

    import org.apache.xml.security.encryption.XMLCipher;
    ....
    String tagXPATH = "//cheesesites/italy/cheese";
    boolean secureTagContent = true;
    String passPhrase = "Just another 24 Byte key";
    String algorithm= XMLCipher.TRIPLEDES;
    from("direct:start")
        .marshal().xmlSecurity(tagXPATH, secureTagContent, passPhrase, algorithm)
        .unmarshal().xmlSecurity(tagXPATH, secureTagContent, passPhrase, algorithm)
        .to("direct:end");

## Partial Payload Content with Namespace support

Java DSL

    final Map<String, String> namespaces = new HashMap<String, String>();
    namespaces.put("cust", "http://cheese.xmlsecurity.camel.apache.org/");
    
    final KeyStoreParameters tsParameters = new KeyStoreParameters();
    tsParameters.setPassword("password");
    tsParameters.setResource("sender.truststore");
    
    context.addRoutes(new RouteBuilder() {
        public void configure() {
            from("direct:start")
               .marshal().xmlSecurity("//cust:cheesesites/italy", namespaces, true, "recipient",
                                    testCypherAlgorithm, XMLCipher.RSA_v1dot5, tsParameters)
               .to("mock:encrypted");
        }
    }

Spring XML

A namespace prefix defined as part of the `camelContext` definition can
be re-used in context within the data format `secureTag` attribute of
the `xmlSecurity` element.

    <camelContext id="springXmlSecurityDataFormatTestCamelContext"
                  xmlns="http://camel.apache.org/schema/spring"
                  xmlns:cheese="http://cheese.xmlsecurity.camel.apache.org/">
        <route>
            <from uri="direct://start"/>
                <marshal>
                    <xmlSecurity secureTag="//cheese:cheesesites/italy"
                               secureTagContents="true"/>
                </marshal>
                ...

## Asymmetric Key Encryption

Spring XML Sender

    <!--  trust store configuration -->
    <camel:keyStoreParameters id="trustStoreParams" resource="./sender.truststore" password="password"/>
    
    <camelContext id="springXmlSecurityDataFormatTestCamelContext"
                  xmlns="http://camel.apache.org/schema/spring"
                  xmlns:cheese="http://cheese.xmlsecurity.camel.apache.org/">
        <route>
            <from uri="direct://start"/>
                <marshal>
                    <xmlSecurity secureTag="//cheese:cheesesites/italy"
                               secureTagContents="true"
                               xmlCipherAlgorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc"
                               keyCipherAlgorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"
                               recipientKeyAlias="recipient"
                               keyOrTrustStoreParametersRef="trustStoreParams"/>
                </marshal>
                ...

Spring XML Recipient

    <!--  key store configuration -->
    <camel:keyStoreParameters id="keyStoreParams" resource="./recipient.keystore" password="password" />
    
    <camelContext id="springXmlSecurityDataFormatTestCamelContext"
                  xmlns="http://camel.apache.org/schema/spring"
                  xmlns:cheese="http://cheese.xmlsecurity.camel.apache.org/">
        <route>
            <from uri="direct://encrypted"/>
                <unmarshal>
                    <xmlSecurity secureTag="//cheese:cheesesites/italy"
                               secureTagContents="true"
                               xmlCipherAlgorithm="http://www.w3.org/2001/04/xmlenc#aes128-cbc"
                               keyCipherAlgorithm="http://www.w3.org/2001/04/xmlenc#rsa-1_5"
                               recipientKeyAlias="recipient"
                               keyOrTrustStoreParametersRef="keyStoreParams"
                               keyPassword="privateKeyPassword" />
                </unmarshal>
                ...

# Dependencies

This data format is provided within the **camel-xmlsecurity** component.
