# Spel-language.md

**Since Camel 2.7**

Camel allows [Spring Expression Language
(SpEL)](https://docs.spring.io/spring/docs/current/spring-framework-reference/core.html#expressions)
to be used as an Expression or Predicate in the DSL or XML
Configuration.

It is recommended to use SpEL in Spring runtimes. Although you can use
SpEL in other runtimes, there is some functionality that SpEL can only
do in a Spring runtime.

# SpEL Options

# Variables

The following Camel related variables are made available:

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
<td style="text-align: left;"><p><strong>this</strong></p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange is the root
object</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>context</p></td>
<td style="text-align: left;"><p>CamelContext</p></td>
<td style="text-align: left;"><p>the CamelContext</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exchange</p></td>
<td style="text-align: left;"><p>Exchange</p></td>
<td style="text-align: left;"><p>the Exchange</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchangeId</p></td>
<td style="text-align: left;"><p>String</p></td>
<td style="text-align: left;"><p>the exchange id</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exception</p></td>
<td style="text-align: left;"><p>Throwable</p></td>
<td style="text-align: left;"><p>the Exchange exception (if
any)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>request</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>message</p></td>
<td style="text-align: left;"><p>Message</p></td>
<td style="text-align: left;"><p>the message</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>headers</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>the message headers</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>header(name)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the message header by the given
name</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>header(name, type)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>the message header by the given name as
the given type</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>properties</p></td>
<td style="text-align: left;"><p>Map</p></td>
<td style="text-align: left;"><p>the exchange properties</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>property(name)</p></td>
<td style="text-align: left;"><p>Object</p></td>
<td style="text-align: left;"><p>the exchange property by the given
name</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>property(name, type)</p></td>
<td style="text-align: left;"><p>Type</p></td>
<td style="text-align: left;"><p>the exchange property by the given name
as the given type</p></td>
</tr>
</tbody>
</table>

# Example

You can use SpEL as an expression for [Recipient
List](#eips:recipientList-eip.adoc) or as a predicate inside a [Message
Filter](#eips:filter-eip.adoc):

    <route>
      <from uri="direct:foo"/>
      <filter>
        <spel>#{request.headers.foo == 'bar'}</spel>
        <to uri="direct:bar"/>
      </filter>
    </route>

And the equivalent in Java DSL:

    from("direct:foo")
        .filter().spel("#{request.headers.foo == 'bar'}")
        .to("direct:bar");

## Expression templating

SpEL expressions need to be surrounded by `#{` `}` delimiters since
expression templating is enabled. This allows you to combine SpEL
expressions with regular text and use this as an extremely lightweight
template language.

For example, if you construct the following route:

    from("direct:example")
        .setBody(spel("Hello #{request.body}! What a beautiful #{request.headers['dayOrNight']}"))
        .to("mock:result");

In the route above, notice `spel` is a static method which we need to
import from `org.apache.camel.language.spel.SpelExpression.spel`, as we
use `spel` as an Expression passed in as a parameter to the `setBody`
method. Though if we use the fluent API, we can do this instead:

    from("direct:example")
        .setBody().spel("Hello #{request.body}! What a beautiful #{request.headers['dayOrNight']}")
        .to("mock:result");

Notice we now use the `spel` method from the `setBody()` method. And
this does not require us to statically import the `spel` method.

Then we send a message with the string "World" in the body, and a header
`dayOrNight` with value `day`:

    template.sendBodyAndHeader("direct:example", "World", "dayOrNight", "day");

The output on `mock:result` will be *"Hello World! What a beautiful
day"*

## Bean integration

You can reference beans defined in the
[Registry](#manual::registry.adoc) in your SpEL expressions. For
example, if you have a bean named "foo" registered in the Spring
`ApplicationContext`. You can then invoke the "bar" method on this bean
like this:

    #{@foo.bar == 'xyz'}

# Loading script from external resource

You can externalize the script and have Apache Camel load it from a
resource such as `"classpath:"`, `"file:"`, or `"http:"`. This is done
using the following syntax: `"resource:scheme:location"`, e.g., to refer
to a file on the classpath you can do:

    .setHeader("myHeader").spel("resource:classpath:myspel.txt")
