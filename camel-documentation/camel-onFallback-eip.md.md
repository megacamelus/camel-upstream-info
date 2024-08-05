# OnFallback-eip.md

If you are using **onFallback** then that is intended to be local
processing only where you can do a message transformation or call a bean
or something as the fallback.

If you need to call an external service over the network, then you
should use **onFallbackViaNetwork** that runs in another independent
**HystrixCommand** that uses its own thread pool to not exhaust the
first command.

# Options

# Exchange properties

# Using fallback

The **onFallback** is used by [Circuit
Breaker](#circuitBreaker-eip.adoc) EIPs to execute a fallback route. For
example, how to use this see the various Circuit Breaker
implementations:

-   [FaultTolerance EIP](#fault-tolerance-eip.adoc) - MicroProfile Fault
    Tolerance Circuit Breaker

-   [Resilience4j EIP](#resilience4j-eip.adoc) - Resilience4j Circuit
    Breaker
