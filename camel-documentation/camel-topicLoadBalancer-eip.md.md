# TopicLoadBalancer-eip.md

Topic mode for the [Load Balancer](#loadBalance-eip.adoc) EIP. With this
policy, then all destinations are selected.

# Options

# Exchange properties

# Examples

In this example, we send the message to all three endpoints:

Java  
from("direct:start")
.loadBalance().topic()
.to("seda:x")
.to("seda:y")
.to("seda:z")
.end();

XML  
<route>  
<from uri="direct:start"/>  
<loadBalance>  
<topicLoadBalancer/>  
<to uri="seda:x"/>  
<to uri="seda:y"/>  
<to uri="seda:z"/>  
</loadBalance>  
</route>
