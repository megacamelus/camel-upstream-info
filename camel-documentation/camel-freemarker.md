# Freemarker

**Since Camel 2.10**

**Only producer is supported**

The **freemarker:** component allows for processing a message using a
[FreeMarker](http://freemarker.org/) template. This can be ideal when
using Templating to generate responses for requests.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-freemarker</artifactId>
        <version>x.x.x</version> <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    freemarker:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke; or the complete URL of the remote template (e.g.:
`\file://folder/myfile.ftl`).

# Headers

Headers set during the FreeMarker evaluation are returned to the message
and added as headers. This provides a mechanism for the FreeMarker
component to return values to the Message.

For example, set the header value of `fruit` in the FreeMarker template:

    ${request.setHeader('fruit', 'Apple')}

The header, `fruit`, is now accessible from the `message.out.headers`.

# Usage

## FreeMarker Context

Camel will provide exchange information in the FreeMarker context (just
a `Map`). The `Exchange` is transferred as:

<table>
<colgroup>
<col style="width: 50%" />
<col style="width: 50%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">key</th>
<th style="text-align: left;">value</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>exchange</code></p></td>
<td style="text-align: left;"><p>The <code>Exchange</code>
itself.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>exchange.properties</code></p></td>
<td style="text-align: left;"><p>The <code>Exchange</code>
properties.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>variables</code></p></td>
<td style="text-align: left;"><p>The variables</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>headers</code></p></td>
<td style="text-align: left;"><p>The headers of the In message.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>camelContext</code></p></td>
<td style="text-align: left;"><p>The Camel Context.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>request</code></p></td>
<td style="text-align: left;"><p>The In message.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p>The In message body.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>response</code></p></td>
<td style="text-align: left;"><p>The Out message (only for InOut message
exchange pattern).</p></td>
</tr>
</tbody>
</table>

You can set up your custom FreeMarker context in the message header with
the key "**CamelFreemarkerDataModel**" just like this

    Map<String, Object> variableMap = new HashMap<String, Object>();
    variableMap.put("headers", headersMap);
    variableMap.put("body", "Monday");
    variableMap.put("exchange", exchange);
    exchange.getIn().setHeader("CamelFreemarkerDataModel", variableMap);

## Hot reloading

The FreeMarker template resource is by default **not** hot reloadable
for both file and classpath resources (expanded jar). If you set
`contentCache=false`, then Camel will not cache the resource and hot
reloading is thus enabled. This scenario can be used in development.

## Dynamic templates

Camel provides two headers by which you can define a different resource
location for a template or the template content itself. If any of these
headers is set, then Camel uses this over the endpoint configured
resource. This allows you to provide a dynamic template at runtime.

# Examples

For example, you could use something like:

    from("activemq:My.Queue").
      to("freemarker:com/acme/MyResponse.ftl");

To use a FreeMarker template to formulate a response for a message for
InOut message exchanges (where there is a `JMSReplyTo` header).

If you want to use InOnly and consume the message and send it to another
destination, you could use:

    from("activemq:My.Queue").
      to("freemarker:com/acme/MyResponse.ftl").
      to("activemq:Another.Queue");

And to disable the content cache, e.g., for development usage where the
`.ftl` template should be hot reloaded:

    from("activemq:My.Queue").
      to("freemarker:com/acme/MyResponse.ftl?contentCache=false").
      to("activemq:Another.Queue");

And a file-based resource:

    from("activemq:My.Queue").
      to("freemarker:file://myfolder/MyResponse.ftl?contentCache=false").
      to("activemq:Another.Queue");

It’s possible to specify what template the component should use
dynamically via a header, so for example:

    from("direct:in").
      setHeader(FreemarkerConstants.FREEMARKER_RESOURCE_URI).constant("path/to/my/template.ftl").
      to("freemarker:dummy?allowTemplateFromHeader=true");

## The Email Example

In this sample, we want to use FreeMarker templating for an order
confirmation email. The email template is laid out in FreeMarker as:

    Dear ${headers.lastName}, ${headers.firstName}
    
    Thanks for the order of ${headers.item}.
    
    Regards Camel Riders Bookstore
    ${body}

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|localizedLookup|Enables/disables localized template lookup. Disabled by default.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|configuration|To use an existing freemarker.template.Configuration instance as the configuration.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|configuration|Sets the Freemarker configuration to use||object|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|encoding|Sets the encoding to be used for loading the template file.||string|
|templateUpdateDelay|Number of seconds the loaded template resource will remain in the cache.||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
