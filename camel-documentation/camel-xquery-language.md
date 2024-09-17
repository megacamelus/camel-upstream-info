# Xquery-language.md

**Since Camel 1.0**

Camel supports [XQuery](http://www.w3.org/TR/xquery/) to allow an
[Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc) to be used in the
[DSL](#manual::dsl.adoc).

For example, you could use XQuery to create a predicate in a [Message
Filter](#eips:filter-eip.adoc) or as an expression for a [Recipient
List](#eips:recipientList-eip.adoc).

# XQuery Language options

# Variables

The message body will be set as the `contextItem`. And the following
variables are available as well:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Variable</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>exchange</code></p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>The current Exchange</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>in.body</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>The message body</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>out.body</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p><strong>deprecated</strong> The OUT
message body (if any)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>in.headers.*</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>You can access the value of
exchange.in.headers with key <strong>foo</strong> by using the variable
which name is in.headers.foo</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>out.headers.*</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p><strong>deprecated</strong> You can
access the value of <code>exchange.out.headers</code> with key
<strong>foo</strong> by using the variable which name is
<code>out.headers.foo</code> variable</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>*key name*</code></p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>Any <code>exchange.properties</code>
and <code>exchange.in.headers</code> and any additional parameters set
using <code>setParameters(Map)</code>. These parameters are added with
their own key name, for instance, if there is an IN header with the key
name <strong>foo</strong> then it is added as
<strong>foo</strong>.</p></td>
</tr>
</tbody>
</table>

# Example

    from("queue:foo")
      .filter().xquery("//foo")
      .to("queue:bar")

You can also use functions inside your query, in which case you need an
explicit type conversion, or you will get an
`org.w3c.dom.DOMException: HIERARCHY_REQUEST_ERR`). You need to pass in
the expected output type of the function. For example, the concat
function returns a `String` which is done as shown:

    from("direct:start")
      .recipientList().xquery("concat('mock:foo.', /person/@city)", String.class);

And in XML DSL:

    <route>
      <from uri="direct:start"/>
      <recipientList>
        <xquery resultType="java.lang.String">concat('mock:foo.', /person/@city</xquery>
      </recipientList>
    </route>

## Using namespaces

If you have a standard set of namespaces you wish to work with and wish
to share them across many XQuery expressions, you can use the
`org.apache.camel.support.builder.Namespaces` when using Java DSL as
shown:

    Namespaces ns = new Namespaces("c", "http://acme.com/cheese");
    
    from("direct:start")
      .filter().xquery("/c:person[@name='James']", ns)
      .to("mock:result");

Notice how the namespaces are provided to `xquery` with the `ns`
variable that are passed in as the second parameter.

Each namespace is a key=value pair, where the prefix is the key. In the
XQuery expression then the namespace is used by its prefix, e.g.:

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
           http://camel.apache.org/schema/spring http://camel.apache.org/schema/spring/camel-spring.xsd">
    
      <camelContext id="camel" xmlns="http://activemq.apache.org/camel/schema/spring">
        <route>
          <from uri="activemq:MyQueue"/>
          <filter>
            <xquery>/foo:person[@name='James']</xquery>
            <to uri="mqseries:SomeOtherQueue"/>
          </filter>
        </route>
      </camelContext>
    </beans>

This namespace uses `foo` as prefix, so the `<xquery>` expression uses
`foo:` to use this namespace.

# Using XQuery as transformation

We can do a message translation using transform or setBody in the route,
as shown below:

    from("direct:start").
       transform().xquery("/people/person");

Notice that xquery will use DOMResult by default, so if we want to grab
the value of the person node, using `text()` we need to tell XQuery to
use String as the result type, as shown:

    from("direct:start").
       transform().xquery("/people/person/text()", String.class);

If you want to use Camel variables like headers, you have to explicitly
declare them in the XQuery expression.

    <transform>
        <xquery>
            declare variable $in.headers.foo external;
            element item {$in.headers.foo}
        </xquery>
    </transform>

# Loading script from external resource

You can externalize the script and have Apache Camel load it from a
resource such as `"classpath:"`, `"file:"`, or `"http:"`. This is done
using the following syntax: `"resource:scheme:location"`, e.g., to refer
to a file on the classpath you can do:

    .setHeader("myHeader").xquery("resource:classpath:myxquery.txt", String.class)

# Learning XQuery

XQuery is a very powerful language for querying, searching, sorting and
returning XML. For help learning XQuery, try these tutorials

-   Mike Kay’s [XQuery
    Primer](http://www.stylusstudio.com/xquery_primer.html)

-   The W3Schools [XQuery
    Tutorial](http://www.w3schools.com/xml/xquery_intro.asp)

# Dependencies

To use XQuery in your Camel routes, you need to add the dependency on
**camel-saxon**, which implements the XQuery language.

If you use Maven you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-saxon</artifactId>
      <version>x.x.x</version>
    </dependency>
