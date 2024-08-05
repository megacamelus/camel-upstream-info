# Mvel-language.md

**Since Camel 2.0**

Camel supports [MVEL](http://mvel.documentnode.com/) to do message
transformations using MVEL templates.

MVEL is powerful for templates, but can also be used for
[Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc)

For example, you can use MVEL in a [Predicate](#manual::predicate.adoc)
with the [Content-Based Router](#eips:choice-eip.adoc) EIP.

You can use MVEL dot notation to invoke operations. If you for instance
have a body that contains a POJO that has a `getFamilyName` method then
you can construct the syntax as follows:

    request.body.familyName

Or use similar syntax as in Java:

    getRequest().getBody().getFamilyName()

# MVEL Options

# Variables

The following Camel related variables are made available:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Variable</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><p><strong>this</strong></p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange is the root
object</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>context</p></td>
<td style="text-align: left;"><p>CamelContext</p></td>
<td style="text-align: left;"><p>the CamelContext</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>exchange</p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>exchangeId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>the exchange id</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>exception</p></td>
<td style="text-align: left;"><p>Throwable</p></td>
<td style="text-align: left;"><p>the Exchange exception (if
any)</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>request</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>message</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>headers</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>the message headers</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>header(name)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the message header by the given
name</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>header(name, type)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>the message header by the given name as
the given type</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>properties</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>the exchange properties</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>property(name)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the exchange property by the given
name</p></td>
</tr>
<tr>
<td style="text-align: left;"><p>property(name, type)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>the exchange property by the given name
as the given type</p></td>
</tr>
</tbody>
</table>

# Example

For example, you could use MVEL inside a [Message
Filter](#eips:filter-eip.adoc)

    from("seda:foo")
      .filter().mvel("headers.foo == 'bar'")
        .to("seda:bar");

And in XML:

    <route>
      <from uri="seda:foo"/>
      <filter>
        <mvel>headers.foo == 'bar'</mvel>
        <to uri="seda:bar"/>
      </filter>
    </route>

# Loading script from external resource

You can externalize the script and have Apache Camel load it from a
resource such as `"classpath:"`, `"file:"`, or `"http:"`. This is done
using the following syntax: `"resource:scheme:location"`, e.g., to refer
to a file on the classpath you can do:

    .setHeader("myHeader").mvel("resource:classpath:script.mvel")

# Dependencies

To use MVEL in your Camel routes, you need to add the dependency on
**camel-mvel** which implements the MVEL language.

If you use Maven, you could add the following to your `pom.xml`,
substituting the version number for the latest \& greatest release.

    <dependency>
      <groupId>org.apache.camel</groupId>
      <artifactId>camel-mvel</artifactId>
      <version>x.x.x</version>
    </dependency>
