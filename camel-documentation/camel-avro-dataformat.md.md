# Avro-dataformat.md

**Since Camel 2.14**

This component provides a dataformat for avro, which allows
serialization and deserialization of messages using Apache Avro’s binary
dataformat. Since Camel 3.2 rpc functionality was moved into separate
`camel-avro-rpc` component.

There is also `camel-jackson-avro` which is a more powerful Camel
dataformat for using Avro.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-avro</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

You can easily generate classes from a schema, using maven, ant etc.
More details can be found at the [Apache Avro
documentation](http://avro.apache.org/docs/current/).

# Avro Dataformat Options

# Examples

# Avro Data Format usage

Using the avro data format is as easy as specifying that the class that
you want to marshal or unmarshal in your route.

    AvroDataFormat format = new AvroDataFormat(Value.SCHEMA$);
    
    from("direct:in").marshal(format).to("direct:marshal");
    from("direct:back").unmarshal(format).to("direct:unmarshal");

Where Value is an Avro Maven Plugin Generated class.

or in XML

        <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
            <route>
                <from uri="direct:in"/>
                <marshal>
                    <avro instanceClass="org.apache.camel.dataformat.avro.Message" library="ApacheAvro"/>
                </marshal>
                <to uri="log:out"/>
            </route>
        </camelContext>

An alternative can be to specify the dataformat inside the context and
reference it from your route.

        <camelContext id="camel" xmlns="http://camel.apache.org/schema/spring">
             <dataFormats>
                <avro id="avro" instanceClass="org.apache.camel.dataformat.avro.Message" library="ApacheAvro"/>
            </dataFormats>
            <route>
                <from uri="direct:in"/>
                <marshal><custom ref="avro"/></marshal>
                <to uri="log:out"/>
            </route>
        </camelContext>

In the same manner, you can unmarshal using the avro data format.
