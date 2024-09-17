# SwiftMt-dataformat.md

**Since Camel 3.20**

The SWIFT MT data format is used to encode and decode SWIFT MT messages.
The data format leverages the library [Prowide
Core](https://github.com/prowide/prowide-core) to encode and decode
SWIFT MT messages.

# Options

In Spring DSL, you configure the data format using this tag:

    <camelContext>
        <dataFormats>
            <swiftMt id="swiftInJson" writeInJson="true"/>
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
            <swiftMt />
        </marshal>
        <to uri="mock:result" />
    </route>

# Marshal

In this example, we marshal the messages read from a JMS queue in SWIFT
format before storing the result into a file.

    from("jms://myqueue")
        .marshal().swiftMt()
        .to("file://data.bin");

In Spring DSL:

     <from uri="jms://myqueue">
     <marshal>
         <swiftMt/>
     </marshal>
     <to uri="file://data.bin"/>

# Unmarshal

The unmarshaller converts the input data into the concrete class of type
`com.prowidesoftware.swift.model.mt.AbstractMT` that best matches with
the content of the message.

In this example, we unmarshal the content of a file to get SWIFT MT
objects before processing them with the `newOrder` processor.

**SwiftMt example in Java**

    from("file://data.bin")
        .unmarshal().swiftMt()
        .process("newOrder");

**SwiftMt example in In Spring DSL**

     <from uri="file://data.bin">
     <unmarshal>
         <swiftMt/>
     </unmarshal>
     <to uri="bean:newOrder"/>

# Dependencies

To use SWIFT MT in your Camel routes, you need to add a dependency on
**camel-swift** which implements this data format.

If you use Maven, you can add the following to your `pom.xml`:

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-swift</artifactId>
      <version>x.x.x</version>  <!-- use the same version as your Camel core version -->
    </dependency>
