# StickyLoadBalancer-eip.md

Sticky mode for the [Load Balancer](#loadBalance-eip.adoc) EIP.

A stick mode means that a correlation key (calculated as
[Expression](#manual::expression.adoc)) is used to determine the
destination. This allows routing all messages with the same key to the
same destination.

# Options

# Exchange properties

# Examples

In this case, we are using the header myKey as correlation expression:

Java  
from("direct:start")
.loadBalance().sticky(header("myKey"))
.to("seda:x")
.to("seda:y")
.to("seda:z")
.end();

XML  
<route>  
<from uri="direct:start"/>  
<loadBalance>  
<stickyLoadBalancer>  
<correlationExpression>  
<header>myKey</header>  
</correlationExpression>  
</stickyLoadBalancer>  
<to uri="seda:x"/>  
<to uri="seda:y"/>  
<to uri="seda:z"/>  
</loadBalance>  
</route>
