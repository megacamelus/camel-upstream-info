# RandomLoadBalancer-eip.md

Random mode for the [Load Balancer](#loadBalance-eip.adoc) EIP.

The destination endpoints are selected randomly. This is a well-known
and classic policy, which spreads the load randomly.

# Exchange properties

# Example

We want to load balance between three endpoints in random mode.

This is done as follows:

Java  
from("direct:start")
.loadBalance().random()
.to("seda:x")
.to("seda:y")
.to("seda:z")
.end();

XML  
<route>  
<from uri="direct:start"/>  
<loadBalance>  
<randomLoadBalancer/>  
<to uri="seda:x"/>  
<to uri="seda:y"/>  
<to uri="seda:z"/>  
</loadBalance>  
</route>
