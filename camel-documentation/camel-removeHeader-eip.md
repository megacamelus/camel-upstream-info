# RemoveHeader-eip.md

The Remove Header EIP allows you to remove a single header from the
[Message](#message.adoc).

# Options

# Exchange properties

# Example

We want to remove a header with key "myHeader" from the message:

Java  
from("seda:b")
.removeHeader("myHeader")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeHeader name="myHeader"/>  
<to uri="mock:result"/>  
</route>

YAML  
\- from:
uri: seda:b
steps:
\- removeHeader:
name: myHeader
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
