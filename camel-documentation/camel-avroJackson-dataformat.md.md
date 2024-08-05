# AvroJackson-dataformat.md

**Since Camel 3.10**

Jackson Avro is a Data Format which uses the [Jackson
library](https://github.com/FasterXML/jackson/) with the [Avro
extension](https://github.com/FasterXML/jackson-dataformats-binary) to
unmarshal an Avro payload into Java objects or to marshal Java objects
into an Avro payload.

If you are familiar with Jackson, this Avro data format behaves in the
same way as its JSON counterpart, and thus can be used with classes
annotated for JSON serialization/deserialization.

    from("kafka:topic").
      unmarshal().avro(JsonNode.class).
      to("log:info");

# Configuring the `SchemaResolver`

Since Avro serialization is schema-based, this data format requires that
you provide a SchemaResolver object that is able to look up the schema
for each exchange that is going to be marshalled/unmarshalled.

You can add a single SchemaResolver to the registry, and it will be
looked up automatically. Or you can explicitly specify the reference to
a custom SchemaResolver.

# Avro Jackson Options

# Using custom AvroMapper

You can configure `JacksonAvroDataFormat` to use a custom `AvroMapper`
in case you need more control of the mapping configuration.

If you set up a single `AvroMapper` in the registry, then Camel will
automatic lookup and use this `AvroMapper`.

# Dependencies

To use Avro Jackson in your Camel routes, you need to add the dependency
on **camel-jackson-avro**, which implements this data format.

If you use Maven, you could add the following to your pom.xml,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-jackson-avro</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
