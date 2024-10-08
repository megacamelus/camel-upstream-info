# ParquetAvro-dataformat.md

**Since Camel 4.0**

The ParquetAvro Data Format is a Camel Framework’s data format
implementation based on the parquet-avro library for (de)/serialization
purposes. Messages can be unmarshalled to Avro’s GenericRecords or plain
Java objects (POJOs). With the help of Camel’s routing engine and data
transformations, you can then play with them and apply customised
formatting and call other Camel Components to convert and send messages
to upstream systems.

# Parquet Data Format Options

# Unmarshal

There are ways to unmarshal parquet files/structures, usually binary
parquet files, where camel DSL allows.

In this first example we unmarshal file payload to OutputStream and send
it to mock endpoint, then we will be able to get GenericRecord or POJO
(it could be a list if that is coming through)

    from("direct:unmarshal").unmarshal(parquet).to("mock:unmarshal");

# Marshal

Marshalling is the reverse process of unmarshalling, so when you have
your `GenericRecord` or POJO and marshal it, you will get the
parquet-formatted output stream on your producer endpoint.

    from("direct:marshal").marshal(parquet).to("mock:marshal");

# Dependencies

To use parquet-avro data format in your camel routes you need to add a
dependency on **camel-parquet-avro** which implements this data format.

If you use Maven you can add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-parquet-avro</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
