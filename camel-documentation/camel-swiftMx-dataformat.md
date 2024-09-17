# SwiftMx-dataformat.md

**Since Camel 3.20**

The SWIFT MX data format is used to encode and decode SWIFT MX messages.
The data format leverages the library [Prowide ISO
20022](https://github.com/prowide/prowide-iso20022) to encode and decode
SWIFT MX messages.

# Options

In Spring DSL, you configure the data format using this tag:

    <camelContext>
        <dataFormats>
            <swiftMx id="swiftInJson" writeInJson="true"/>
        </dataFormats>
        ...
    </camelContext>

Then you can use it later by its reference:

    <route>
         <from uri="direct:startEncode" />
         <marshal ref="swiftInJson" />
         <to uri="mock:result" />
    </route>

Most of the time, you won’t need to declare the data format if you use
the default options. In that case, you can declare the data format
inline as shown below:

    <route>
        <from uri="direct:startEncode" />
        <marshal>
            <swiftMx />
        </marshal>
        <to uri="mock:result" />
    </route>

# Marshal

In this example, we marshal the messages read from a JMS queue in SWIFT
format before storing the result into a file.

    from("jms://myqueue")
        .marshal().swiftMx()
        .to("file://data.bin");

In Spring DSL:

     <from uri="jms://myqueue">
     <marshal>
         <swiftMx/>
     </marshal>
     <to uri="file://data.bin"/>

# Unmarshal

The unmarshaller converts the input data into the concrete class of type
`com.prowidesoftware.swift.model.mx.AbstractMX` that best matches with
the content of the message.

In this example, we unmarshal the content of a file to get SWIFT MX
objects before processing them with the `newOrder` processor.

    from("file://data.bin")
        .unmarshal().swiftMx()
        .process("newOrder");

In Spring DSL:

     <from uri="file://data.bin">
     <unmarshal>
         <swiftMx/>
     </unmarshal>
     <to uri="bean:newOrder"/>

# Dependencies

To use SWIFT MX in your Camel routes, you need to add a dependency on
**camel-swift** which implements this data format.

If you use Maven, you can add the following to your pom.xml:

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-swift</artifactId>
      <version>x.x.x</version>  <!-- use the same version as your Camel core version -->
    </dependency>
