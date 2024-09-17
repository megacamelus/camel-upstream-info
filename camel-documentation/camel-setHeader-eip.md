# SetHeader-eip.md

The SetHeader EIP is used for setting a [message](#message.adoc) header.

# Options

# Exchange properties

# Using Set Header

The following example shows how to set a header in a Camel route:

Java  
from("direct:a")
.setHeader("myHeader", constant("test"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setHeader name="myHeader">  
<constant>test</constant>  
</setHeader>  
<to uri="direct:b"/>  
</route>

In the example, the header value is a
[constant](#components:languages:constant-language.adoc).

Any of the Camel languages can be used, such as
[Simple](#components:languages:simple-language.adoc).

Java  
from("direct:a")
.setHeader("randomNumber", simple("${random(1,100)}"))
.to("direct:b");

Header can be set using fluent syntax.

    from("direct:a")
        .setHeader("randomNumber").simple("${random(1,100)}")
        .to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setHeader name="randomNumber">  
<simple>${random(1,100)}</simple>  
</setHeader>  
<to uri="direct:b"/>  
</route>

See
[JSONPath](#components:languages:jsonpath-language.adoc#_using_header_as_input)
for another example.

## Setting a header from another header

You can also set a header with the value from another header.

In the example, we set the header foo with the value from an existing
header named bar.

Java  
from("direct:a")
.setHeader("foo", header("bar"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setHeader name="foo">  
<header>bar</header>  
</setHeader>  
<to uri="direct:b"/>  
</route>

If you need to set several headers on the message, see [Set
Headers](#eips:setHeaders-eip.adoc).
