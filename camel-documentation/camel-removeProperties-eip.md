# RemoveProperties-eip.md

The Remove Properties EIP allows you to remove one or more `Exchange`
properties, based on pattern syntax.

# Options

# Exchange properties

# Remove Exchange Properties by pattern

The Remove Properties EIP supports pattern matching by the following
rules in the given order:

-   match by exact name

-   match by wildcard

-   match by regular expression

# Remove all properties

Java  
from("seda:b")
.removeProperties("\*")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeProperties pattern="*"/>  
<to uri="mock:result"/>  
</route>

Be careful to remove all exchange properties as Camel uses internally
exchange properties to keep state on the `Exchange` during routing. So
use this with care. You should generally only remove custom exchange
properties that are under your own control.

# Remove properties by pattern

To remove all exchange properties that start with `Foo` then use `Foo*`
as shown:

Java  
from("seda:b")
.removeProperties("Foo\*")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeProperties pattern="Foo*"/>  
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
