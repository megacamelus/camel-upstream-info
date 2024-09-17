# Process-manager.md

Camel supports the [Process
Manager](https://www.enterpriseintegrationpatterns.com/patterns/messaging/ProcessManager.html)
from the [EIP patterns](#enterprise-integration-patterns.adoc) book.

How do we route a message through multiple processing steps when the
required steps may not be known at design-time and may not be
sequential?

<figure>
<img src="eip/ProcessManager.gif" alt="image" />
</figure>

Use a central processing unit, a Process Manager, to maintain the state
of the sequence and determine the next processing step based on
intermediate results.

With Camel, this pattern is implemented by using the [Dynamic
Router](#dynamicRouter-eip.adoc) EIP. Camel’s implementation of the
dynamic router maintains the state of the sequence, and allows to
determine the next processing step based dynamically.

# Routing Slip vs. Dynamic Router

On the other hand, the [Routing Slip](#routingSlip-eip.adoc) EIP
demonstrates how a message can be routed through a dynamic series of
processing steps. The solution of the Routing Slip is based on two key
assumptions:

-   the sequence of processing steps has to be determined up-front

-   and the sequence is linear.

In many cases, these assumptions may not be fulfilled. For example,
routing decisions might have to be made based on intermediate results.
Or, the processing steps may not be sequential, but multiple steps might
be executed in parallel.
