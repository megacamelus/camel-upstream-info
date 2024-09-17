# SetVariable-eip.md

The SetVariable EIP is used for setting an
[Exchange](#manual:ROOT:exchange.adoc) variable.

# Options

# Exchange properties

# Example

The following example shows how to set a variable on the exchange in a
Camel route:

Java  
from("direct:a")
.setVariable("myVar", constant("test"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setVariable name="myVar">  
<constant>test</constant>  
</setVariable>  
<to uri="direct:b"/>  
</route>

## Setting an variable from a message header

You can also set a variable with the value from a message header.

Java  
from("direct:a")
.setVariable("foo", header("bar"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setVariable name="foo">  
<header>bar</header>  
</setVariable>  
<to uri="direct:b"/>  
</route>

## Setting variable with the current message body

It is of course also possible to set a variable with a value from
anything on the `Exchange` such as the message body:

Java  
from("direct:a")
.setVariable("myBody", body())
.to("direct:b");

XML  
We use the [Simple](#components:languages:simple-language.adoc) language
to refer to the message body:

    <route>
        <from uri="direct:a"/>
        <setVariable name="myBody">
            <simple>${body}</simple>
        </setVariable>
        <to uri="direct:b"/>
    </route>
