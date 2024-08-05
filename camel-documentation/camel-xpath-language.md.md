# Xpath-language.md

**Since Camel 1.1**

Camel supports [XPath](http://www.w3.org/TR/xpath) to allow an
[Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc) to be used in the
[DSL](#manual::dsl.adoc).

For example, you could use XPath to create a predicate in a [Message
Filter](#eips:filter-eip.adoc) or as an expression for a [Recipient
List](#eips:recipientList-eip.adoc).

# XPath Language options

# Namespaces

You can use namespaces with XPath expressions using the `Namespaces`
helper class.

# Variables

Variables in XPath are defined in different namespaces. The default
namespace is `\http://camel.apache.org/schema/spring`.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Namespace URI</th>
<th style="text-align: left;">Local part</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><a
href="http://camel.apache.org/xml/in/">http://camel.apache.org/xml/in/</a></p></td>
<td style="text-align: left;"><p>in</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><a
href="http://camel.apache.org/xml/out/">http://camel.apache.org/xml/out/</a></p></td>
<td style="text-align: left;"><p>out</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p><strong>deprecated</strong> the output
message (do not use)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><a
href="http://camel.apache.org/xml/function/">http://camel.apache.org/xml/function/</a></p></td>
<td style="text-align: left;"><p>functions</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Additional functions</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><a
href="http://camel.apache.org/xml/variables/environment-variables">http://camel.apache.org/xml/variables/environment-variables</a></p></td>
<td style="text-align: left;"><p>env</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>OS environment variables</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><a
href="http://camel.apache.org/xml/variables/system-properties">http://camel.apache.org/xml/variables/system-properties</a></p></td>
<td style="text-align: left;"><p>system</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Java System properties</p></td>
</tr>
<tr>
<td style="text-align: left;"><p><a
href="http://camel.apache.org/xml/variables/exchange-property">http://camel.apache.org/xml/variables/exchange-property</a></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the exchange property</p></td>
</tr>
</tbody>
</table>

Camel will resolve variables according to either:

-   namespace given

-   no namespace given

## Namespace given

If the namespace is given, then Camel is instructed exactly what to
return. However, when resolving Camel will try to resolve a header with
the given local part first, and return it. If the local part has the
value **body,** then the body is returned instead.

## No namespace given

If there is no namespace given, then Camel resolves only based on the
local part. Camel will try to resolve a variable in the following steps:

-   from `variables` that has been set using the `variable(name, value)`
    fluent builder

-   from `message.in.header` if there is a header with the given key

-   from `exchange.properties` if there is a property with the given key

# Functions

Camel adds the following XPath functions that can be used to access the
exchange:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Function</th>
<th style="text-align: left;">Argument</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p>in:body</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Will return the message body.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>in:header</p></td>
<td style="text-align: left;"><p>the header name</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Will return the message
header.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>out:body</p></td>
<td style="text-align: left;"><p>none</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p><strong>deprecated</strong> Will return
the out message body.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>out:header</p></td>
<td style="text-align: left;"><p>the header name</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p><strong>deprecated</strong> Will return
the out message header.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>function:properties</p></td>
<td style="text-align: left;"><p>key for property</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>To use a <a
href="#manual:ROOT:using-propertyplaceholder.adoc">Property
Placeholder</a>.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>function:simple</p></td>
<td style="text-align: left;"><p>simple expression</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>To evaluate a <a
href="#simple-language.adoc">Simple</a> language.</p></td>
</tr>
</tbody>
</table>

`function:properties` and `function:simple` is not supported when the
return type is a `NodeSet`, such as when using with a
[Split](#eips:split-eip.adoc) EIP.

Here’s an example showing some of these functions in use.

## Functions example

If you prefer to configure your routes in your Spring XML file, then you
can use XPath expressions as follows

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="
           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
    
      <camelContext id="camel" xmlns="http://activemq.apache.org/camel/schema/spring"
                    xmlns:foo="http://example.com/person">
        <route>
          <from uri="activemq:MyQueue"/>
          <filter>
            <xpath>/foo:person[@name='James']</xpath>
            <to uri="mqseries:SomeOtherQueue"/>
          </filter>
        </route>
      </camelContext>
    </beans>

Notice how we can reuse the namespace prefixes, **foo** in this case, in
the XPath expression for easier namespace-based XPath expressions.

# Stream-based message bodies

If the message body is stream based, which means the input it receives
is submitted to Camel as a stream. That means you will only be able to
read the content of the stream **once**.

You often need to access the data multiple times when you use
[XPath](#xpath-language.adoc) as a [Message
Filter](#xpath-language.adoc) or Content-Based Router. Then, you should
use Stream Caching or convert the message body to a `String` prior,
which is safe to be re-read multiple times.

    from("queue:foo").
      filter().xpath("//foo").
      to("queue:bar")
    
    from("queue:foo").
      choice().xpath("//foo").to("queue:bar").
      otherwise().to("queue:others");

# Setting a result type

The XPath expression will return a result type using native XML objects
such as `org.w3c.dom.NodeList`. However, many times you want a result
type to be a `String`. To do this, you have to instruct the XPath which
result type to use.

In Java DSL:

    xpath("/foo:person/@id", String.class)

In XML DSL you use the **resultType** attribute to provide the fully
qualified classname.

    <xpath resultType="java.lang.String">/foo:person/@id</xpath>

Classes from `java.lang` can omit the FQN name, so you can use
`resultType="String"`

Using `@XPath` annotation:

    @XPath(value = "concat('foo-',//order/name/)", resultType = String.class) String name)

Where we use the xpath function concat to prefix the order name with
`foo-`. In this case we have to specify that we want a `String` as
result type, so the concat function works.

# Using XPath on Headers

Some users may have XML stored in a header. To apply an XPath to a
header’s value, you can do this by defining the *headerName* attribute.

    <xpath headerName="invoiceDetails">/invoice/@orderType = 'premium'</xpath>

And in Java DSL you specify the headerName as the second parameter as
shown:

    xpath("/invoice/@orderType = 'premium'", "invoiceDetails")

# Example

Here is a simple example using an XPath expression as a predicate in a
[Message Filter](#eips:filter-eip.adoc):

    from("direct:start")
        .filter().xpath("/person[@name='James']")
            .to("mock:result");

And in XML

    <route>
      <from uri="direct:start"/>
      <filter>
        <xpath>/person[@name='James']</xpath>
        <to uri="mock:result"/>
      </filter>
    </route>

# Using namespaces

If you have a standard set of namespaces you wish to work with and wish
to share them across many XPath expressions, you can use the
`org.apache.camel.support.builder.Namespaces` when using Java DSL as
shown:

    Namespaces ns = new Namespaces("c", "http://acme.com/cheese");
    
    from("direct:start")
        .filter(xpath("/c:person[@name='James']", ns))
            .to("mock:result");

Notice how the namespaces are provided to `xpath` with the `ns` variable
that are passed in as the second parameter.

Each namespace is a key=value pair, where the prefix is the key. In the
XPath expression then the namespace is used by its prefix, e.g.:

    /c:person[@name='James']

The namespace builder supports adding multiple namespaces as shown:

    Namespaces ns = new Namespaces("c", "http://acme.com/cheese")
                         .add("w", "http://acme.com/wine")
                         .add("b", "http://acme.com/beer");

When using namespaces in XML DSL then it is different, as you set up the
namespaces in the XML root tag (or one of the `camelContext`, `routes`,
`route` tags).

In the XML example below we use Spring XML where the namespace is
declared in the root tag `beans`, in the line with
`xmlns:foo="http://example.com/person"`:

    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:foo="http://example.com/person"
           xsi:schemaLocation="
           http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd
        ">
    
      <camelContext xmlns="http://camel.apache.org/schema/spring">
        <route>
          <from uri="direct:start"/>
          <filter>
            <xpath logNamespaces="true">/foo:person[@name='James']</xpath>
            <to uri="mock:result"/>
          </filter>
        </route>
      </camelContext>
    
    </beans>

This namespace uses `foo` as prefix, so the `<xpath>` expression uses
`foo:` to use this namespace.

# Using @XPath Annotation for Bean Integration

You can use [Bean Integration](#manual::bean-integration.adoc) to invoke
a method on a bean and use various languages such as `@XPath` to extract
a value from the message and bind it to a method parameter.

The default `@XPath` annotation has SOAP and XML namespaces available.

    public class Foo {
    
        @Consume(uri = "activemq:my.queue")
        public void doSomething(@XPath("/person/@name") String name, String xml) {
            // process the inbound message here
        }
    }

# Using XPathBuilder without an Exchange

You can now use the `org.apache.camel.language.xpath.XPathBuilder`
without the need for an `Exchange`. This comes handy if you want to use
it as a helper to do custom XPath evaluations.

It requires that you pass in a `CamelContext` since a lot of the moving
parts inside the `XPathBuilder` requires access to the Camel [Type
Converter](#manual:ROOT:type-converter.adoc) and hence why
`CamelContext` is needed.

For example, you can do something like this:

    boolean matches = XPathBuilder.xpath("/foo/bar/@xyz").matches(context, "<foo><bar xyz='cheese'/></foo>"));

This will match the given predicate.

You can also evaluate as shown in the following three examples:

    String name = XPathBuilder.xpath("foo/bar").evaluate(context, "<foo><bar>cheese</bar></foo>", String.class);
    Integer number = XPathBuilder.xpath("foo/bar").evaluate(context, "<foo><bar>123</bar></foo>", Integer.class);
    Boolean bool = XPathBuilder.xpath("foo/bar").evaluate(context, "<foo><bar>true</bar></foo>", Boolean.class);

Evaluating with a `String` result is a common requirement and make this
simpler:

    String name = XPathBuilder.xpath("foo/bar").evaluate(context, "<foo><bar>cheese</bar></foo>");

# Using Saxon with XPathBuilder

You need to add **camel-saxon** as dependency to your project.

It’s now easier to use [Saxon](http://saxon.sourceforge.net/) with the
XPathBuilder which can be done in several ways as shown below

-   Using a custom XPathFactory

-   Using ObjectModel

The easy one

## Setting a custom XPathFactory using System Property

Camel now supports reading the [JVM system property
`javax.xml.xpath.XPathFactory`](<http://java.sun.com/j2se/1.5.0/docs/api/javax/xml/xpath/XPathFactory.html#newInstance(java.lang.String)>)
that can be used to set a custom XPathFactory to use.

This unit test shows how this can be done to use Saxon instead:

Camel will log at `INFO` level if it uses a non-default `XPathFactory`
such as:

    XPathBuilder  INFO  Using system property javax.xml.xpath.XPathFactory:http://saxon.sf.net/jaxp/xpath/om with value:
                        net.sf.saxon.xpath.XPathFactoryImpl when creating XPathFactory

To use Apache Xerces, you can configure the system property

    -Djavax.xml.xpath.XPathFactory=org.apache.xpath.jaxp.XPathFactoryImpl

## Enabling Saxon from XML DSL

Similarly to Java DSL, to enable Saxon from XML DSL, you have three
options:

Referring to a custom factory:

    <xpath factoryRef="saxonFactory" resultType="java.lang.String">current-dateTime()</xpath>

And declare a bean with the factory:

    <bean id="saxonFactory" class="net.sf.saxon.xpath.XPathFactoryImpl"/>

Specifying the object model:

    <xpath objectModel="http://saxon.sf.net/jaxp/xpath/om" resultType="java.lang.String">current-dateTime()</xpath>

And the recommended approach is to set `saxon=true` as shown:

    <xpath saxon="true" resultType="java.lang.String">current-dateTime()</xpath>

# Namespace auditing to aid debugging

Many XPath-related issues that users frequently face are linked to the
usage of namespaces. You may have some misalignment between the
namespaces present in your message and those that your XPath expression
is aware of or referencing. XPath predicates or expressions that are
unable to locate the XML elements and attributes due to namespaces
issues may look like *they are not working*, when in reality all there
is to it is a lack of namespace definition.

Namespaces in XML are completely necessary, and while we would love to
simplify their usage by implementing some magic or voodoo to wire
namespaces automatically, the truth is that any action down this path
would disagree with the standards and would greatly hinder
interoperability.

Therefore, the utmost we can do is assist you in debugging such issues
by adding two new features to the XPath Expression Language and are thus
accessible from both predicates and expressions.

## Logging the Namespace Context of your XPath expression/predicate

Every time a new XPath expression is created in the internal pool, Camel
will log the namespace context of the expression under the
`org.apache.camel.language.xpath.XPathBuilder` logger. Since Camel
represents Namespace Contexts in a hierarchical fashion (parent-child
relationships), the entire tree is output in a recursive manner with the
following format:

    [me: {prefix -> namespace}, {prefix -> namespace}], [parent: [me: {prefix -> namespace}, {prefix -> namespace}], [parent: [me: {prefix -> namespace}]]]

Any of these options can be used to activate this logging:

-   Enable TRACE logging on the
    `org.apache.camel.language.xpath.XPathBuilder` logger, or some
    parent logger such as `org.apache.camel` or the root logger

-   Enable the `logNamespaces` option as indicated in the following
    section, in which case the logging will occur on the INFO level

## Auditing namespaces

Camel is able to discover and dump all namespaces present on every
incoming message before evaluating an XPath expression, providing all
the richness of information you need to help you analyze and pinpoint
possible namespace issues.

To achieve this, it in turn internally uses another specially tailored
XPath expression to extract all namespace mappings that appear in the
message, displaying the prefix and the full namespace URI(s) for each
mapping.

Some points to take into account:

-   The implicit XML namespace
    (`xmlns:xml="http://www.w3.org/XML/1998/namespace"`) is suppressed
    from the output because it adds no value

-   Default namespaces are listed under the `DEFAULT` keyword in the
    output

-   Keep in mind that namespaces can be remapped under different scopes.
    Think of a top-level *a* prefix which in inner elements can be
    assigned a different namespace, or the default namespace changing in
    inner scopes. For each discovered prefix, all associated URIs are
    listed.

You can enable this option in Java DSL and XML DSL:

Java DSL:

    XPathBuilder.xpath("/foo:person/@id", String.class).logNamespaces()

XML DSL:

    <xpath logNamespaces="true" resultType="String">/foo:person/@id</xpath>

The result of the auditing will be appeared at the INFO level under the
`org.apache.camel.language.xpath.XPathBuilder` logger and will look like
the following:

    2012-01-16 13:23:45,878 [stSaxonWithFlag] INFO  XPathBuilder  - Namespaces discovered in message:
    {xmlns:a=[http://apache.org/camel], DEFAULT=[http://apache.org/default],
    xmlns:b=[http://apache.org/camelA, http://apache.org/camelB]}

# Loading script from external resource

You can externalize the script and have Apache Camel load it from a
resource such as `"classpath:"`, `"file:"`, or `"http:"`. This is done
using the following syntax: `"resource:scheme:location"`, e.g., to refer
to a file on the classpath you can do:

    .setHeader("myHeader").xpath("resource:classpath:myxpath.txt", String.class)

# Transforming a XML message

For basic XML transformation where you have a fixed structure, you can
represent with a combination of using Camel simple and XPath language
as:

Given this XML body

    <order id="123">
      <item>Brake</item>
      <first>scott</first>
      <last>jackson</last>
      <address>
        <co>sweden</co>
        <zip>12345</zip>
      </address>
    </order>

Which you want to transform to a smaller structure:

    <user>
      <rool>123</rool>
      <country>sweden</country>
      <fullname>scott</fullname>
    </user>

Then you can use simple as template and XPath to grab the content from
the message payload, as shown in the route snippet below:

    from("direct:start")
            .transform().simple("""
                    <user>
                      <rool>${xpath(/order/@id)}</rool>
                      <country>${xpath(/order/address/co/text())}</country>
                      <fullname>${xpath(/order/first/text())}</fullname>
                    </user>""")
            .to("mock:result");

Notice how we use `${xpath(exp}` syntax in the simple template to use
xpath that will be evaluated on the message body, to extract the content
to be used in the output (see previous for output).

Since the simple language can output anything, you can also use this to
output in plain text or JSon, etc.

    from("direct:start")
            .transform().simple("The order ${xpath(/order/@id)} is being shipped to ${xpath(/order/address/co/text())}")
            .to("mock:result");

# Dependencies

To use XPath in your camel routes, you need to add the dependency on
**camel-xpath**, which implements the XPath language.

If you use Maven, you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-xpath</artifactId>
      <version>x.x.x</version>
    </dependency>
