# Chunk

**Since Camel 2.15**

**Only producer is supported**

The Chunk component allows for processing a message using a
[Chunk](http://www.x5software.com/chunk/examples/ChunkExample?loc=en_US)
template. This can be ideal when using Templating to generate responses
for requests.

# URI format

    chunk:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke.

You can append query options to the URI in the following format:
`?option=value&option=value&...`

Chunk component will look for a specific template in the *themes* folder
with extensions *.chtml* or \_.cxml. \_If you need to specify a
different folder or extensions, you will need to use the specific
options listed above.

# Chunk Context

Camel will provide exchange information in the Chunk context (just a
`Map`). The `Exchange` is transferred as:

<table>
<colgroup>
<col style="width: 20%" />
<col style="width: 80%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">key</th>
<th style="text-align: left;">value</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><code>exchange</code></p></td>
<td style="text-align: left;"><p>The <code>Exchange</code>
itself.</p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><code>exchange.properties</code></p></td>
<td style="text-align: left;"><p>The <code>Exchange</code>
properties.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>variables</code></p></td>
<td style="text-align: left;"><p>The variables</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>headers</code></p></td>
<td style="text-align: left;"><p>The headers of the In message.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>camelContext</code></p></td>
<td style="text-align: left;"><p>The Camel Context.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>request</code></p></td>
<td style="text-align: left;"><p>The In message.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p>The In message body.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>response</code></p></td>
<td style="text-align: left;"><p>The Out message (only for InOut message
exchange pattern).</p></td>
</tr>
</tbody>
</table>

# Dynamic templates

Camel provides two headers by which you can define a different resource
location for a template or the template content itself. If any of these
headers is set, then Camel uses this over the endpoint configured
resource. This allows you to provide a dynamic template at runtime.

# Samples

For example, you could use something like:

    from("activemq:My.Queue").
    to("chunk:template");

To use a Chunk template to formulate a response for a message for InOut
message exchanges (where there is a `JMSReplyTo` header).

If you want to use InOnly and consume the message and send it to another
destination, you could use:

    from("activemq:My.Queue").
    to("chunk:template").
    to("activemq:Another.Queue");

It’s possible to specify what template the component should use
dynamically via a header, so for example:

    from("direct:in").
    setHeader(ChunkConstants.CHUNK_RESOURCE_URI).constant("template").
    to("chunk:dummy?allowTemplateFromHeader=true");

An example of Chunk component options use:

    from("direct:in").
    to("chunk:file_example?themeFolder=template&themeSubfolder=subfolder&extension=chunk");

In this example, the Chunk component will look for the file
`file_example.chunk` in the folder `template/subfolder`.

# The Email Sample

In this sample, we want to use Chunk templating for an order
confirmation email. The email template is laid out in Chunk as:

    Dear {$headers.lastName}, {$headers.firstName}
    
    Thanks for the order of {$headers.item}.
    
    Regards Camel Riders Bookstore
    {$body}

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|encoding|Define the encoding of the body||string|
|extension|Define the file extension of the template||string|
|themeFolder|Define the themes folder to scan||string|
|themeLayer|Define the theme layer to elaborate||string|
|themeSubfolder|Define the themes subfolder to scan||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
