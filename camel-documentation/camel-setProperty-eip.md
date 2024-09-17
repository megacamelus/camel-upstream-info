# SetProperty-eip.md

The SetProperty EIP is used for setting an
[Exchange](#manual:ROOT:exchange.adoc) property.

An `Exchange` property is a key/value set as a `Map` on the
`org.apache.camel.Exchange` instance. This is **not** for setting
[property placeholders](#manual:ROOT:using-propertyplaceholder.adoc).

# Options

# Exchange properties

# Example

The following example shows how to set a property on the exchange in a
Camel route:

Java  
from("direct:a")
.setProperty("myProperty", constant("test"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setProperty name="myProperty">  
<constant>test</constant>  
</setProperty>  
<to uri="direct:b"/>  
</route>

## Setting an exchange property from another exchange property

You can also set an exchange property with the value from another
exchange property.

In the example, we set the exchange property foo with the value from an
existing exchange property named bar.

Java  
from("direct:a")
.setProperty("foo", exchangeProperty("bar"))
.to("direct:b");

XML  
<route>  
<from uri="direct:a"/>  
<setProperty name="foo">  
<exchangeProperty>bar</exchangeProperty>  
</setProperty>  
<to uri="direct:b"/>  
</route>

## Setting an exchange property with the current message body

It is also possible to set an exchange property with a value from
anything on the `Exchange` such as the message body:

Java  
from("direct:a")
.setProperty("myBody", body())
.to("direct:b");

XML  
We use the [Simple](#components:languages:simple-language.adoc) language
to refer to the message body:

    <route>
        <from uri="direct:a"/>
        <setProperty name="myBody">
            <simple>${body}</simple>
        </setProperty>
        <to uri="direct:b"/>
    </route>
