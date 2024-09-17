# Pdf

**Since Camel 2.16**

**Only producer is supported**

The PDF component provides the ability to create, modify or extract
content from PDF documents. This component uses [Apache
PDFBox](https://pdfbox.apache.org/) as the underlying library to work
with PDF documents.

To use the PDF component, Maven users will need to add the following
dependency to their `pom.xml`:

**pom.xml**

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-pdf</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

The PDF component only supports producer endpoints.

    pdf:operation[?options]

# Usage

## Type converter

Since Camel 4.8, the component is capable of doing simple document
conversions. For instance, suppose you are receiving a PDF byte as a
byte array:

    from("direct:start")
        .to("pdf:extractText")
        .to("mock:result");

It is now possible to get the body as a PD Document by using
`PDDocument doc = exchange.getIn().getBody(PDDocument.class);`, which
saves the trouble of converting the byte-array to a document.

this only works for unprotected PDF files. For password-protected, the
files still need to be converted manually.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|operation|Operation type||object|
|font|Font|HELVETICA|string|
|fontSize|Font size in pixels|14.0|number|
|marginBottom|Margin bottom in pixels|20|integer|
|marginLeft|Margin left in pixels|20|integer|
|marginRight|Margin right in pixels|40|integer|
|marginTop|Margin top in pixels|20|integer|
|pageSize|Page size|A4|string|
|textProcessingFactory|Text processing to use. autoFormatting: Text is getting sliced by words, then max amount of words that fits in the line will be written into pdf document. With this strategy all words that doesn't fit in the line will be moved to the new line. lineTermination: Builds set of classes for line-termination writing strategy. Text getting sliced by line termination symbol and then it will be written regardless it fits in the line or not.|lineTermination|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
