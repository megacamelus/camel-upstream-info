# Datasonnet-language.md

**Since Camel 3.7**

Camel supports [DataSonnet](https://datasonnet.com/) transformations to
allow an [Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc) to be used in the
[DSL](#manual::dsl.adoc).

For example, you could use DataSonnet to create a Predicate in a
[Message Filter](#eips:filter-eip.adoc) or as an Expression for a
[Recipient List](#eips:recipientList-eip.adoc).

To use a DataSonnet expression, use the following Java code:

    datasonnet("someDSExpression");

# DataSonnet Options

# Example

Here is a simple example using a DataSonnet expression as a predicate in
a Message Filter:

Java  
// let's route if a line item is over $100
from("queue:foo")
.filter(datasonnet("ds.arrays.firstWith(body.lineItems, function(item) item \> 100) != null"))
.to("queue:bar");

XML  
<route>  
<from uri="queue:foo"/>  
<filter>  
<datasonnet>ds.arrays.firstWith(body.lineItems, function(item) item \> 100) != null</datasonnet>  
<to uri="queue:bar"/>  
</filter>  
</route>

Here is an example of a simple DataSonnet expression as a transformation
EIP. This example will transform an XML body with `lineItems` into JSON
while filtering out lines that are under 100.

Java  
from("queue:foo")
.transform(datasonnet("ds.filter(body.lineItems, function(item) item \> 100)", String.class, "application/xml", "application/json"))
.to("queue:bar");

XML  
<route>  
<from uri="queue:foo"/>  
<filter>  
<datasonnet bodyMediaType="application/xml" outputMediaType="application/json" resultTypeName="java.lang.String" >  
ds.filter(body.lineItems, function(item) item \> 100)
</datasonnet>
<to uri="queue:bar"/>
</filter>
</route>

# Setting a result type

The [DataSonnet](#datasonnet-language.adoc) expression will return a
`com.datasonnet.document.Document` by default. The document preserves
the content type metadata along with the contents of the transformation
result. In predicates, however, the Document will be automatically
unwrapped and the boolean content will be returned. Similarly, any time
you want the content in a specific result type like a String. To do
this, you have to instruct the [DataSonnet](#datasonnet-language.adoc)
which result type to return.

Java  
datasonnet("body.foo", String.class);

XML  
<datasonnet resultType="java.lang.String">body.foo</datasonnet>

In XML DSL you use the `resultType` attribute to provide a fully
qualified class name.

If the expression results in an array, or an object, you can instruct
the expression to return you `List.class` or `Map.class`, respectively.
However, you must also set the output media type to
`application/x-java-object`.

The default `Document` object is useful in situations where there are
intermediate transformation steps, and so retaining the content metadata
through a route execution is valuable.

# Specifying Media Types

Traditionally, the input and output media types are specified through
the [DataSonnet
Header](https://datasonnet.s3-us-west-2.amazonaws.com/docs-ci/primary/master/datasonnet/1.0-SNAPSHOT/headers.html).
The [DataSonnet](#datasonnet-language.adoc) expression provides
convenience options for specifying the body and output media types
without the need for a Header, this is useful if the transformation is a
one-liner, for example.

The DataSonnet expression will look for a body media type in the
following order:

1.  If the body is a `Document` it will use the metadata in the object

2.  If the bodyMediaType parameter was provided in the DSL, it will use
    its value

3.  A `CamelDatasonnetBodyMediaType` exchange property

4.  A `Content-Type` message header

5.  The DataSonnet Header payload media type directive

6.  `application/x-java-object`

And for output media type:

1.  If the outputMediaType parameter was provided in the DSL, it will
    use its value

2.  A "CamelDatasonnetOutputMediaType" exchange property

3.  A "CamelDatasonnetOutputMediaType" message header

4.  The DataSonnet Header output media type directive

5.  `application/x-java-object`

# Functions

Camel adds the following DataSonnet functions that can be used to access
the exchange:

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
<td style="text-align: left;"><p>cml.properties</p></td>
<td style="text-align: left;"><p>key for property</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>To look up a property using the <a
href="#ROOT:properties-component.adoc">Properties</a> component
(property placeholders).</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>cml.header</p></td>
<td style="text-align: left;"><p>the header name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Will return the message
header.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>cml.exchangeProperty</p></td>
<td style="text-align: left;"><p>key for property</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Will return the exchange
property.</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>cml.variable</p></td>
<td style="text-align: left;"><p>the variable name</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>Will return the exchange
variable.</p></td>
</tr>
</tbody>
</table>

Here’s an example showing some of these functions in use:

Java  
from("direct:in")
.setBody(datasonnet("'hello, ' + cml.properties('toGreet')", String.class))
.to("mock:camel");

XML  
<route>  
<from uri="direct:in"/>  
<setBody>  
<datasonnet resultTypeName="java.lang.String">'hello, ' + cml.properties('toGreet')</datasonnet>  
</setBody>  
<to uri="mock:camel"/>  
</route>

# Loading script from external resource

You can externalize the script and have Apache Camel load it from a
resource such as `"classpath:"`, `"file:"`, or `"http:"`.  
This is done using the following syntax: `"resource:scheme:location"`,
e.g., to refer to a file on the classpath you can do:

    .setHeader("myHeader").datasonnet("resource:classpath:mydatasonnet.ds");

# Dependencies

To use scripting languages in your camel routes, you need to add a
dependency on **camel-datasonnet**.

If you use Maven you could just add the following to your `pom.xml`,
substituting the version number for the latest and greatest release (see
the download page for the latest versions).

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-datasonnet</artifactId>
      <version>x.x.x</version>
    </dependency>
