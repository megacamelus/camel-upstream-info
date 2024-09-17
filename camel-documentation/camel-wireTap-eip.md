# WireTap-eip.md

[Wire Tap](http://www.enterpriseintegrationpatterns.com/WireTap.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) allows
you to route messages to a separate location while they are being
forwarded to the ultimate destination.

<figure>
<img src="eip/WireTap.gif" alt="image" />
</figure>

# Options

# Exchange properties

# Wire Tap

Camel’s Wire Tap will copy the original
[Exchange](#manual::exchange.adoc) and set its [Exchange
Pattern](#manual::exchange-pattern.adoc) to **`InOnly`**, as we want the
tapped [Exchange](#manual::exchange.adoc) to be sent in a fire and
forget style. The tapped [Exchange](#manual::exchange.adoc) is then sent
in a separate thread, so it can run in parallel with the original.
Beware that only the `Exchange` is copied - Wire Tap won’t do a deep
clone (unless you specify a custom processor via **`onPrepare`** which
does that). So all copies could share objects from the original
`Exchange`.

## Using Wire Tap

In the example below, the exchange is wire tapped to the direct:tap
route. This route delays message 1 second before continuing. This is
because it allows you to see that the tapped message is routed
independently of the original route, so that you would see log:result
happens before log:tap

Java  
from("direct:start")
.to("log:foo")
.wireTap("direct:tap")
.to("log:result");

    from("direct:tap")
        .delay(1000).setBody().constant("Tapped")
        .to("log:tap");

XML  
<routes>

      <route>
        <from uri="direct:start"/>
        <wireTap uri="direct:tap"/>
        <to uri="log:result"/>
      </route>
    
      <route>
        <from uri="direct:tap"/>
        <to uri="log:log"/>
      </route>
    
    </routes>

YAML  
\- from:
uri: direct:start
steps:
\- wireTap:
uri: direct:tap
\- to:
uri: log:result
\- from:
uri: direct:tap
steps:
\- to:
uri: log:log

## Wire tapping with dynamic URIs

For example, to wire tap to a dynamic URI, then the URI uses the
[Simple](#components:languages:simple-language.adoc) language that
allows to construct dynamic URIs.

For example, to wire tap to a JMS queue where the header ID is part of
the queue name:

Java  
from("direct:start")
.wireTap("jms:queue:backup-${header.id}")
.to("bean:doSomething");

XML  
<route>  
<from uri="direct:start"/>  
<wireTap uri="jms:queue:backup-${header.id}"/>  
<to uri="bean:doSomething"/>  
</route>

YAML  
\- from:
uri: direct:start
steps:
\- wireTap:
uri: jms:queue:backup-${header.id}
\- to:
uri: bean:doSomething

# WireTap Thread Pools

The WireTap uses a thread pool to process the tapped messages. This
thread pool will by default use the settings detailed in the [Threading
Model](#manual::threading-model.adoc).

In particular, when the pool is exhausted (with all threads used),
further wiretaps will be executed synchronously by the calling thread.
To remedy this, you can configure an explicit thread pool on the Wire
Tap having either a different rejection policy, a larger worker queue,
or more worker threads.

# Wire tapping Streaming based messages

If you Wire Tap a stream message body, then you should consider enabling
[Stream caching](#manual::stream-caching.adoc) to ensure the message
body can be read at each endpoint.

See more details at [Stream caching](#manual::stream-caching.adoc).
