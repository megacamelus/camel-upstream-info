# Pipeline-eip.md

Camel supports the [Pipes and
Filters](http://www.enterpriseintegrationpatterns.com/PipesAndFilters.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) in
various ways.

<figure>
<img src="eip/PipesAndFilters.gif" alt="image" />
</figure>

With Camel, you can separate your processing across multiple independent
[Endpoints](#manual::endpoint.adoc) which can then be chained together.

# Options

# Exchange properties

# Using pipeline

You can create pipelines of logic using multiple
[Endpoint](#manual::endpoint.adoc) or [Message
Translator](#message-translator.adoc) instances as follows:

Java  
from("activemq:cheese")
.pipeline()
.to("bean:foo")
.to("bean:bar")
.to("acitvemq:wine");

XML  
<route>  
<from uri="activemq:cheese"/>  
<pipeline>  
<to uri="bean:foo"/>  
<to uri="bean:bar"/>  
<to uri="activemq:wine"/>  
</pipeline>  
</route>

Though a pipeline is the default mode of operation when you specify
multiple outputs in Camel. Therefore, it’s much more common to see this
with Camel:

Java  
from("activemq:SomeQueue")
.to("bean:foo")
.to("bean:bar")
.to("activemq:OutputQueue");

XML  
<route>  
<from uri="activemq:cheese"/>  
<to uri="bean:foo"/>  
<to uri="bean:bar"/>  
<to uri="activemq:wine"/>  
</route>

## Pipeline vs Multicast

The opposite to `pipeline` is [`multicast`](#multicast-eip.adoc). A
[Multicast](#multicast-eip.adoc) EIP routes a copy of the same message
into each of its outputs, where these messages are processed
independently. Pipeline EIP, however, will route the same message
sequentially in the pipeline where the output from the previous step is
input to the next. The same principle from the Linux shell with chaining
commands together with pipe (`|`).

## When using a pipeline is necessary

Using a pipeline becomes necessary when you need to group together a
series of steps into a single logical step. For example, in the example
below where [Multicast](#multicast-eip.adoc) EIP is in use, to process
the same message in two different pipelines. The first pipeline calls
the something bean, and the second pipeline calls the foo and bar beans
and then routes the message to another queue.

Java  
from("activemq:SomeQueue")
.multicast()
.pipeline()
.to("bean:something")
.to("log:something")
.end()
.pipeline()
.to("bean:foo")
.to("bean:bar")
.to("activemq:OutputQueue")
.end()
.end() // ends multicast
.to("log:result");

Notice how we have to use `end()` to mark the end of the blocks.

XML  
<route>  
<from uri="activemq:SomeQueue"/>  
<multicast>  
<pipeline>  
<to uri="bean:something"/>  
<to uri="log:Something"/>  
</pipeline>  
<pipeline>  
<to uri="bean:foo"/>  
<to uri="bean:bar"/>  
<to uri="activemq:OutputQueue"/>  
</pipeline>  
</multicast>  
<to uri="log:result"/>  
</route>
