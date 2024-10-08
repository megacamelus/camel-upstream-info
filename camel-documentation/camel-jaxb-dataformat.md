# Jaxb-dataformat.md

**Since Camel 1.0**

JAXB is a Data Format which uses the JAXB XML marshalling standard to
unmarshal an XML payload into Java objects or to marshal Java objects
into an XML payload.

# Options

# Usage

## Using the Java DSL

The following example uses a named DataFormat of `jaxb` which is
configured with a Java package name to initialize the
[JAXBContext](https://jakarta.ee/specifications/xml-binding/2.3/apidocs/javax/xml/bind/jaxbcontext).

    DataFormat jaxb = new JaxbDataFormat("com.acme.model");
    
    from("activemq:My.Queue").
      unmarshal(jaxb).
      to("mqseries:Another.Queue");

You can, if you prefer, use a named reference to a data format which can
then be defined in your Registry such as via your Spring XML file. e.g.

    from("activemq:My.Queue").
      unmarshal("myJaxbDataType").
      to("mqseries:Another.Queue");

## Using Spring XML

The following example shows how to configure the `JaxbDataFormat` and
use it in multiple routes.

    <beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
        http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
    
      <bean id="myJaxb" class="org.apache.camel.converter.jaxb.JaxbDataFormat">
        <property name="contextPath" value="org.apache.camel.example"/>
      </bean>
    
      <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
          <from uri="direct:start"/>
          <marshal><custom ref="myJaxb"/></marshal>
          <to uri="direct:marshalled"/>
        </route>
        <route>
          <from uri="direct:marshalled"/>
          <unmarshal><custom ref="myJaxb"/></unmarshal>
          <to uri="mock:result"/>
        </route>
      </camelContext>
    
    </beans>

## Multiple context paths

It is possible to use this data format with more than one context path.
You can specify multiple context paths using `:` as a separator, for
example `com.mycompany:com.mycompany2`.

## Partial marshalling / unmarshalling

JAXB 2 supports marshalling and unmarshalling XML tree fragments. By
default, JAXB looks for the `@XmlRootElement` annotation on a given
class to operate on the whole XML tree. This is useful, but not always.
Sometimes the generated code does not have the `@XmlRootElement`
annotation, and sometimes you need to unmarshall only part of the tree.

In that case, you can use partial unmarshalling. To enable this
behavior, you need set property `partClass` on the `JaxbDataFormat`.
Camel will pass this class to the JAXB unmarshaller. If
`JaxbConstants.JAXB_PART_CLASS` is set as one of the exchange headers,
its value is used to override the `partClass` property on the
`JaxbDataFormat`.

For marshalling you have to add the `partNamespace` attribute with the
`QName` of the destination namespace.

If `JaxbConstants.JAXB_PART_NAMESPACE` is set as one of the exchange
headers, its value is used to override the `partNamespace` property on
the `JaxbDataFormat`.

While setting `partNamespace` through
`JaxbConstants.JAXB_PART_NAMESPACE`, please note that you need to
specify its value in the format `{namespaceUri\}localPart`, as per the
example below.

    .setHeader(JaxbConstants.JAXB_PART_NAMESPACE, constant("{http://www.camel.apache.org/jaxb/example/address/1}address"));

## Fragment

`JaxbDataFormat` has a property named `fragment` which can set the
`Marshaller.JAXB_FRAGMENT` property on the JAXB Marshaller. If you don’t
want the JAXB Marshaller to generate the XML declaration, you can set
this option to be `true`. The default value of this property is `false`.

## Ignoring Non-XML Characters

`JaxbDataFormat` supports ignoring [Non-XML
Characters](https://www.w3.org/TR/xml/#NT-Char), you need to set the
`filterNonXmlChars` property to `true`. The `JaxbDataFormat` will
replace any non-XML character with a space character (`" "`) during
message marshalling or unmarshalling. You can also set the Exchange
property `Exchange.FILTER_NON_XML_CHARS`.

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 10%" />
<col style="width: 59%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;"></th>
<th style="text-align: left;">JDK 1.5</th>
<th style="text-align: left;">JDK 1.6+</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>Filtering in use</p></td>
<td style="text-align: left;"><p>StAX API and implementation</p></td>
<td style="text-align: left;"><p>No</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>Filtering not in use</p></td>
<td style="text-align: left;"><p>StAX API only</p></td>
<td style="text-align: left;"><p>No</p></td>
</tr>
</tbody>
</table>

This feature has been tested with Woodstox 3.2.9 and Sun JDK 1.6 StAX
implementation.

`JaxbDataFormat` now allows you to customize the `XMLStreamWriter` used
to marshal the stream to XML. Using this configuration, you can add your
own stream writer to completely remove, escape, or replace non-XML
characters.

    JaxbDataFormat customWriterFormat = new JaxbDataFormat("org.apache.camel.foo.bar");
    customWriterFormat.setXmlStreamWriterWrapper(new TestXmlStreamWriter());

The following example shows using the Spring DSL and also enabling
Camel’s non-XML filtering:

    <bean id="testXmlStreamWriterWrapper" class="org.apache.camel.jaxb.TestXmlStreamWriter"/>
    <jaxb filterNonXmlChars="true" contextPath="org.apache.camel.foo.bar" xmlStreamWriterWrapper="#testXmlStreamWriterWrapper" />

## Working with the `ObjectFactory`

If you use XJC to create the java class from the schema, you will get an
`ObjectFactory` for your JAXB context. Since the `ObjectFactory` uses
[JAXBElement](https://jakarta.ee/specifications/xml-binding/2.3/apidocs/javax/xml/bind/jaxbelement)
to hold the reference of the schema and element instance value,
`JaxbDataformat` will ignore the `JAXBElement` by default, and you will
get the element instance value instead of the `JAXBElement` object from
the unmarshaled message body.

If you want to get the `JAXBElement` object form the unmarshaled message
body, you need to set the `JaxbDataFormat` `ignoreJAXBElement` property
to be `false`.

## Setting the encoding

You can set the `encoding` option on the `JaxbDataFormat` to configure
the `Marshaller.JAXB_ENCODING` encoding property on the JAXB Marshaller.

You can set up which encoding to use when you declare the
`JaxbDataFormat`. You can also provide the encoding in the Exchange
property `Exchange.CHARSET_NAME`. This property will override the
encoding set on the `JaxbDataFormat`.

## Controlling namespace prefix mapping

When marshalling using [JAXB](#jaxb-dataformat.adoc) or
[SOAP](#jaxb-dataformat.adoc) then the JAXB implementation will
automatically assign namespace prefixes, such as `ns2`, `ns3`, `ns4`
etc. To control this mapping, Camel allows you to refer to a map which
contains the desired mapping.

For example, in Spring XML we can define a `Map` with the mapping. In
the mapping file below, we map SOAP to use soap as a prefix. While our
custom namespace `http://www.mycompany.com/foo/2` is not using any
prefix.

     <util:map id="myMap">
        <entry key="http://www.w3.org/2003/05/soap-envelope" value="soap"/>
        <!-- we don't want any prefix for our namespace -->
        <entry key="http://www.mycompany.com/foo/2" value=""/>
     </util:map>

To use this in JAXB or SOAP data formats, you refer to this map, using
the `namespacePrefixRef` attribute as shown below. Then Camel will look
up in the Registry a `java.util.Map` with the id `myMap`, which was what
we defined above.

     <marshal>
        <soap version="1.2" contextPath="com.mycompany.foo" namespacePrefixRef="myMap"/>
     </marshal>

## Schema validation

The `JaxbDataFormat` supports validation by marshalling and
unmarshalling from / to XML. You can use the prefix `classpath:`,
`file:` or `http:` to specify how the resource should be resolved. You
can separate multiple schema files by using the `,` character.

if the XSD schema files import/access other files, then you need to
enable file protocol (or others to allow access)

Using the Java DSL, you can configure it in the following way:

    JaxbDataFormat jaxbDataFormat = new JaxbDataFormat();
    jaxbDataFormat.setContextPath(Person.class.getPackage().getName());
    jaxbDataFormat.setSchema("classpath:person.xsd,classpath:address.xsd");
    jaxbDataFormat.setAccessExternalSchemaProtocols("file");

You can do the same using the XML DSL:

    <marshal>
        <jaxb id="jaxb" schema="classpath:person.xsd,classpath:address.xsd"
              accessExternalSchemaProtocols="file"/>
    </marshal>

## Schema Location

The `JaxbDataFormat` supports to specify the `SchemaLocation` when
marshalling the XML.

Using the Java DSL, you can configure it in the following way:

    JaxbDataFormat jaxbDataFormat = new JaxbDataFormat();
    jaxbDataFormat.setContextPath(Person.class.getPackage().getName());
    jaxbDataFormat.setSchemaLocation("schema/person.xsd");

You can do the same using the XML DSL:

    <marshal>
        <jaxb id="jaxb" schemaLocation="schema/person.xsd"/>
    </marshal>

## Marshal data that is already XML

The JAXB marshaller requires that the message body is JAXB compatible,
e.g., it is a `JAXBElement`, a java instance that has JAXB annotations,
or extends `JAXBElement`. There can be situations where the message body
is already in XML, e.g., from a `String` type.

`JaxbDataFormat` has an option named `mustBeJAXBElement` which you can
set to `false` to relax this check and have the JAXB marshaller only
attempt marshalling on `JAXBElement`
(`javax.xml.bind.JAXBIntrospector#isElement` returns `true`). In those
situations, the marshaller will fall back to marshal the message body
as-is.

# Dependencies

To use JAXB in your Camel routes, you need to add a dependency on
**camel-jaxb**, which implements this data format.

If you use Maven, you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-jaxb</artifactId>
      <version>x.x.x</version>
    </dependency>
