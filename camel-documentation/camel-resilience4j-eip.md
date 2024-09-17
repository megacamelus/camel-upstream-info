# Resilience4j-eip.md

The Resilience4j EIP provides integration with Resilience4j
[Resilience4j](https://resilience4j.readme.io/) to be used as [Circuit
Breaker](#circuitBreaker-eip.adoc) in the Camel routes.

# Configuration options

The Resilience4j EIP supports two options which are listed below:

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><strong>resilienceConfiguration</strong></p></td>
<td style="text-align: left;"><p>Configure the Resilience EIP. When the
configuration is complete, use <code>end()</code> to return to the
Resilience EIP.</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p>Resilience4jConfigurationDefinition</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p><strong>resilienceConfigurationRef</strong></p></td>
<td style="text-align: left;"><p>Refers to a Resilience configuration to
use for configuring the Resilience EIP.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

See [Resilience4j Configuration](#resilience4jConfiguration-eip.adoc)
for all the configuration options on Resilience [Circuit
Breaker](#circuitBreaker-eip.adoc).

# Using Resilience4j EIP

Below is an example route showing a Resilience4j circuit breaker that
protects against a downstream HTTP operation with fallback.

Java  
from("direct:start")
.circuitBreaker()
.to("http://fooservice.com/faulty")
.onFallback()
.transform().constant("Fallback message")
.end()
.to("mock:result");

XML  
<route>  
<from uri="direct:start"/>  
<circuitBreaker>  
<to uri="http://fooservice.com/faulty"/>  
<onFallback>  
<transform>  
<constant>Fallback message</constant>  
</transform>  
</onFallback>  
</circuitBreaker>  
<to uri="mock:result"/>  
</route>

In case the calling the downstream HTTP service is failing, and an
exception is thrown, then the circuit breaker will react and execute the
fallback route instead.

If there was no fallback, then the circuit breaker will throw an
exception.

For more information about fallback, see
[onFallback](#onFallback-eip.adoc).

## Configuring Resilience4j

You can fine-tune Resilience4j by the many [Resilience4j
Configuration](#resilience4jConfiguration-eip.adoc) options.

For example, to use a 2-second execution timeout, you can do as follows:

Java  
from("direct:start")
.circuitBreaker()
// use a 2-second timeout
.resilience4jConfiguration().timeoutEnabled(true).timeoutDuration(2000).end()
.log("Resilience processing start: ${threadName}")
.to("http://fooservice.com/faulty")
.log("Resilience processing end: ${threadName}")
.end()
.log("After Resilience ${body}");

XML  
<route>  
<from uri="direct:start"/>  
<circuitBreaker>  
<resilience4jConfiguration timeoutEnabled="true" timeoutDuration="2000"/>  
<log message="Resilience processing start: ${threadName}"/>  
<to uri="http://fooservice.com/faulty"/>  
<log message="Resilience processing end: ${threadName}"/>  
</circuitBreaker>  
<log message="After Resilience: ${body}"/>  
</route>

In this example if calling the downstream service does not return a
response within 2 seconds, a timeout is triggered, and the exchange will
fail with a `TimeoutException`.

## Camel’s Error Handler and Circuit Breaker EIP

By default, the [Circuit Breaker](#circuitBreaker-eip.adoc) EIP handles
errors by itself. This means if the circuit breaker is open, and the
message fails, then Camel’s error handler is not reacting also.

However, you can enable Camels error handler with circuit breaker by
enabling the `inheritErrorHandler` option, as shown:

    // Camel's error handler that will attempt to redeliver the message 3 times
    errorHandler(deadLetterChannel("mock:dead").maximumRedeliveries(3).redeliveryDelay(0));
    
    from("direct:start")
        .to("log:start")
        // turn on Camel's error handler on circuit breaker so Camel can do redeliveries
        .circuitBreaker().inheritErrorHandler(true)
            .to("mock:a")
            .throwException(new IllegalArgumentException("Forced"))
        .end()
        .to("log:result")
        .to("mock:result");

This example is from a test, where you can see the Circuit Breaker EIP
block has been hardcoded to always fail by throwing an exception.
Because the `inheritErrorHandler` has been enabled, then Camel’s error
handler will attempt to call the Circuit Breaker EIP block again.

That means the `mock:a` endpoint will receive the message again, and a
total of `1 + 3 = 4` message (first time + 3 redeliveries).

If we turn off the `inheritErrorHandler` option (default) then the
Circuit Breaker EIP will only be executed once because it handled the
error itself.

# Dependencies

Camel provides the [Circuit Breaker](#circuitBreaker-eip.adoc) EIP in
the route model, which allows to plug in different implementations.
Resilience4j is one such implementation.

Maven users will need to add the following dependency to their `pom.xml`
to use this EIP:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-resilience4j</artifactId>
        <version>x.x.x</version><!-- use the same version as your Camel core version -->
    </dependency>
