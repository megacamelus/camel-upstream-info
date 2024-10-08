# TarFile-dataformat.md

**Since Camel 2.16**

The Tar File Data Format is a message compression and decompression
format. Messages can be marshalled (compressed) to Tar Files containing
a single entry, and Tar Files containing a single entry can be
unmarshalled (decompressed) to the original file contents.

There is also an aggregation strategy that can aggregate multiple
messages into a single Tar File.

# TarFile Options

# Marshal

In this example, we marshal a regular text/XML payload to a compressed
payload using Tar File compression, and send it to an ActiveMQ queue
called MY\_QUEUE.

    from("direct:start").marshal().tarFile().to("activemq:queue:MY_QUEUE");

The name of the Tar entry inside the created Tar File is based on the
incoming `CamelFileName` message header, which is the standard message
header used by the file component. Additionally, the outgoing
`CamelFileName` message header is automatically set to the value of the
incoming `CamelFileName` message header, with the ".tar" suffix. So, for
example, if the following route finds a file named "test.txt" in the
input directory, the output will be a Tar File named "test.txt.tar"
containing a single Tar entry named "test.txt":

    from("file:input/directory?antInclude=*/.txt").marshal().tarFile().to("file:output/directory");

If there is no incoming `CamelFileName` message header (for example, if
the file component is not the consumer), then the message ID is used by
default, and since the message ID is normally a unique generated ID, you
will end up with filenames like
`ID-MACHINENAME-2443-1211718892437-1-0.tar`. If you want to override
this behavior, then you can set the value of the `CamelFileName` header
explicitly in your route:

    from("direct:start").setHeader(Exchange.FILE_NAME, constant("report.txt")).marshal().tarFile().to("file:output/directory");

This route would result in a Tar File named "report.txt.tar" in the
output directory, containing a single Tar entry named "report.txt".

# Unmarshal

In this example we unmarshal a Tar File payload from an ActiveMQ queue
called MY\_QUEUE to its original format, and forward it for processing
to the `UnTarpedMessageProcessor`.

    from("activemq:queue:MY_QUEUE").unmarshal().tarFile().process(new UnTarpedMessageProcessor());

If the Tar File has more than one entry, the usingIterator option of
TarFileDataFormat to be true, and you can use splitter to do the further
work.

      TarFileDataFormat tarFile = new TarFileDataFormat();
      tarFile.setUsingIterator(true);
      from("file:src/test/resources/org/apache/camel/dataformat/tarfile/?delay=1000&noop=true")
        .unmarshal(tarFile)
        .split(bodyAs(Iterator.class))
            .streaming()
              .process(new UnTarpedMessageProcessor())
        .end();

Or you can use the TarSplitter as an expression for splitter directly
like this

       from("file:src/test/resources/org/apache/camel/dataformat/tarfile?delay=1000&noop=true")
         .split(new TarSplitter())
            .streaming()
            .process(new UnTarpedMessageProcessor())
         .end();

You cannot use TarSplitter in *parallel* mode with the splitter.

# Aggregate

Please note that this aggregation strategy requires eager completion
check to work properly.

In this example, we aggregate all text files found in the input
directory into a single Tar File that is stored in the output directory.

       from("file:input/directory?antInclude=*/.txt")
         .aggregate(new TarAggregationStrategy())
           .constant(true)
           .completionFromBatchConsumer()
           .eagerCheckCompletion()
       .to("file:output/directory");

The outgoing `CamelFileName` message header is created using
java.io.File.createTempFile, with the ".tar" suffix. If you want to
override this behavior, then you can set the value of the
`CamelFileName` header explicitly in your route:

       from("file:input/directory?antInclude=*/.txt")
         .aggregate(new TarAggregationStrategy())
           .constant(true)
           .completionFromBatchConsumer()
           .eagerCheckCompletion()
         .setHeader(Exchange.FILE_NAME, constant("reports.tar"))
       .to("file:output/directory");

# Dependencies

To use Tar Files in your camel routes, you need to add a dependency on
**camel-tarfile**, which implements this data format.

If you use Maven you can add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-tarfile</artifactId>
      <version>x.x.x</version>
      <!-- use the same version as your Camel core version -->
    </dependency>
