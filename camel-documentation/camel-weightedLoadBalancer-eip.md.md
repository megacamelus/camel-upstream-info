# WeightedLoadBalancer-eip.md

Weighted mode for [Load Balancer](#loadBalance-eip.adoc) EIP. With this
policy in case of failures, the exchange will be tried on the next
endpoint.

# Options

# Exchange properties

# Examples

In this example, we want to send the most message to the first endpoint,
then the second, and only a few to the last.

The distribution ratio is `7 = 4 + 2 + 1`. This means that for every
seventh message then 4 goes to the first, 2 for the second, and 1 for
the last.

Java  
from("direct:start")
.loadBalance().weighted(false, "4,2,1")
.to("seda:x")
.to("seda:y")
.to("seda:z")
.end();

XML  
<route>  
<from uri="direct:start"/>  
<loadBalance>  
<weightedLoadBalancer distributionRatio="4 2 1"/>  
<to uri="seda:x"/>  
<to uri="seda:y"/>  
<to uri="seda:z"/>  
</loadBalance>  
</route>
