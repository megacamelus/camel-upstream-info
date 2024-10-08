# Xmlsecurity-verify

**Since Camel 2.12**

**Only producer is supported**

With this Apache Camel component, you can generate and validate XML
signatures as described in the W3C standard [XML Signature Syntax and
Processing](http://www.w3.org/TR/xmldsig-core/) or as described in the
successor [version 1.1](http://www.w3.org/TR/xmldsig-core1/). For XML
Encryption support, please refer to the XML Security [Data
Format](#manual::data-format.adoc).

You can find an introduction to XML signature
[here](http://www.oracle.com/technetwork/articles/javase/dig-signatures-141823.html).
The implementation of the component is based on [JSR
105](http://docs.oracle.com/javase/6/docs/technotes/guides/security/xmldsig/overview.html),
the Java API corresponding to the W3C standard and supports the Apache
Santuario and the JDK provider for JSR 105. The implementation will
first try to use the Apache Santuario provider; if it does not find the
Santuario provider, it will use the JDK provider. Further, the
implementation is DOM based.

We also provide support for **XAdES-BES/EPES** for the signer endpoint;
see subsection "XAdES-BES/EPES for the Signer Endpoint".

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-xmlsecurity</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI Format

The camel component consists of two endpoints which have the following
URI format:

    xmlsecurity-sign:name[?options]
    xmlsecurity-verify:name[?options]

-   With the signer endpoint, you can generate a XML signature for the
    body of the in-message, which can be either a XML document or a
    plain text. The enveloped, enveloping, or detached (as of 12.14) XML
    signature(s) will be set to the body of the out-message.

-   With the verifier endpoint, you can validate an enveloped or
    enveloping XML signature or even several detached XML signatures
    contained in the body of the in-message; if the validation is
    successful, then the original content is extracted from the XML
    signature and set to the body of the out-message.

-   The `name` part in the URI can be chosen by the user to distinguish
    between different signer/verifier endpoints within the camel
    context.

# XML Signature Wrapping Modes

XML Signature differs between enveloped, enveloping, and detached XML
signature. In the
[enveloped](http://www.w3.org/TR/xmldsig-core1/#def-SignatureEnveloped)
XML signature case, the XML Signature is wrapped by the signed XML
Document; which means that the XML signature element is a child element
of a parent element, which belongs to the signed XML Document. In the
[enveloping](http://www.w3.org/TR/xmldsig-core1/#def-SignatureEnveloping)
XML signature case, the XML Signature contains the signed content. All
other cases are called
[detached](http://www.w3.org/TR/xmldsig-core1/#def-SignatureDetached)
XML signatures.

In the **enveloped XML signature** case, the supported generated XML
signature has the following structure (Variables are surrounded by
`[]`).

    <[parent element]>
       ... <!-- Signature element is added as last child of the parent element-->
       <Signature Id="generated_unique_signature_id">
           <SignedInfo>
                 <Reference URI="">
                       <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
                       (<Transform>)* <!-- By default "http://www.w3.org/2006/12/xml-c14n11" is added to the transforms -->
                       <DigestMethod>
                       <DigestValue>
                 </Reference>
                 (<Reference URI="#[keyinfo_Id]">
                       <Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
                       <DigestMethod>
                       <DigestValue>
                 </Reference>)?
                 <!-- further references possible, see option 'properties' below -->
          </SignedInfo>
          <SignatureValue>
          (<KeyInfo Id="[keyinfo_id]">)?
          <!-- Object elements possible, see option 'properties' below -->
      </Signature>
    </[parent element]>

In the **enveloping XML signature** case, the supported generated XML
signature has the structure:

    <Signature Id="generated_unique_signature_id">
      <SignedInfo>
             <Reference URI="#generated_unique_object_id" type="[optional_type_value]">
                   (<Transform>)* <!-- By default "http://www.w3.org/2006/12/xml-c14n11" is added to the transforms -->
                   <DigestMethod>
                   <DigestValue>
             </Reference>
             (<Reference URI="#[keyinfo_id]">
                   <Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
                   <DigestMethod>
                   <DigestValue>
             </Reference>)?
              <!-- further references possible, see option 'properties' below  -->
      </SignedInfo>
      <SignatureValue>
      (<KeyInfo Id="[keyinfo_id]">)?
      <Object Id="generated_unique_object_id"/> <!-- The Object element contains the in-message body; the object ID can either be generated or set by the option parameter "contentObjectId" -->
      <!-- Further Object elements possible, see option 'properties' below -->
    </Signature>

**Detached XML signatures** with the following structure are supported
(see also sub-chapter XML Signatures as Siblings of Signed Elements):

    (<[signed element] Id="[id_value]">
    <!-- signed element must have an attribute of type ID -->
          ...
    
    </[signed element]>
    <other sibling/>*
    <!-- between the signed element and the corresponding signature element, there can be other siblings.
     Signature element is added as last sibling. -->
    <Signature Id="generated_unique_ID">
       <SignedInfo>
          <CanonicalizationMethod>
          <SignatureMethod>
          <Reference URI="#[id_value]" type="[optional_type_value]">
          <!-- reference URI contains the ID attribute value of the signed element -->
                (<Transform>)* <!-- By default "http://www.w3.org/2006/12/xml-c14n11" is added to the transforms -->
                <DigestMethod>
                <DigestValue>
          </Reference>
          (<Reference URI="#[generated_keyinfo_Id]">
                <Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
                <DigestMethod>
                <DigestValue>
          </Reference>)?
       </SignedInfo>
       <SignatureValue>
       (<KeyInfo Id="[generated_keyinfo_id]">)?
    </Signature>)+

# Basic Example

The following example shows the basic usage of the component.

    from("direct:enveloping").to("xmlsecurity-sign://enveloping?keyAccessor=#accessor",
                                 "xmlsecurity-verify://enveloping?keySelector=#selector",
                                 "mock:result")

In Spring XML:

    <from uri="direct:enveloping" />
        <to uri="xmlsecurity-sign://enveloping?keyAccessor=#accessor" />
        <to uri="xmlsecurity-verify://enveloping?keySelector=#selector" />
    <to uri="mock:result" />

For the signing process, a private key is necessary. You specify a key
accessor bean which provides this private key. For the validation, the
corresponding public key is necessary; you specify a key selector bean
which provides this public key.

The key accessor bean must implement the
[`KeyAccessor`](https://github.com/apache/camel/blob/main/components/camel-xmlsecurity/src/main/java/org/apache/camel/component/xmlsecurity/api/KeyAccessor.java)
interface. The package `org.apache.camel.component.xmlsecurity.api`
contains the default implementation class
[`DefaultKeyAccessor`](https://github.com/apache/camel/blob/main/components/camel-xmlsecurity/src/main/java/org/apache/camel/component/xmlsecurity/api/DefaultKeyAccessor.java)
which reads the private key from a Java keystore.

The key selector bean must implement the
[`javax.xml.crypto.KeySelector`](http://docs.oracle.com/javase/6/docs/api/javax/xml/crypto/KeySelector.html)
interface. The package `org.apache.camel.component.xmlsecurity.api`
contains the default implementation class
[`DefaultKeySelector`](https://github.com/apache/camel/blob/main/components/camel-xmlsecurity/src/main/java/org/apache/camel/component/xmlsecurity/api/DefaultKeySelector.java)
which reads the public key from a keystore.

In the example, the default signature algorithm
`\http://www.w3.org/2000/09/xmldsig#rsa-sha1` is used. You can set the
signature algorithm of your choice by the option `signatureAlgorithm`
(see below). The signer endpoint creates an *enveloping* XML signature.
If you want to create an *enveloped* XML signature, then you must
specify the parent element of the Signature element; see option
`parentLocalName` for more details.

For creating *detached* XML signatures, see sub-chapter "Detached XML
Signatures as Siblings of the Signed Elements".

# Detached XML Signatures as Siblings of the Signed Elements

You can create detached signatures where the signature is a sibling of
the signed element. The following example contains two detached
signatures. The first signature is for the element `C` and the second
signature is for element `A`. The signatures are *nested*; the second
signature is for the element `A` which also contains the first
signature.

**Example Detached XML Signatures**

    <?xml version="1.0" encoding="UTF-8" ?>
    <root>
        <A ID="IDforA">
            <B>
                <C ID="IDforC">
                    <D>dvalue</D>
                </C>
                <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                    Id="_6bf13099-0568-4d76-8649-faf5dcb313c0">
                    <ds:SignedInfo>
                        <ds:CanonicalizationMethod
                            Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
                        <ds:SignatureMethod
                            Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
                        <ds:Reference URI="#IDforC">
                            ...
                        </ds:Reference>
                    </ds:SignedInfo>
                    <ds:SignatureValue>aUDFmiG71</ds:SignatureValue>
                </ds:Signature>
            </B>
        </A>
        <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#"Id="_6b02fb8a-30df-42c6-ba25-76eba02c8214">
            <ds:SignedInfo>
                <ds:CanonicalizationMethod
                    Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
                <ds:SignatureMethod
                    Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
                <ds:Reference URI="#IDforA">
                    ...
                </ds:Reference>
            </ds:SignedInfo>
            <ds:SignatureValue>q3tvRoGgc8cMUqUSzP6C21zb7tt04riPnDuk=</ds:SignatureValue>
        </ds:Signature>
    <root>

The example shows that you can sign several elements and that for each
element a signature is created as sibling. The elements to be signed
must have an attribute of type ID. The ID type of the attribute must be
defined in the XML schema (see option `schemaResourceUri`). You specify
a list of XPATH expressions pointing to attributes of type ID (see
option `xpathsToIdAttributes`). These attributes determine the elements
to be signed. The elements are signed by the same key given by the
`keyAccessor` bean. Elements with higher (i.e. deeper) hierarchy level
are signed first. In the example, the element `C` is signed before the
element `A`.

**Java DSL Example**

    from("direct:detached")
      .to("xmlsecurity-sign://detached?keyAccessor=#keyAccessorBeant&xpathsToIdAttributes=#xpathsToIdAttributesBean&schemaResourceUri=Test.xsd")
      .to("xmlsecurity-verify://detached?keySelector=#keySelectorBean&schemaResourceUri=org/apache/camel/component/xmlsecurity/Test.xsd")
      .to("mock:result");

**Spring Example**

    <bean id="xpathsToIdAttributesBean" class="java.util.ArrayList">
          <constructor-arg type="java.util.Collection">
              <list>
                  <bean
                      class="org.apache.camel.component.xmlsecurity.api.XmlSignatureHelper"
                      factory-method="getXpathFilter">
                      <constructor-arg type="java.lang.String"
                          value="/ns:root/a/@ID" />
                      <constructor-arg>
                          <map key-type="java.lang.String" value-type="java.lang.String">
                              <entry key="ns" value="http://test" />
                          </map>
                      </constructor-arg>
                  </bean>
              </list>
          </constructor-arg>
      </bean>
    ...
     <from uri="direct:detached" />
          <to
              uri="xmlsecurity-sign://detached?keyAccessor=#keyAccessorBean&amp;xpathsToIdAttributes=#xpathsToIdAttributesBean&amp;schemaResourceUri=Test.xsd" />
          <to
              uri="xmlsecurity-verify://detached?keySelector=#keySelectorBean&amp;schemaResourceUri=Test.xsd" />
          <to uri="mock:result" />

# XAdES-BES/EPES for the Signer Endpoint

[XML Advanced Electronic Signatures
(XAdES)](http://www.etsi.org/deliver/etsi_ts/101900_101999/101903/01.04.02_60/ts_101903v010402p.pdf)
defines extensions to XML Signature. This standard was defined by the
[European Telecommunication Standards Institute](http://www.etsi.org/)
and allows you to create signatures which are compliant to the [European
Union Directive (1999/93/EC) on a Community framework for electronic
signatures](http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2000:013:0012:0020:EN:PDF).
XAdES defines different sets of signature properties which are called
signature forms. We support the signature forms **Basic Electronic
Signature** (XAdES-BES) and **Explicit Policy Based Electronic
Signature** (XAdES-EPES) for the Signer Endpoint. The forms
**Electronic** **\*Signature with Validation Data**\* XAdES-T and
XAdES-C are not supported.

We support the following properties of the XAdES-EPES form ("?" denotes
zero or one occurrence):

**Supported XAdES-EPES Properties**

    <QualifyingProperties Target>
        <SignedProperties>
            <SignedSignatureProperties>
                (SigningTime)?
                (SigningCertificate)?
                (SignaturePolicyIdentifier)
                (SignatureProductionPlace)?
                (SignerRole)?
            </SignedSignatureProperties>
            <SignedDataObjectProperties>
                (DataObjectFormat)?
                (CommitmentTypeIndication)?
            </SignedDataObjectProperties>
        </SignedProperties>
    </QualifyingProperties>

The properties of the XAdES-BES form are the same except that the
`SignaturePolicyIdentifier` property is not part of XAdES-BES.

You can configure the XAdES-BES/EPES properties via the bean
`org.apache.camel.component.xmlsecurity.api.XAdESSignatureProperties` or
`org.apache.camel.component.xmlsecurity.api.DefaultXAdESSignatureProperties. XAdESSignatureProperties`
does support all properties mentioned above except the
`SigningCertificate` property. To get the `SigningCertificate` property,
you must overwrite either the method
`XAdESSignatureProperties.getSigningCertificate()` or
`XAdESSignatureProperties.getSigningCertificateChain()`. The class
`DefaultXAdESSignatureProperties` overwrites the method
`getSigningCertificate()` and allows you to specify the signing
certificate via a keystore and alias. The following example shows all
parameters you can specify. If you do not need certain parameters, you
can just omit them.

**XAdES-BES/EPES Example in Java DSL**

     Keystore keystore = ... // load a keystore
    DefaultKeyAccessor accessor = new DefaultKeyAccessor();
    accessor.setKeyStore(keystore);
    accessor.setPassword("password");
    accessor.setAlias("cert_alias"); // signer key alias
    
    DefaultXAdESSignatureProperties props = new DefaultXAdESSignatureProperties();
    props.setNamespace("http://uri.etsi.org/01903/v1.3.2#"); // sets the namespace for the XAdES elements; the namspace is related to the XAdES version, default value is "http://uri.etsi.org/01903/v1.3.2#", other possible values are "http://uri.etsi.org/01903/v1.1.1#" and "http://uri.etsi.org/01903/v1.2.2#"
    props.setPrefix("etsi"); // sets the prefix for the XAdES elements, default value is "etsi"
    
    // signing certificate
    props.setKeystore(keystore));
    props.setAlias("cert_alias"); // specify the alias of the signing certificate in the keystore = signer key alias
    props.setDigestAlgorithmForSigningCertificate(DigestMethod.SHA256); // possible values for the algorithm are "http://www.w3.org/2000/09/xmldsig#sha1", "http://www.w3.org/2001/04/xmlenc#sha256", "http://www.w3.org/2001/04/xmldsig-more#sha384", "http://www.w3.org/2001/04/xmlenc#sha512", default value is "http://www.w3.org/2001/04/xmlenc#sha256"
    props.setSigningCertificateURIs(Collections.singletonList("http://certuri"));
    
    // signing time
    props.setAddSigningTime(true);
    
    // policy
    props.setSignaturePolicy(XAdESSignatureProperties.SIG_POLICY_EXPLICIT_ID);
    // also the values XAdESSignatureProperties.SIG_POLICY_NONE ("None"), and XAdESSignatureProperties.SIG_POLICY_IMPLIED ("Implied")are possible, default value is XAdESSignatureProperties.SIG_POLICY_EXPLICIT_ID ("ExplicitId")
    // For "None" and "Implied" you must not specify any further policy parameters
    props.setSigPolicyId("urn:oid:1.2.840.113549.1.9.16.6.1");
    props.setSigPolicyIdQualifier("OIDAsURN"); //allowed values are empty string, "OIDAsURI", "OIDAsURN"; default value is empty string
    props.setSigPolicyIdDescription("invoice version 3.1");
    props.setSignaturePolicyDigestAlgorithm(DigestMethod.SHA256);// possible values for the algorithm are "http://www.w3.org/2000/09/xmldsig#sha1", http://www.w3.org/2001/04/xmlenc#sha256", "http://www.w3.org/2001/04/xmldsig-more#sha384", "http://www.w3.org/2001/04/xmlenc#sha512", default value is http://www.w3.org/2001/04/xmlenc#sha256"
    props.setSignaturePolicyDigestValue("Ohixl6upD6av8N7pEvDABhEL6hM=");
    // you can add  qualifiers for the signature policy either by specifying text or an XML fragment with the root element "SigPolicyQualifier"
    props.setSigPolicyQualifiers(Arrays
        .asList(new String[] {
            "<SigPolicyQualifier xmlns=\"http://uri.etsi.org/01903/v1.3.2#\"><SPURI>http://test.com/sig.policy.pdf</SPURI><SPUserNotice><ExplicitText>display text</ExplicitText>"
                + "</SPUserNotice></SigPolicyQualifier>", "category B" }));
    props.setSigPolicyIdDocumentationReferences(Arrays.asList(new String[] {"http://test.com/policy.doc.ref1.txt",
        "http://test.com/policy.doc.ref2.txt" }));
    
    // production place
    props.setSignatureProductionPlaceCity("Munich");
    props.setSignatureProductionPlaceCountryName("Germany");
    props.setSignatureProductionPlacePostalCode("80331");
    props.setSignatureProductionPlaceStateOrProvince("Bavaria");
    
    //role
    // you can add claimed roles either by specifying text or an XML fragment with the root element "ClaimedRole"
    props.setSignerClaimedRoles(Arrays.asList(new String[] {"test",
        "<a:ClaimedRole xmlns:a=\"http://uri.etsi.org/01903/v1.3.2#\"><TestRole>TestRole</TestRole></a:ClaimedRole>" }));
    props.setSignerCertifiedRoles(Collections.singletonList(new XAdESEncapsulatedPKIData("Ahixl6upD6av8N7pEvDABhEL6hM=",
        "http://uri.etsi.org/01903/v1.2.2#DER", "IdCertifiedRole")));
    
    // data object format
    props.setDataObjectFormatDescription("invoice");
    props.setDataObjectFormatMimeType("text/xml");
    props.setDataObjectFormatIdentifier("urn:oid:1.2.840.113549.1.9.16.6.2");
    props.setDataObjectFormatIdentifierQualifier("OIDAsURN"); //allowed values are empty string, "OIDAsURI", "OIDAsURN"; default value is empty string
    props.setDataObjectFormatIdentifierDescription("identifier desc");
    props.setDataObjectFormatIdentifierDocumentationReferences(Arrays.asList(new String[] {
        "http://test.com/dataobject.format.doc.ref1.txt", "http://test.com/dataobject.format.doc.ref2.txt" }));
    
    //commitment
    props.setCommitmentTypeId("urn:oid:1.2.840.113549.1.9.16.6.4");
    props.setCommitmentTypeIdQualifier("OIDAsURN"); //allowed values are empty string, "OIDAsURI", "OIDAsURN"; default value is empty string
    props.setCommitmentTypeIdDescription("description for commitment type ID");
    props.setCommitmentTypeIdDocumentationReferences(Arrays.asList(new String[] {"http://test.com/commitment.ref1.txt",
        "http://test.com/commitment.ref2.txt" }));
    // you can specify a commitment type qualifier either by simple text or an XML fragment with root element "CommitmentTypeQualifier"
    props.setCommitmentTypeQualifiers(Arrays.asList(new String[] {"commitment qualifier",
        "<c:CommitmentTypeQualifier xmlns:c=\"http://uri.etsi.org/01903/v1.3.2#\"><C>c</C></c:CommitmentTypeQualifier>" }));
    
    beanRegistry.bind("xmlSignatureProperties",props);
    beanRegistry.bind("keyAccessorDefault",keyAccessor);
    
    // you must reference the properties bean in the "xmlsecurity" URI
    from("direct:xades").to("xmlsecurity-sign://xades?keyAccessor=#keyAccessorDefault&properties=#xmlSignatureProperties")
                 .to("mock:result");

**XAdES-BES/EPES Example in Spring XML**

    ...
    <from uri="direct:xades" />
        <to
            uri="xmlsecurity-sign://xades?keyAccessor=#accessorRsa&amp;properties=#xadesProperties" />
        <to uri="mock:result" />
    ...
    <bean id="xadesProperties"
        class="org.apache.camel.component.xmlsecurity.api.XAdESSignatureProperties">
        <!-- For more properties see the previous Java DSL example.
             If you want to have a signing certificate then use the bean class DefaultXAdESSignatureProperties (see the previous Java DSL example). -->
        <property name="signaturePolicy" value="ExplicitId" />
        <property name="sigPolicyId" value="http://www.test.com/policy.pdf" />
        <property name="sigPolicyIdDescription" value="factura" />
        <property name="signaturePolicyDigestAlgorithm" value="http://www.w3.org/2000/09/xmldsig#sha1" />
        <property name="signaturePolicyDigestValue" value="Ohixl6upD6av8N7pEvDABhEL1hM=" />
        <property name="signerClaimedRoles" ref="signerClaimedRoles_XMLSigner" />
        <property name="dataObjectFormatDescription" value="Factura electrónica" />
        <property name="dataObjectFormatMimeType" value="text/xml" />
    </bean>
    <bean class="java.util.ArrayList" id="signerClaimedRoles_XMLSigner">
        <constructor-arg>
            <list>
                <value>Emisor</value>
                <value>&lt;ClaimedRole
                    xmlns=&quot;http://uri.etsi.org/01903/v1.3.2#&quot;&gt;&lt;test
                    xmlns=&quot;http://test.com/&quot;&gt;test&lt;/test&gt;&lt;/ClaimedRole&gt;</value>
            </list>
        </constructor-arg>
    </bean>

## Limitations with regard to XAdES version 1.4.2

-   No support for signature form XAdES-T and XAdES-C

-   Only signer part implemented. Verifier part currently not available.

-   No support for the `QualifyingPropertiesReference` element (see
    section 6.3.2 of spec).

-   No support for the `Transforms` element contained in the
    `SignaturePolicyId` element contained in the
    `SignaturePolicyIdentifier element`

-   No support of the `CounterSignature` element → no support for the
    `UnsignedProperties` element

-   At most one `DataObjectFormat` element. More than one
    `DataObjectFormat` element makes no sense because we have only one
    data object which is signed (this is the incoming message body to
    the XML signer endpoint).

-   At most one `CommitmentTypeIndication` element. More than one
    `CommitmentTypeIndication` element makes no sense because we have
    only one data object which is signed (this is the incoming message
    body to the XML signer endpoint).

-   A `CommitmentTypeIndication` element contains always the
    `AllSignedDataObjects` element. The `ObjectReference` element within
    `CommitmentTypeIndication` element is not supported.

-   The `AllDataObjectsTimeStamp` element is not supported

-   The `IndividualDataObjectsTimeStamp` element is not supported

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|baseUri|You can set a base URI which is used in the URI dereferencing. Relative URIs are then concatenated with the base URI.||string|
|clearHeaders|Determines if the XML signature specific headers be cleared after signing and verification. Defaults to true.|true|boolean|
|cryptoContextProperties|Sets the crypto context properties. See {link XMLCryptoContext#setProperty(String, Object)}. Possible properties are defined in XMLSignContext an XMLValidateContext (see Supported Properties). The following properties are set by default to the value Boolean#TRUE for the XML validation. If you want to switch these features off you must set the property value to Boolean#FALSE. org.jcp.xml.dsig.validateManifests javax.xml.crypto.dsig.cacheReference||object|
|disallowDoctypeDecl|Disallows that the incoming XML document contains DTD DOCTYPE declaration. The default value is Boolean#TRUE.|true|boolean|
|keySelector|Provides the key for validating the XML signature.||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|omitXmlDeclaration|Indicator whether the XML declaration in the outgoing message body should be omitted. Default value is false. Can be overwritten by the header XmlSignatureConstants#HEADER\_OMIT\_XML\_DECLARATION.|false|boolean|
|outputNodeSearch|Sets the output node search value for determining the node from the XML signature document which shall be set to the output message body. The class of the value depends on the type of the output node search. The output node search is forwarded to XmlSignature2Message.||object|
|outputNodeSearchType|Determines the search type for determining the output node which is serialized into the output message bodyF. See setOutputNodeSearch(Object). The supported default search types you can find in DefaultXmlSignature2Message.|Default|string|
|outputXmlEncoding|The character encoding of the resulting signed XML document. If null then the encoding of the original XML document is used.||string|
|removeSignatureElements|Indicator whether the XML signature elements (elements with local name Signature and namesapce http://www.w3.org/2000/09/xmldsig#) shall be removed from the document set to the output message. Normally, this is only necessary, if the XML signature is enveloped. The default value is Boolean#FALSE. This parameter is forwarded to XmlSignature2Message. This indicator has no effect if the output node search is of type DefaultXmlSignature2Message#OUTPUT\_NODE\_SEARCH\_TYPE\_DEFAULT.F|false|boolean|
|schemaResourceUri|Classpath to the XML Schema. Must be specified in the detached XML Signature case for determining the ID attributes, might be set in the enveloped and enveloping case. If set, then the XML document is validated with the specified XML schema. The schema resource URI can be overwritten by the header XmlSignatureConstants#HEADER\_SCHEMA\_RESOURCE\_URI.||string|
|secureValidation|Enables secure validation. If true then secure validation is enabled.|true|boolean|
|validationFailedHandler|Handles the different validation failed situations. The default implementation throws specific exceptions for the different situations (All exceptions have the package name org.apache.camel.component.xmlsecurity.api and are a sub-class of XmlSignatureInvalidException. If the signature value validation fails, a XmlSignatureInvalidValueException is thrown. If a reference validation fails, a XmlSignatureInvalidContentHashException is thrown. For more detailed information, see the JavaDoc.||object|
|xmlSignature2Message|Bean which maps the XML signature to the output-message after the validation. How this mapping should be done can be configured by the options outputNodeSearchType, outputNodeSearch, and removeSignatureElements. The default implementation offers three possibilities which are related to the three output node search types Default, ElementName, and XPath. The default implementation determines a node which is then serialized and set to the body of the output message If the search type is ElementName then the output node (which must be in this case an element) is determined by the local name and namespace defined in the search value (see option outputNodeSearch). If the search type is XPath then the output node is determined by the XPath specified in the search value (in this case the output node can be of type Element, TextNode or Document). If the output node search type is Default then the following rules apply: In the enveloped XML signature case (there is a reference with URI= and transform http://www.w3.org/2000/09/xmldsig#enveloped-signature), the incoming XML document without the Signature element is set to the output message body. In the non-enveloped XML signature case, the message body is determined from a referenced Object; this is explained in more detail in chapter Output Node Determination in Enveloping XML Signature Case.||object|
|xmlSignatureChecker|This interface allows the application to check the XML signature before the validation is executed. This step is recommended in http://www.w3.org/TR/xmldsig-bestpractices/#check-what-is-signed||object|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|uriDereferencer|If you want to restrict the remote access via reference URIs, you can set an own dereferencer. Optional parameter. If not set the provider default dereferencer is used which can resolve URI fragments, HTTP, file and XPpointer URIs. Attention: The implementation is provider dependent!||object|
|verifierConfiguration|To use a shared XmlVerifierConfiguration configuration to use as base for configuring endpoints.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|name|The name part in the URI can be chosen by the user to distinguish between different verify endpoints within the camel context.||string|
|baseUri|You can set a base URI which is used in the URI dereferencing. Relative URIs are then concatenated with the base URI.||string|
|clearHeaders|Determines if the XML signature specific headers be cleared after signing and verification. Defaults to true.|true|boolean|
|cryptoContextProperties|Sets the crypto context properties. See {link XMLCryptoContext#setProperty(String, Object)}. Possible properties are defined in XMLSignContext an XMLValidateContext (see Supported Properties). The following properties are set by default to the value Boolean#TRUE for the XML validation. If you want to switch these features off you must set the property value to Boolean#FALSE. org.jcp.xml.dsig.validateManifests javax.xml.crypto.dsig.cacheReference||object|
|disallowDoctypeDecl|Disallows that the incoming XML document contains DTD DOCTYPE declaration. The default value is Boolean#TRUE.|true|boolean|
|keySelector|Provides the key for validating the XML signature.||object|
|omitXmlDeclaration|Indicator whether the XML declaration in the outgoing message body should be omitted. Default value is false. Can be overwritten by the header XmlSignatureConstants#HEADER\_OMIT\_XML\_DECLARATION.|false|boolean|
|outputNodeSearch|Sets the output node search value for determining the node from the XML signature document which shall be set to the output message body. The class of the value depends on the type of the output node search. The output node search is forwarded to XmlSignature2Message.||object|
|outputNodeSearchType|Determines the search type for determining the output node which is serialized into the output message bodyF. See setOutputNodeSearch(Object). The supported default search types you can find in DefaultXmlSignature2Message.|Default|string|
|outputXmlEncoding|The character encoding of the resulting signed XML document. If null then the encoding of the original XML document is used.||string|
|removeSignatureElements|Indicator whether the XML signature elements (elements with local name Signature and namesapce http://www.w3.org/2000/09/xmldsig#) shall be removed from the document set to the output message. Normally, this is only necessary, if the XML signature is enveloped. The default value is Boolean#FALSE. This parameter is forwarded to XmlSignature2Message. This indicator has no effect if the output node search is of type DefaultXmlSignature2Message#OUTPUT\_NODE\_SEARCH\_TYPE\_DEFAULT.F|false|boolean|
|schemaResourceUri|Classpath to the XML Schema. Must be specified in the detached XML Signature case for determining the ID attributes, might be set in the enveloped and enveloping case. If set, then the XML document is validated with the specified XML schema. The schema resource URI can be overwritten by the header XmlSignatureConstants#HEADER\_SCHEMA\_RESOURCE\_URI.||string|
|secureValidation|Enables secure validation. If true then secure validation is enabled.|true|boolean|
|validationFailedHandler|Handles the different validation failed situations. The default implementation throws specific exceptions for the different situations (All exceptions have the package name org.apache.camel.component.xmlsecurity.api and are a sub-class of XmlSignatureInvalidException. If the signature value validation fails, a XmlSignatureInvalidValueException is thrown. If a reference validation fails, a XmlSignatureInvalidContentHashException is thrown. For more detailed information, see the JavaDoc.||object|
|xmlSignature2Message|Bean which maps the XML signature to the output-message after the validation. How this mapping should be done can be configured by the options outputNodeSearchType, outputNodeSearch, and removeSignatureElements. The default implementation offers three possibilities which are related to the three output node search types Default, ElementName, and XPath. The default implementation determines a node which is then serialized and set to the body of the output message If the search type is ElementName then the output node (which must be in this case an element) is determined by the local name and namespace defined in the search value (see option outputNodeSearch). If the search type is XPath then the output node is determined by the XPath specified in the search value (in this case the output node can be of type Element, TextNode or Document). If the output node search type is Default then the following rules apply: In the enveloped XML signature case (there is a reference with URI= and transform http://www.w3.org/2000/09/xmldsig#enveloped-signature), the incoming XML document without the Signature element is set to the output message body. In the non-enveloped XML signature case, the message body is determined from a referenced Object; this is explained in more detail in chapter Output Node Determination in Enveloping XML Signature Case.||object|
|xmlSignatureChecker|This interface allows the application to check the XML signature before the validation is executed. This step is recommended in http://www.w3.org/TR/xmldsig-bestpractices/#check-what-is-signed||object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|uriDereferencer|If you want to restrict the remote access via reference URIs, you can set an own dereferencer. Optional parameter. If not set the provider default dereferencer is used which can resolve URI fragments, HTTP, file and XPpointer URIs. Attention: The implementation is provider dependent!||object|
