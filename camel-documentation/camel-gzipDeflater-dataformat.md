# GzipDeflater-dataformat.md

**Since Camel 2.0**

The GZip Deflater Data Format is a message compression and decompression
format. It uses the same deflating algorithm used in the Zip data
format, although some additional headers are provided. This format is
produced by popular `gzip`/`gunzip` tool. Messages marshalled using GZip
compression can be unmarshalled using GZip decompression just prior to
being consumed at the endpoint. The compression capability is quite
useful when you deal with large XML and text-based payloads or when you
read messages previously comressed using `gzip` tool.

This dataformat is not for working with gzip files such as uncompressing
and building gzip files. Instead, use the
[zipfile](#dataformats:zipFile-dataformat.adoc) dataformat.

# Options

# Marshal

In this example, we marshal a regular text/XML payload to a compressed
payload employing gzip compression format and send it an ActiveMQ queue
called MY\_QUEUE.

    from("direct:start").marshal().gzipDeflater().to("activemq:queue:MY_QUEUE");

# Unmarshal

In this example we unmarshal a gzipped payload from an ActiveMQ queue
called MY\_QUEUE to its original format, and forward it for processing
to the `UnGZippedMessageProcessor`.

    from("activemq:queue:MY_QUEUE").unmarshal().gzipDeflater().process(new UnGZippedMessageProcessor());

# Dependencies

If you use Maven you could add the following to your `pom.xml`,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-zip-deflater</artifactId>
      <version>x.x.x</version>
    </dependency>
