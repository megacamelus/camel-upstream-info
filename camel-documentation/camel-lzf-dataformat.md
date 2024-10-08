# Lzf-dataformat.md

**Since Camel 2.17**

The LZF [Data Format](#manual::data-format.adoc) is a message
compression and decompression format. It uses the LZF deflate algorithm.
Messages marshalled using LZF compression can be unmarshalled using LZF
decompression just prior to being consumed at the endpoint. The
compression capability is quite useful when you deal with large XML and
text-based payloads or when you read messages previously compressed
using LZF algorithm.

# Options

# Marshal

In this example, we marshal a regular text/XML payload to a compressed
payload employing LZF compression format and send it an ActiveMQ queue
called MY\_QUEUE.

    from("direct:start").marshal().lzf().to("activemq:queue:MY_QUEUE");

# Unmarshal

In this example we unmarshal a LZF payload from an ActiveMQ queue called
MY\_QUEUE to its original format, and forward it for processing to the
`UnGZippedMessageProcessor`.

    from("activemq:queue:MY_QUEUE").unmarshal().lzf().process(new UnCompressedMessageProcessor());

# Dependencies

To use LZF compression in your Camel routes, you need to add a
dependency on **camel-lzf** which implements this data format.

If you use Maven you can add the following to your `pom.xml`,
substituting the version number for the latest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-lzf</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
