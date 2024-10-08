# ProtobufJackson-dataformat.md

**Since Camel 3.10**

Jackson Protobuf is a Data Format which uses the [Jackson
library](https://github.com/FasterXML/jackson/) with the [Protobuf
extension](https://github.com/FasterXML/jackson-dataformats-binary) to
unmarshal a Protobuf payload into Java objects or to marshal Java
objects into a Protobuf payload.

If you are familiar with Jackson, this Protobuf data format behaves in
the same way as its JSON counterpart, and thus can be used with classes
annotated for JSON serialization/deserialization.

    from("kafka:topic").
      unmarshal().protobuf(ProtobufLibrary.Jackson, JsonNode.class).
      to("log:info");

# Protobuf Jackson Options

# Usage

## Configuring the `SchemaResolver`

Since Protobuf serialization is schema-based, this data format requires
that you provide a SchemaResolver object that is able to look up the
schema for each exchange that is going to be marshalled/unmarshalled.

You can add a single SchemaResolver to the registry, and it will be
looked up automatically. Or you can explicitly specify the reference to
a custom SchemaResolver.

## Using custom ProtobufMapper

You can configure `JacksonProtobufDataFormat` to use a custom
`ProtobufMapper` in case you need more control of the mapping
configuration.

If you set up a single `ProtobufMapper` in the registry, then Camel will
automatic lookup and use this `ProtobufMapper`.

# Dependencies

To use Protobuf Jackson in your Camel routes, you need to add the
dependency on **camel-jackson-protobuf**, which implements this data
format.

If you use Maven, you could add the following to your pom.xml,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-jackson-protobuf</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
