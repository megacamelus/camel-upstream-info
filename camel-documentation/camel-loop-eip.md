# Loop-eip.md

The Loop EIP allows for processing a message a number of times, possibly
in a different way for each iteration.

# Options

# Exchange properties

# Looping modes

The Loop EIP can run in three modes: default, copy, or while mode.

In default mode the Loop EIP uses the same `Exchange` instance
throughout the looping. So the result from the previous iteration will
be used for the next iteration.

In the copy mode, then the Loop EIP uses a copy of the original
`Exchange` in each iteration. So the result from the previous iteration
will **not** be used for the next iteration.

In the while mode, then the Loop EIP will keep looping until the
expression evaluates to `false` or `null`.

# Example

The following example shows how to take a request from the `direct:x`
endpoint, then send the message repetitively to `mock:result`.

The number of times the message is sent is either passed as an argument
to `loop`, or determined at runtime by evaluating an expression.

The [Expression](#manual::expression.adoc) **must** evaluate to an
`int`, otherwise a `RuntimeCamelException` is thrown.

Pass loop count as an argument:

Java  
from("direct:a")
.loop(8)
.to("mock:result");

XML  
<route>  
<from uri="direct:a"/>  
<loop>  
<constant>8</constant>  
<to uri="mock:result"/>  
</loop>  
</route>

Use expression to determine loop count:

Java  
from("direct:b")
.loop(header("loop"))
.to("mock:result");

XML  
<route>  
<from uri="direct:b"/>  
<loop>  
<header>loop</header>  
<to uri="mock:result"/>  
</loop>  
</route>

And with the [XPath](#languages:xpath-language.adoc) language:

    from("direct:c")
        .loop(xpath("/hello/@times"))
            .to("mock:result");

# Using copy mode

Now suppose we send a message to direct:start endpoint containing the
letter A. The output of processing this route will be that, each
mock:loop endpoint will receive AB as the message.

Java  
from("direct:start")
// instruct loop to use copy mode, which mean it will use a copy of the input exchange
// for each loop iteration, instead of keep using the same exchange all over
.loop(3).copy()
.transform(body().append("B"))
.to("mock:loop")
.end() // end loop
.to("mock:result");

XML  
<route>  
<from uri="direct:start"/>  
<!-- enable copy mode for loop eip -->  
<loop copy="true">  
<constant>3</constant>  
<transform>  
<simple>${body}B</simple>  
</transform>  
<to uri="mock:loop"/>  
</loop>  
<to uri="mock:result"/>  
</route>

However, if we do **not** enable copy mode, then mock:loop will receive
`_"AB"_`, `_"ABB"_`, `_"ABBB"_`, etc. messages.

# Looping using while

The loop can act like a while loop that loops until the expression
evaluates to `false` or `null`.

For example, the route below loops while the length of the message body
is five or fewer characters. Notice that the DSL uses `loopDoWhile`.

Java  
from("direct:start")
.loopDoWhile(simple("${body.length} \<= 5"))
.to("mock:loop")
.transform(body().append("A"))
.end() // end loop
.to("mock:result");

XML  
<route>  
<from uri="direct:start"/>  
<loop doWhile="true">  
<simple>${body.length} \<= 5</simple>  
<to uri="mock:loop"/>  
<transform>  
<simple>A${body}</simple>  
</transform>  
</loop>  
<to uri="mock:result"/>  
</route>

Notice that the while loop is turned on using the `doWhile` attribute.
