# RemoveProperty-eip.md

The Remove Property EIP allows you to remove a single property from the
`Exchange`.

# Options

# Exchange properties

# Example

We want to remove an exchange property with key "myProperty" from the
exchange:

Java  
from("seda:b")
.removeProperty("myProperty")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeProperty name="myProperty"/>  
<to uri="mock:result"/>  
</route>

# See Also

Camel provides the following EIPs for removing headers or exchange
properties:

-   [Remove Header](#removeHeader-eip.adoc): To remove a single header

-   [Remove Headers](#removeHeaders-eip.adoc): To remove one or more
    message headers

-   [Remove Property](#removeProperty-eip.adoc): To remove a single
    exchange property

-   [Remove Properties](#removeProperties-eip.adoc): To remove one or
    more exchange properties
