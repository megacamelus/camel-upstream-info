# Stop-eip.md

How can I stop routing a message?

<figure>
<img src="eip/MessageExpirationIcon.gif" alt="image" />
</figure>

Use a special filter to mark the message to be stopped.

# Options

# Exchange properties

# Using Stop

We want to stop routing a message if the message body contains the word
Bye. In the [Content-Based Router](#choice-eip.adoc) below we use `stop`
in such a case.

Java  
from("direct:start")
.choice()
.when(body().contains("Hello")).to("mock:hello")
.when(body().contains("Bye")).to("mock:bye").stop()
.otherwise().to("mock:other")
.end()
.to("mock:result");

XML  
<route>  
<from uri="direct:start"/>  
<choice>  
<when>  
<simple>${body} contains 'Hello'</simple>  
<to uri="mock:hello"/>  
</when>  
<when>  
<simple>${body} contains 'Bye'</simple>  
<stop/>  
</when>  
<otherwise>  
<to uri="mock:other"/>  
</otherwise>  
</choice>  
</route>

## Calling stop from Java

You can also mark an `Exchange` to stop being routed from Java with the
following code:

    Exchange exchange = ...
    exchange.setRouteStop(true);
