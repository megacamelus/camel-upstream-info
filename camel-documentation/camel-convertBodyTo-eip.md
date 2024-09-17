# ConvertBodyTo-eip.md

The ConvertBodyTo EIP allows you to transform the message body to a
different type.

The type is a FQN class name (fully qualified), so for example
`java.lang.String`, `com.foo.MyBean` etc. However, Camel has shorthand
for common Java types, most noticeable `String` can be used instead of
`java.lang.String`. You can also use `byte[]` for a byte array.

# Exchange properties

# Example

A common use-case is for converting the message body to a `String`:

Java  
from("file:inbox")
.convertBodyTo(String.class)
.log("The file content: ${body}");

XML  
<route>  
<from uri="file:inbox"/>  
<convertBodyTo type="String"/>  
<log message="The file content: ${body}"/>  
</route>

YAML  
\- from:
uri: file:inbox
steps:
\- convertBodyTo:
type: String
\- log:
message: "The file content: ${body}"
