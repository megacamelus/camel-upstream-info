# Fault-tolerance-eip.md

This component supports the [Circuit Breaker](#circuitBreaker-eip.adoc)
EIP with the [MicroProfile Fault
Tolerance](#others:microprofile-fault-tolerance.adoc) library.

# Options

The Fault Tolerance EIP supports two options which are listed below:

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 50%" />
<col style="width: 10%" />
<col style="width: 19%" />
</colgroup>
<thead>
<tr>
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: center;">Default</th>
<th style="text-align: left;">Type</th>
</tr>
</thead>
<tbody>
<tr>
<td
style="text-align: left;"><p><strong>faultToleranceConfiguration</strong></p></td>
<td style="text-align: left;"><p>Configure the Fault Tolerance EIP. When
the configuration is complete, use <code>end()</code> to return to the
Fault Tolerance EIP.</p></td>
<td style="text-align: center;"></td>
<td
style="text-align: left;"><p><code>FaultToleranceConfigurationDefinition</code></p></td>
</tr>
<tr>
<td
style="text-align: left;"><p><strong>faultToleranceConfigurationRef</strong></p></td>
<td style="text-align: left;"><p>Refers to a Fault Tolerance
configuration to use for configuring the Fault Tolerance EIP.</p></td>
<td style="text-align: center;"></td>
<td style="text-align: left;"><p>String</p></td>
</tr>
</tbody>
</table>

See [Fault Tolerance
Configuration](#faultToleranceConfiguration-eip.adoc) for all the
configuration options on the Fault Tolerance [Circuit
Breaker](#circuitBreaker-eip.adoc).

# Using Fault Tolerance EIP

Below is an example route showing a Fault Tolerance EIP circuit breaker
that protects against a downstream HTTP operation with fallback.

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

## Configuring Fault Tolerance

You can fine-tune the Fault Tolerance EIP by the many [Fault Tolerance
Configuration](#faultToleranceConfiguration-eip.adoc) options.

For example, to use a 2-second execution timeout, you can do as follows:

Java  
from("direct:start")
.circuitBreaker()
// use a 2-second timeout
.faultToleranceConfiguration().timeoutEnabled(true).timeoutDuration(2000).end()
.log("Fault Tolerance processing start: ${threadName}")
.to("http://fooservice.com/faulty")
.log("Fault Tolerance processing end: ${threadName}")
.end()
.log("After Fault Tolerance ${body}");

XML  
<route>  
<from uri="direct:start"/>  
<circuitBreaker>  
<faultToleranceConfiguration timeoutEnabled="true" timeoutDuration="2000"/>  
<log message="Fault Tolerance processing start: ${threadName}"/>  
<to uri="http://fooservice.com/faulty"/>  
<log message="Fault Tolerance processing end: ${threadName}"/>  
</circuitBreaker>  
<log message="After Fault Tolerance: ${body}"/>  
</route>

In this example, if calling the downstream service does not return a
response within 2 seconds, a timeout is triggered, and the exchange will
fail with a TimeoutException.

# Camel’s Error Handler and Circuit Breaker EIP

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
MicroProfile Fault Tolerance is one such implementation.

Maven users will need to add the following dependency to their pom.xml
to use this EIP:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-microprofile-fault-tolerance</artifactId>
        <version>x.x.x</version><!-- use the same version as your Camel core version -->
    </dependency>

## Using Fault Tolerance with Spring Boot

This component does not support Spring Boot. Instead, it is supported in
Standalone and with Camel Quarkus.
