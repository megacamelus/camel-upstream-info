# String-template

**Since Camel 1.2**

**Only producer is supported**

The String Template component allows you to process a message using a
[String Template](http://www.stringtemplate.org/). This can be ideal
when using Templating to generate responses for requests.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-stringtemplate</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    string-template:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke; or the complete URL of the remote template.

# Usage

## Headers

Camel will store a reference to the resource in the message header with
key, `org.apache.camel.stringtemplate.resource`. The Resource is an
`org.springframework.core.io.Resource` object.

## String Template Context

Camel will provide exchange information in the String Template context
(just a `Map`). The `Exchange` is transferred as:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
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

## Hot reloading

The string template resource is by default hot-reloadable for both file
and classpath resources (expanded jar). If you set `contentCache=true`,
Camel loads the resource only once and hot-reloading is not possible.
This scenario can be used in production when the resource never changes.

## Dynamic templates

Camel provides two headers by which you can define a different resource
location for a template or the template content itself. If any of these
headers is set, then Camel uses this over the endpoint configured
resource. This allows you to provide a dynamic template at runtime.

## StringTemplate Attributes

You can define the custom context map by setting the message header
"**CamelStringTemplateVariableMap**" just like the below code.

    Map<String, Object> variableMap = new HashMap<String, Object>();
    Map<String, Object> headersMap = new HashMap<String, Object>();
    headersMap.put("name", "Willem");
    variableMap.put("headers", headersMap);
    variableMap.put("body", "Monday");
    variableMap.put("exchange", exchange);
    exchange.getIn().setHeader("CamelStringTemplateVariableMap", variableMap);

# Examples

For example, you could use a string template as follows in order to
formulate a response to a message:

    from("activemq:My.Queue").
      to("string-template:com/acme/MyResponse.tm");

## The Email Example

In this sample, we want to use a string template to send an order
confirmation email. The email template is laid out in `StringTemplate`
as:

    Dear <headers.lastName>, <headers.firstName>
    
    Thanks for the order of <headers.item>.
    
    Regards Camel Riders Bookstore
    <body>

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
|delimiterStart|The variable start delimiter|\<|string|
|delimiterStop|The variable end delimiter|\>|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
