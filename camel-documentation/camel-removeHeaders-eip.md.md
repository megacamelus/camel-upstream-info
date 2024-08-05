# RemoveHeaders-eip.md

The Remove Headers EIP allows you to remove one or more headers from the
[Message](#message.adoc), based on pattern syntax.

# Options

# Exchange properties

# Remove Headers by pattern

The Remove Headers EIP supports pattern matching by the following rules
in the given order:

-   match by exact name

-   match by wildcard

-   match by regular expression

# Remove all headers

To remove all headers you can use `*` as the pattern:

Java  
from("seda:b")
.removeHeaders("\*")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeHeaders pattern="*"/>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:b
steps:
\- removeHeaders: "\*"
\- to:
uri: mock:result

# Remove all Camel headers

To remove all headers that start with `Camel` then use `Camel*` as
shown:

Java  
from("seda:b")
.removeHeaders("Camel\*")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeHeaders pattern="Camel*"/>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:b
steps:
\- removeHeaders: "Camel\*"
\- to:
uri: mock:result

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
