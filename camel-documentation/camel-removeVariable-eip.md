# RemoveVariable-eip.md

The Remove Variable EIP allows you to remove a single variable.

# Options

# Exchange properties

# Example

We want to remove a variable with key "myVar" from the exchange:

Java  
from("seda:b")
.removeVariable("myVar")
.to("mock:result");

XML  
<route>  
<from uri="seda:b"/>  
<removeVariable name="myVar"/>  
<to uri="mock:result"/>  
</route>

If you want to remove all variables from the `Exchange` then use `*` as
the name.
