# ConvertVariableTo-eip.md

The ConvertVariableTo EIP allows you to convert a variable to a
different type.

The type is a FQN class name (fully qualified), so for example
`java.lang.String`, `com.foo.MyBean` etc. However, Camel has shorthand
for common Java types, most noticeable `String` can be used instead of
`java.lang.String`. You can also use `byte[]` for a byte array.

# Exchange properties

# Example

For example, to convert the foo variable to `String`:

Java  
from("seda:foo")
.convertVariableTo("foo", String.class)
.log("The variable content: ${variable.foo}");

XML  
<route>  
<from uri="seda:foo"/>  
<convertVariableTo name="foo" type="String"/>  
<log message="The variable content: ${variable.foo}"/>  
</route>

YAML  
\- from:
uri: seda:foo
steps:
\- convertVariableTo:
name: foo
type: String
\- log:
message: "The variable content: ${variable.foo}"

## Convert to another variable

By default, the converted value is replaced in the existing variable.
However, you can tell Camel to store the result into another variable,
such as shown below where the value is stored in the `bar` variable:

Java  
from("seda:foo")
.convertVariableTo("foo", "bar", String.class)
.log("The variable content: ${variable.bar}");

XML  
<route>  
<from uri="seda:foo"/>  
<convertVariableTo name="foo" toName="bar" type="String"/>  
<log message="The variable content: ${variable.bar}"/>  
</route>

YAML  
\- from:
uri: seda:foo
steps:
\- convertVariableTo:
name: foo
toName: bar
type: String
\- log:
message: "The variable content: ${variable.bar}"

## Dynamic variable name

The ConvertVariableTo supports using
[Simple](#components:languages:simple-language.adoc) language for
dynamic variable name.

Suppose you have multiple variables:

-   `region`

-   `emea`

-   `na`

-   `pacific`

And that region points to either `emea`, `na` or `pacific` which has
some order details. Then you can use dynamic variable to convert the
header of choice. Now suppose that the region variable has value `emea`:

Java  
from("seda:foo")
.convertVariableTo("${variable.region}", String.class)
.log("Order from EMEA: ${variable.emea}");

XML  
<route>  
<from uri="seda:foo"/>  
<convertVariableTo name="${variable.region}" type="String"/>  
<log message="Order from EMEA: ${variable.emea}"/>  
</route>

YAML  
\- from:
uri: seda:foo
steps:
\- convertVariableTo:
name: ${variable.region}
type: String
\- log:
message: "Order from EMEA: ${variable.emea}"
