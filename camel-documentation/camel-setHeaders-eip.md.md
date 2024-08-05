# SetHeaders-eip.md

The SetHeaders EIP is used for setting multiple [message](#message.adoc)
headers at the same time.

# Options

# Exchange properties

# Using Set Headers

The following example shows how to set multiple headers in a Camel route
using Java, XML or YAML. Note that the syntax is slightly different in
each case.

Java  
from("direct:a")
.setHeaders("myHeader", constant("test"), "otherHeader", constant("other"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setHeaders>  
<setHeader name="myHeader">  
<constant>test</constant>  
</setHeader>  
<setHeader name="otherHeader">  
<constant>other</constant>  
</setHeader>  
</setHeaders>  
<to uri="direct:b"/>  
</route>

YAML  
\- from:
uri: direct:a
steps:
\- setHeaders:
headers:
\- name: myHeader
constant: test
\- name: otherHeader
constant: other
\- to:
uri:direct:b

For example, the header values are
[constants](#components:languages:constant-language.adoc).

Any of the Camel languages can be used, such as
[Simple](#components:languages:simple-language.adoc).

Java  
from("direct:a")
.setHeaders("randomNumber", simple("${random(1,100)}"), "body", simple("${body}"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setHeaders>  
<setHeader name="randomNumber">  
<simple>${random(1,100)}</simple>  
</setHeader>  
<setHeader name="body">  
<simple>${body}</simple>  
</setHeader>  
</setHeaders>  
<to uri="direct:b"/>  
</route>

YAML  
\- from:
uri: direct:a
steps:
\- setHeaders:
headers:
\- name: randomNumber
simple: "${random(1,100)}"
\- name: body
simple: "${body}"
\- to:
uri:direct:b

## Setting a header from another header

You can also set several headers where later ones depend on earlier
ones.

In the example, we first set the header foo to the body and then set bar
based on comparing foo with a value.

Java  
from("direct:a")
.setHeaders("foo", simple("${body}"), "bar", simple("${header.foo} \> 10", Boolean.class))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setHeaders>  
<setHeader name="foo">  
<simple>${body}</simple>  
</setHeader>  
<setHeader name="bar">  
<simple resultType="java.lang.Boolean">${header.foo} \> 10</simple>  
</setHeader>  
</setHeaders>  
<to uri="direct:b"/>  
</route>

YAML  
\- from:
uri: direct:a
steps:
\- setHeaders:
headers:
\- name: foo
simple: "${body}"
\- name: bar
simple:
expression: "${header.foo} \> 10"
resultType: "boolean"
\- to:
uri:direct:b

## Using a Map with Java DSL

It’s also possible to build a Map and pass it as the single argument to
`setHeaders().` If the order in which the headers should be set is
important, use a `LinkedHashMap`.

Java  
private Map\<String, Expression\> headerMap = new java.util.LinkedHashMap\<\>();
headerMap.put("foo", ConstantLanguage.constant("ABC"));
headerMap.put("bar", ConstantLanguage.constant("XYZ"));

    from("direct:startMap")
        .setHeaders(headerMap)
        .to("direct:b");

If the ordering is not critical, then
`Map.of(name1, expr1, name2, expr2...)` can be used.

Java  
from("direct:startMap")
.setHeaders(Map.of("foo", "ABC", "bar", "XYZ"))
.to("direct:b");
