# Thymeleaf

**Since Camel 4.1**

**Only producer is supported**

The Thymeleaf component allows you to process a message using a
[Thymeleaf](https://www.thymeleaf.org/) template. This can be very
powerful when using Templating to generate responses for requests.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-thymeleaf</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    thymeleaf:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke; or the complete URL of the remote template (e.g.:
`\file://folder/myfile.html`).

Headers set during the Thymeleaf evaluation are returned to the message
and added as headers, thus making it possible to return values from
Thymeleaf to the Message.

For example, to set the header value of `fruit` in the Thymeleaf
template `fruit-template.html`:

    $in.setHeader("fruit", "Apple")

The `fruit` header is now accessible from the `message.out.headers`.

# Thymeleaf Context

Camel will provide exchange information in the Thymeleaf context (just a
`Map`). The `Exchange` is transferred as:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
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
<td style="text-align: left;"><p><code>headers</code></p></td>
<td style="text-align: left;"><p>The headers of the In message.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>camelContext</code></p></td>
<td style="text-align: left;"><p>The Camel Context instance.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>request</code></p></td>
<td style="text-align: left;"><p>The In message.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>in</code></p></td>
<td style="text-align: left;"><p>The In message.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p>The In message body.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>out</code></p></td>
<td style="text-align: left;"><p>The Out message (only for InOut message
exchange pattern).</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><code>response</code></p></td>
<td style="text-align: left;"><p>The Out message (only for InOut message
exchange pattern).</p></td>
</tr>
</tbody>
</table>

You can set up a custom Thymeleaf Context yourself by setting property
`allowTemplateFromHeader=true` and setting the message header
`CamelThymeleafContext` like this

    EngineContext engineContext = new EngineContext(variableMap);
    exchange.getIn().setHeader("CamelThymeleafContext", engineContext);

# Hot reloading

The Thymeleaf template resource is, by default, hot reloadable for both
file and classpath resources (expanded jar). If you set
`contentCache=true`, Camel will only load the resource once, and thus
hot reloading is not possible. This scenario can be used in production
when the resource never changes.

# Dynamic templates

Camel provides two headers by which you can define a different resource
location for a template or the template content itself. If any of these
headers is set, then Camel uses this over the endpoint configured
resource. This allows you to provide a dynamic template at runtime.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>CamelThymeleafResourceUri</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A URI for the template resource to use
instead of the endpoint configured.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>CamelThymeleafTemplate</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The template to use instead of the
endpoint configured.</p></td>
</tr>
</tbody>
</table>

# Samples

For a simple use case, you could use something like:

    from("activemq:My.Queue").
      to("thymeleaf:com/acme/MyResponse.html");

To use a Thymeleaf template to formulate a response to a message for
InOut message exchanges (where there is a `JMSReplyTo` header).

If you want to use InOnly and consume the message and send it to another
destination, you could use the following route:

    from("activemq:My.Queue")
      .to("thymeleaf:com/acme/MyResponse.html")
      .to("activemq:Another.Queue");

And to use the content cache, e.g., for use in production, where the
`.html` template never changes:

    from("activemq:My.Queue")
      .to("thymeleaf:com/acme/MyResponse.html?contentCache=true")
      .to("activemq:Another.Queue");

And a file-based resource:

    from("activemq:My.Queue")
      .to("thymeleaf:file://myfolder/MyResponse.html?contentCache=true")
      .to("activemq:Another.Queue");

It’s possible to specify what template the component should use
dynamically via a header, so for example:

    from("direct:in")
      .setHeader("CamelThymeleafResourceUri").constant("path/to/my/template.html")
      .to("thymeleaf:dummy?allowTemplateFromHeader=true"");

It’s possible to specify a template directly as a header. The component
should use it dynamically via a header, so, for example:

    from("direct:in")
      .setHeader("CamelThymeleafTemplate").constant("Hi this is a thymeleaf template that can do templating ${body}")
      .to("thymeleaf:dummy?allowTemplateFromHeader=true"");

# The Email Sample

In this sample, we want to use Thymeleaf templating for an order
confirmation email. The email template is laid out in Thymeleaf as:

**letter.html**

    Dear [(${headers.lastName})], [(${headers.firstName})]
    
    Thanks for the order of [(${headers.item})].
    
    Regards Camel Riders Bookstore
    [(${body})]

And the java code (from a unit test):

        private Exchange createLetter() {
            Exchange exchange = context.getEndpoint("direct:a").createExchange();
            Message msg = exchange.getIn();
            msg.setHeader("firstName", "Claus");
            msg.setHeader("lastName", "Ibsen");
            msg.setHeader("item", "Camel in Action");
            msg.setBody("PS: Next beer is on me, James");
            return exchange;
        }
    
        @Test
        public void testThymeleafLetter() throws Exception {
            MockEndpoint mock = getMockEndpoint("mock:result");
            mock.expectedMessageCount(1);
            mock.message(0).body(String.class).contains("Thanks for the order of Camel in Action");
    
            template.send("direct:a", createLetter());
    
            mock.assertIsSatisfied();
        }
    
        @Override
        protected RouteBuilder createRouteBuilder() {
            return new RouteBuilder() {
                public void configure() {
                    from("direct:a")
                        .to("thymeleaf:org/apache/camel/component/thymeleaf/letter.txt")
                        .to("mock:result");
                }
            };
        }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|cacheable|Whether templates have to be considered cacheable or not.||boolean|
|cacheTimeToLive|The cache Time To Live for templates, expressed in milliseconds.||integer|
|checkExistence|Whether a template resources will be checked for existence before being returned.||boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|templateMode|The template mode to be applied to templates.|HTML|string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|encoding|The character encoding to be used for reading template resources.||string|
|order|The order in which this template will be resolved as part of the resolver chain.||integer|
|prefix|An optional prefix added to template names to convert them into resource names.||string|
|resolver|The type of resolver to be used by the template engine.|CLASS\_LOADER|object|
|suffix|An optional suffix added to template names to convert them into resource names.||string|
