# Velocity

**Since Camel 1.2**

**Only producer is supported**

The Velocity component allows you to process a message using an [Apache
Velocity](http://velocity.apache.org/) template. This can be ideal when
using Templating to generate responses for requests.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-velocity</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    velocity:templateName[?options]

Where **templateName** is the classpath-local URI of the template to
invoke; or the complete URL of the remote template (e.g.:
`\file://folder/myfile.vm`).

Headers set during the Velocity evaluation are returned to the message
and added as headers. Then it is possible to return values from Velocity
to the Message.

For example, to set the header value of `fruit` in the Velocity template
`.tm`:

    $in.setHeader("fruit", "Apple")

The `fruit` header is now accessible from the `message.out.headers`.

# Usage

## Velocity Context

Camel will provide exchange information in the Velocity context (just a
`Map`). The `Exchange` is transferred as:

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
<td style="text-align: left;"><p>The Camel Context instance.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>request</code></p></td>
<td style="text-align: left;"><p>The In message.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>in</code></p></td>
<td style="text-align: left;"><p>The In message.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>body</code></p></td>
<td style="text-align: left;"><p>The In message body.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>out</code></p></td>
<td style="text-align: left;"><p>The Out message (only for InOut message
exchange pattern).</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>response</code></p></td>
<td style="text-align: left;"><p>The Out message (only for InOut message
exchange pattern).</p></td>
</tr>
</tbody>
</table>

You can set up a custom Velocity Context yourself by setting property
`allowTemplateFromHeader=true` and setting the message header
`CamelVelocityContext` just like this

    VelocityContext velocityContext = new VelocityContext(variableMap);
    exchange.getIn().setHeader("CamelVelocityContext", velocityContext);

## Hot reloading

The Velocity template resource is, by default, hot reloadable for both
file and classpath resources (expanded jar). If you set
`contentCache=true`, Camel will only load the resource once, and thus
hot reloading is not possible. This scenario can be used in production
when the resource never changes.

## Dynamic templates

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
<tr class="header">
<th style="text-align: left;">Header</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>CamelVelocityResourceUri</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>A URI for the template resource to use
instead of the endpoint configured.</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><code>CamelVelocityTemplate</code></p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>The template to use instead of the
endpoint configured.</p></td>
</tr>
</tbody>
</table>

# Examples

For example, you could use something like

    from("activemq:My.Queue").
      to("velocity:com/acme/MyResponse.vm");

To use a Velocity template to formulate a response to a message for
InOut message exchanges (where there is a `JMSReplyTo` header).

If you want to use InOnly and consume the message and send it to another
destination, you could use the following route:

    from("activemq:My.Queue").
      to("velocity:com/acme/MyResponse.vm").
      to("activemq:Another.Queue");

And to use the content cache, e.g., for use in production, where the
`.vm` template never changes:

    from("activemq:My.Queue").
      to("velocity:com/acme/MyResponse.vm?contentCache=true").
      to("activemq:Another.Queue");

And a file-based resource:

    from("activemq:My.Queue").
      to("velocity:file://myfolder/MyResponse.vm?contentCache=true").
      to("activemq:Another.Queue");

It’s possible to specify what template the component should use
dynamically via a header, so for example:

    from("direct:in").
      setHeader("CamelVelocityResourceUri").constant("path/to/my/template.vm").
      to("velocity:dummy?allowTemplateFromHeader=true"");

It’s possible to specify a template directly as a header. The component
should use it dynamically via a header, so for example:

    from("direct:in").
      setHeader("CamelVelocityTemplate").constant("Hi this is a velocity template that can do templating ${body}").
      to("velocity:dummy?allowTemplateFromHeader=true"");

## The Email Example

In this sample, we want to use Velocity templating for an order
confirmation email. The email template is laid out in Velocity as:

**letter.vm**

    Dear ${headers.lastName}, ${headers.firstName}
    
    Thanks for the order of ${headers.item}.
    
    Regards Camel Riders Bookstore
    ${body}

And the java code (from an unit test):

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
        public void testVelocityLetter() throws Exception {
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
                        .to("velocity:org/apache/camel/component/velocity/letter.vm")
                        .to("mock:result");
                }
            };
        }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|velocityEngine|To use the VelocityEngine otherwise a new engine is created||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|resourceUri|Path to the resource. You can prefix with: classpath, file, http, ref, or bean. classpath, file and http loads the resource using these protocols (classpath is default). ref will lookup the resource in the registry. bean will call a method on a bean to be used as the resource. For bean you can specify the method name after dot, eg bean:myBean.myMethod.||string|
|allowContextMapAll|Sets whether the context map should allow access to all details. By default only the message body and headers can be accessed. This option can be enabled for full access to the current Exchange and CamelContext. Doing so impose a potential security risk as this opens access to the full power of CamelContext API.|false|boolean|
|allowTemplateFromHeader|Whether to allow to use resource template from header or not (default false). Enabling this allows to specify dynamic templates via message header. However this can be seen as a potential security vulnerability if the header is coming from a malicious user, so use this with care.|false|boolean|
|contentCache|Sets whether to use resource content cache or not|false|boolean|
|encoding|Character encoding of the resource content.||string|
|loaderCache|Enables / disables the velocity resource loader cache which is enabled by default|true|boolean|
|propertiesFile|The URI of the properties file which is used for VelocityEngine initialization.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
