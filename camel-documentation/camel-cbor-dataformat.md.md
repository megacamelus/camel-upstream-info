# Cbor-dataformat.md

**Since Camel 3.0**

CBOR is a Data Format that uses the [Jackson
library](https://github.com/FasterXML/jackson/) with the [CBOR
extension](https://github.com/FasterXML/jackson-dataformats-binary/tree/master/cbor)
to unmarshal a CBOR payload into Java objects or to marshal Java objects
into a CBOR payload.

    from("activemq:My.Queue")
        .unmarshal().cbor()
        .to("mqseries:Another.Queue");

# CBOR Options

## Using CBOR in Spring DSL

When using Data Format in Spring DSL, you need to declare the data
formats first. This is done in the **DataFormats** XML tag.

    <dataFormats>
        <!-- here we define a CBOR data format with the id test, and that it should use the TestPojo as the class type when
        doing unmarshal. -->
        <cbor id="test" unmarshalType="org.apache.camel.component.cbor.TestPojo"/>
    </dataFormats>

And then you can refer to this id in the route:

    <route>
        <from uri="direct:back"/>
        <unmarshal><custom ref="test"/></unmarshal>
        <to uri="mock:reverse"/>
    </route>

# Dependencies

    <dependency>
       <groupId>org.apache.camel</groupId>
       <artifactId>camel-cbor</artifactId>
       <version>x.x.x</version>
    </dependency>
