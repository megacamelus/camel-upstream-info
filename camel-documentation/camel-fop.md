# Fop

**Since Camel 2.10**

**Only producer is supported**

The FOP component allows you to render a message into different output
formats using [Apache
FOP](http://xmlgraphics.apache.org/fop/index.html).

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-fop</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    fop://outputFormat?[options]

# Output Formats

The primary output format is PDF, but other output
[formats](http://xmlgraphics.apache.org/fop/0.95/output.html) are also
supported:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">name</th>
<th style="text-align: left;">outputFormat</th>
<th style="text-align: left;">description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>PDF</p></td>
<td style="text-align: left;"><p>application/pdf</p></td>
<td style="text-align: left;"><p>Portable Document Format</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>PS</p></td>
<td style="text-align: left;"><p>application/postscript</p></td>
<td style="text-align: left;"><p>Adobe Postscript</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>PCL</p></td>
<td style="text-align: left;"><p>application/x-pcl</p></td>
<td style="text-align: left;"><p>Printer Control Language</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>PNG</p></td>
<td style="text-align: left;"><p>image/png</p></td>
<td style="text-align: left;"><p>PNG images</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>JPEG</p></td>
<td style="text-align: left;"><p>image/jpeg</p></td>
<td style="text-align: left;"><p>JPEG images</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>SVG</p></td>
<td style="text-align: left;"><p>image/svg+xml</p></td>
<td style="text-align: left;"><p>Scalable Vector Graphics</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>XML</p></td>
<td style="text-align: left;"><p>application/X-fop-areatree</p></td>
<td style="text-align: left;"><p>Area tree representation</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>MIF</p></td>
<td style="text-align: left;"><p>application/mif</p></td>
<td style="text-align: left;"><p>FrameMaker’s MIF</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>RTF</p></td>
<td style="text-align: left;"><p>application/rtf</p></td>
<td style="text-align: left;"><p>Rich Text Format</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>TXT</p></td>
<td style="text-align: left;"><p>text/plain</p></td>
<td style="text-align: left;"><p>Text</p></td>
</tr>
</tbody>
</table>

The complete list of valid output formats can be found in the
`MimeConstants.java` source file.

# Configuration file

The location of a configuration file with the following
[structure](http://xmlgraphics.apache.org/fop/1.0/configuration.html).
The file is loaded from the classpath by default. You can use `file:`,
or `classpath:` as prefix to load the resource from file or classpath.
In previous releases, the file is always loaded from the file system.

# Message Operations

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">name</th>
<th style="text-align: left;">default value</th>
<th style="text-align: left;">description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>CamelFop.Output.Format</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Overrides the output format for that
message</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Encrypt.userPassword</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>PDF user password</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Encrypt.ownerPassword</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>PDF owner passoword</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Encrypt.allowPrint</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Allows printing the PDF</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p>CamelFop.Encrypt.allowCopyContent</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Allows copying content of the
PDF</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p>CamelFop.Encrypt.allowEditContent</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Allows editing content of the
PDF</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p>CamelFop.Encrypt.allowEditAnnotations</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>Allows editing annotation of the
PDF</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.producer</p></td>
<td style="text-align: left;"><p>Apache FOP</p></td>
<td style="text-align: left;"><p>Metadata element for the
system/software that produces the document</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.creator</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Metadata element for the user that
created the document</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.creationDate</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Creation Date</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.author</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Author of the content of the
document</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.title</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Title of the document</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.subject</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Subject of the document</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelFop.Render.keywords</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Set of keywords applicable to this
document</p></td>
</tr>
</tbody>
</table>

# Example

Below is an example route that renders PDFs from xml data and xslt
template and saves the PDF files in the target folder:

    from("file:source/data/xml")
        .to("xslt:xslt/template.xsl")
        .to("fop:application/pdf")
        .to("file:target/data");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|outputType|The primary output format is PDF but other output formats are also supported.||object|
|fopFactory|Allows to use a custom configured or implementation of org.apache.fop.apps.FopFactory.||object|
|userConfigURL|The location of a configuration file which can be loaded from classpath or file system.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
