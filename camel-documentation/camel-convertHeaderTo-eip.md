# ConvertHeaderTo-eip.md

The ConvertHeaderTo EIP allows you to transform message header to a
different type.

The type is a FQN class name (fully qualified), so for example
`java.lang.String`, `com.foo.MyBean` etc. However, Camel has shorthand
for common Java types, most noticeable `String` can be used instead of
`java.lang.String`. You can also use `byte[]` for a byte array.

# Exchange properties

# Example

For example, to convert the foo header to `String`:

Java  
from("seda:foo")
.convertHeaderTo("foo", String.class)
.log("The header content: ${header.foo}");

XML  
<route>  
<from uri="seda:foo"/>  
<convertHeaderTo name="foo" type="String"/>  
<log message="The header content: ${header.foo}"/>  
</route>

YAML  
\- from:
uri: seda:foo
steps:
\- convertHeaderTo:
name: foo
type: String
\- log:
message: "The header content: ${header.foo}"

## Convert to another header

By default, the converted value is replaced in the existing header.
However, you can tell Camel to store the result into another header,
such as shown below where the value is stored in the `bar` header:

Java  
from("seda:foo")
.convertHeaderTo("foo", "bar", String.class)
.log("The header content: ${header.bar}");

XML  
<route>  
<from uri="seda:foo"/>  
<convertHeaderTo name="foo" toName="bar" type="String"/>  
<log message="The header content: ${header.bar}"/>  
</route>

YAML  
\- from:
uri: seda:foo
steps:
\- convertHeaderTo:
name: foo
toName: bar
type: String
\- log:
message: "The header content: ${header.bar}"

## Dynamic header name

The ConvertHeaderTo supports using
[Simple](#components:languages:simple-language.adoc) language for
dynamic header name.

Suppose you have multiple headers:

-   `region`

-   `emea`

-   `na`

-   `pacific`

And that region points to either `emea`, `na` or `pacific`, which has
some order details. Then you can use dynamic header to convert the
header of choice. Now suppose that the region header has value `emea`:

Java  
from("seda:foo")
.convertHeaderTo("${header.region}", String.class)
.log("Order from EMEA: ${header.emea}");

XML  
<route>  
<from uri="seda:foo"/>  
<convertHeaderTo name="${header.region}" type="String"/>  
<log message="Order from EMEA: ${header.emea}"/>  
</route>

YAML  
\- from:
uri: seda:foo
steps:
\- convertHeaderTo:
name: ${header.region}
type: String
\- log:
message: "Order from EMEA: ${header.emea}"
