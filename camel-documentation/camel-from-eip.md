# From-eip.md

Every Camel [route](#manual::routes.adoc) starts from an
[Endpoint](#manual::endpoint.adoc) as the input (source) to the route.

The `from` EIP is the input.

the Java DSL also provides a `fromF` EIP, which can be used to avoid
concatenating route parameters and making the code harder to read.

# Options

# Exchange properties

# Example

In the route below, the route starts from a
[File](#ROOT:file-component.adoc) endpoint.

Java  
from("file:inbox")
.to("log:inbox");

XML  
<route>  
<from uri="file:inbox"/>  
<to uri="log:inbox"/>  
</route>

YAML  
\- from:
uri: file:inbox
steps:
\- to:
uri: log:inbox
