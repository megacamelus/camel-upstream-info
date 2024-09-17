# Jsonpath-language.md

**Since Camel 2.13**

Camel supports [JSONPath](https://github.com/json-path/JsonPath/) to
allow using [Expression](#manual::expression.adoc) or
[Predicate](#manual::predicate.adoc) on JSON messages.

# JSONPath Options

# Usage

## JSONPath Syntax

Using the JSONPath syntax takes some time to learn, even for basic
predicates. So for example, to find out all the cheap books you have to
do:

    $.store.book[?(@.price < 20)]

## Easy JSONPath Syntax

However, what if you could just write it as:

    store.book.price < 20

And you can omit the path if you just want to look at nodes with a price
key:

    price < 20

To support this there is a `EasyPredicateParser` which kicks-in if you
have defined the predicate using a basic style. That means the predicate
must not start with the `$` sign, and only include one operator.

The easy syntax is:

    left OP right

You can use Camel simple language in the right operator, eg:

    store.book.price < ${header.limit}

See the [JSONPath](https://github.com/json-path/JsonPath) project page
for more syntax examples.

# Examples

For example, you can use JSONPath in a
[Predicate](#manual::predicate.adoc) with the [Content-Based
Router](#eips:choice-eip.adoc) EIP.

Java  
from("queue:books.new")
.choice()
.when().jsonpath("$.store.book\[?(@.price \< 10)\]")
.to("jms:queue:book.cheap")
.when().jsonpath("$.store.book\[?(@.price \< 30)\]")
.to("jms:queue:book.average")
.otherwise()
.to("jms:queue:book.expensive");

XML DSL  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<jsonpath>$.store.book\[?(@.price \< 10)\]</jsonpath>  
<to uri="mock:cheap"/>  
</when>  
<when>  
<jsonpath>$.store.book\[?(@.price \< 30)\]</jsonpath>  
<to uri="mock:average"/>  
</when>  
<otherwise>  
<to uri="mock:expensive"/>  
</otherwise>  
</choice>  
</route>

## Supported message body types

Camel JSONPath supports message body using the following types:

<table>
<colgroup>
<col style="width: 30%" />
<col style="width: 69%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Comment</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>File</code></p></td>
<td style="text-align: left;"><p>Reading from files</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>String</code></p></td>
<td style="text-align: left;"><p>Plain strings</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>Map</code></p></td>
<td style="text-align: left;"><p>Message bodies as
<code>java.util.Map</code> types</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>List</code></p></td>
<td style="text-align: left;"><p>Message bodies as
<code>java.util.List</code> types</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>POJO</code></p></td>
<td style="text-align: left;"><p><strong>Optional</strong> If Jackson is
on the classpath, then camel-jsonpath is able to use Jackson to read the
message body as POJO and convert to <code>java.util.Map</code> which is
supported by JSONPath. For example, you can add
<code>camel-jackson</code> as dependency to include Jackson.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>InputStream</code></p></td>
<td style="text-align: left;"><p>If none of the above types matches,
then Camel will attempt to read the message body as a
<code>java.io.InputStream</code>.</p></td>
</tr>
</tbody>
</table>

If a message body is of unsupported type, then an exception is thrown by
default. However, you can configure JSONPath to suppress exceptions (see
below)

## Suppressing exceptions

By default, jsonpath will throw an exception if the json payload does
not have a valid path accordingly to the configured jsonpath expression.
In some use-cases, you may want to ignore this in case the json payload
contains optional data. Therefore, you can set the option
`suppressExceptions` to `true` to ignore this as shown:

Java  
from("direct:start")
.choice()
// use true to suppress exceptions
.when().jsonpath("person.middlename", true)
.to("mock:middle")
.otherwise()
.to("mock:other");

XML DSL  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<jsonpath suppressExceptions="true">person.middlename</jsonpath>  
<to uri="mock:middle"/>  
</when>  
<otherwise>  
<to uri="mock:other"/>  
</otherwise>  
</choice>  
</route>

This option is also available on the `@JsonPath` annotation.

## Inline Simple expressions

It’s possible to inlined [Simple](#languages:simple-language.adoc)
language in the JSONPath expression using the simple syntax `${xxx}`.

An example is shown below:

Java  
from("direct:start")
.choice()
.when().jsonpath("$.store.book\[?(@.price \< ${header.cheap})\]")
.to("mock:cheap")
.when().jsonpath("$.store.book\[?(@.price \< ${header.average})\]")
.to("mock:average")
.otherwise()
.to("mock:expensive");

XML DSL  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<jsonpath>$.store.book\[?(@.price \< ${header.cheap})\]</jsonpath>  
<to uri="mock:cheap"/>  
</when>  
<when>  
<jsonpath>$.store.book\[?(@.price \< ${header.average})\]</jsonpath>  
<to uri="mock:average"/>  
</when>  
<otherwise>  
<to uri="mock:expensive"/>  
</otherwise>  
</choice>  
</route>

You can turn off support for inlined Simple expression by setting the
option `allowSimple` to `false` as shown:

Java  
.when().jsonpath("$.store.book\[?(@.price \< 10)\]", false, false)

XML DSL  
<jsonpath allowSimple="false">$.store.book\[?(@.price \< 10)\]</jsonpath>

## JSONPath injection

You can use [Bean Integration](#manual::bean-integration.adoc) to invoke
a method on a bean and use various languages such as JSONPath (via the
`@JsonPath` annotation) to extract a value from the message and bind it
to a method parameter, as shown below:

    public class Foo {
    
        @Consume("activemq:queue:books.new")
        public void doSomething(@JsonPath("$.store.book[*].author") String author, @Body String json) {
          // process the inbound message here
        }
    }

## Encoding Detection

The encoding of the JSON document is detected automatically, if the
document is encoded in unicode (UTF-8, UTF-16LE, UTF-16BE, UTF-32LE,
UTF-32BE) as specified in RFC-4627. If the encoding is a non-unicode
encoding, you can either make sure that you enter the document in String
format to JSONPath, or you can specify the encoding in the header
`CamelJsonPathJsonEncoding` which is defined as a constant in:
`JsonpathConstants.HEADER_JSON_ENCODING`.

## Split JSON data into sub rows as JSON

You can use JSONPath to split a JSON document, such as:

    from("direct:start")
        .split().jsonpath("$.store.book[*]", List.class)
        .to("log:book");

Notice how we specify `List.class` as the result-type. This is because
if there is only a single element (only 1 book), then jsonpath will
return the single entity as a `Map` instead of `List<Map>`. Therefore,
we tell Camel that the result should always be a `List`, and Camel will
then automatic wrap the single element into a new `List` object.

Then each book is logged, however the message body is a `Map` instance.
Sometimes you may want to output this as plain String JSON value
instead, which can be done with the `writeAsString` option as shown:

    from("direct:start")
        .split().jsonpathWriteAsString("$.store.book[*]", List.class)
        .to("log:book");

Then each book is logged as a String JSON value.

## Unpack a single-element array into an object

It is possible to unpack a single-element array into an object:

    from("direct:start")
        .setBody().jsonpathUnpack("$.store.book", Book.class)
        .to("log:book");

If a book array contains only one book, it will be converted into a Book
object.

## Using header as input

By default, JSONPath uses the message body as the input source. However,
you can also use a header as input by specifying the `headerName`
option.

For example, to count the number of books from a JSON document that was
stored in a header named `books` you can do:

    from("direct:start")
        .setHeader("numberOfBooks")
            .jsonpath("$..store.book.length()", false, int.class, "books")
        .to("mock:result");

In the `jsonpath` expression above we specify the name of the header as
`books`, and we also told that we wanted the result to be converted as
an integer by `int.class`.

The same example in XML DSL would be:

    <route>
      <from uri="direct:start"/>
      <setHeader name="numberOfBooks">
        <jsonpath headerName="books" resultType="int">$..store.book.length()</jsonpath>
      </setHeader>
      <to uri="mock:result"/>
    </route>

## Transforming a JSon message

For basic JSon transformation where you have a fixed structure, you can
represent with a combination of using Camel simple and JSonPath language
as:

    {
      "company": "${jsonpath($.customer.name)}",
      "location": "${jsonpath($.customer.address.country)}",
      "gold": ${jsonpath($.customer.orders.length() > 5)}
    }

Here we use the simple language to define the structure and use JSonPath
as inlined functions via the `${jsonpath(exp)}` syntax.

This makes it possible to use simple as a template language to define a
basic structure and then JSonPath to grab the data from an incoming JSon
message. The output of the transformation is also JSon, but with simple
you could also make it XML or plain text based:

    <customer gold="${jsonpath($.customer.orders.length() > 5)}">
        <company>${jsonpath($.customer.name)}</company>
        <location>${jsonpath($.customer.address.country)}</location>
    </customer>
