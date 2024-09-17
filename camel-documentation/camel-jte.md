# Jte

**Since Camel 4.4**

**Only producer is supported**

The **jte:** component allows for processing a message using a
[JTE](https://jte.gg/) template. The JTE is a Java Template Engine,
which means you write templates that resemble Java code, which in fact
gets transformed into .java source files that gets compiled to have very
fast performance.

Only use this component if you are familiar with Java programming.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jte</artifactId>
        <version>x.x.x</version> <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    jte:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke; or the complete URL of the remote template (e.g.:
`\file://folder/myfile.jte`).

# Usage

## JTE Context

Camel will provide exchange information in the JTE context, as a
`org.apache.camel.component.jte.Model` class with the following
information:

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
<td style="text-align: left;"><p>The <code>Exchange</code> itself (only
if allowContextMapAll=true).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>headers</code></p></td>
<td style="text-align: left;"><p>The headers of the message as
<code>java.util.Map</code>.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p>The message body as
<code>Object</code>.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>strBody()</code></p></td>
<td style="text-align: left;"><p>The message body converted to a
String</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>header("key")</code></p></td>
<td style="text-align: left;"><p>Message header with the given key
converted to a String value.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>exchangeProperty("key")</code></p></td>
<td style="text-align: left;"><p>Exchange property with the given key
converted to a String value (only if allowContextMapAll=true).</p></td>
</tr>
</tbody>
</table>

You can set up your custom JTE data model in the message header with the
key "**CamelJteDataModel**" just like this

## Dynamic templates

Camel provides two headers by which you can define a different resource
location for a template or the template content itself. If any of these
headers is set, then Camel uses this over the endpoint configured
resource. This allows you to provide a dynamic template at runtime.

# Examples

For example, you could use something like:

    from("rest:get:item/{id}").
      to("jte:com/acme/response.jte");

To use a JTE template to formulate a response to the REST get call:

    @import org.apache.camel.component.jte.Model
    @param Model model
    
    The item ${model.header("id")} is being processed.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentType|Content type the JTE engine should use.|Plain|object|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|preCompile|To speed up startup and rendering on your production server, it is possible to precompile all templates during the build. This way, the template engine can load each template's .class file directly without first compiling it.|false|boolean|
|workDir|Work directory where JTE will store compiled templates.|jte-classes|string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
