# Opentelemetry.md

**Since Camel 3.5**

The OpenTelemetry component is used for tracing and timing incoming and
outgoing Camel messages using
[OpenTelemetry](https://opentelemetry.io/).

Events (spans) are captured for incoming and outgoing messages being
sent to/from Camel.

# Configuration

The configuration properties for the OpenTelemetry tracer are:

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 79%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Option</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td
style="text-align: left;"><p><code>instrumentationName</code></p></td>
<td style="text-align: left;"><p>camel</p></td>
<td style="text-align: left;"><p>A name uniquely identifying the
instrumentation scope, such as the instrumentation library, package, or
fully qualified class name. Must not be null.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>excludePatterns</code></p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets exclude pattern(s) that will
disable tracing for Camel messages that matches the pattern. The content
is a Set&lt;String&gt; where the key is a pattern. The pattern uses the
rules from Intercept.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><code>encoding</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Sets whether the header keys need to be
encoded (connector specific) or not. The value is a boolean. Dashes are
required for instances to be encoded for JMS property keys.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>traceProcessors</code></p></td>
<td style="text-align: left;"><p><code>false</code></p></td>
<td style="text-align: left;"><p>Setting this to true will create new
OpenTelemetry Spans for each Camel Processors. Use the excludePattern
property to filter out Processors</p></td>
</tr>
</tbody>
</table>

# Using Camel OpenTelemetry

Include the `camel-opentelemetry` component in your POM, along with any
specific dependencies associated with the chosen OpenTelemetry compliant
Tracer.

To explicitly configure OpenTelemetry support, instantiate the
`OpenTelemetryTracer` and initialize the camel context. You can
optionally specify a `Tracer`, or alternatively it can be implicitly
discovered using the `Registry`

    OpenTelemetryTracer otelTracer = new OpenTelemetryTracer();
    // By default, it uses the DefaultTracer, but you can override it with a specific OpenTelemetry Tracer implementation.
    otelTracer.setTracer(...);
    // And then initialize the context
    otelTracer.init(camelContext);

You would still need OpenTelemetry to instrument your code, which can be
done via a [Java agent](#OpenTelemetry-JavaAgent).

## Using with standalone Camel

If you use `camel-main` as standalone Camel, then you can enable and use
OpenTelemetry without Java code.

Add `camel-opentelemetry` component in your POM, and configure in
`application.properties`:

    camel.opentelemetry.enabled = true
    # you can configure the other options
    # camel.opentelemetry.instrumentationName = myApp

You would still need OpenTelemetry to instrument your code, which can be
done via a [Java agent](#OpenTelemetry-JavaAgent).

# Spring Boot

If you are using Spring Boot, then you can add the
`camel-opentelemetry-starter` dependency, and turn on OpenTelemetry by
annotating the main class with `@CamelOpenTelemetry`.

The `OpenTelemetryTracer` will be implicitly obtained from the camel
context’s `Registry`, unless a `OpenTelemetryTracer` bean has been
defined by the application.

# Java Agent

Download the [latest
version](https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/).

This package includes the instrumentation agent as well as
instrumentation for all supported libraries and all available data
exporters. The package provides a completely automatic, out-of-the-box
experience.

Enable the instrumentation agent using the `-javaagent` flag to the JVM.

    java -javaagent:path/to/opentelemetry-javaagent.jar \
         -jar myapp.jar

By default, the OpenTelemetry Java agent uses [OTLP
exporter](https://github.com/open-telemetry/opentelemetry-java/tree/main/exporters/otlp)
configured to send data to [OpenTelemetry
collector](https://github.com/open-telemetry/opentelemetry-collector/blob/main/receiver/otlpreceiver/README.md)
at `http://localhost:4318`.

Configuration parameters are passed as Java system properties (`-D`
flags) or as environment variables. See [the configuration
documentation](https://github.com/open-telemetry/opentelemetry-java-instrumentation/blob/main/docs/agent-config.md)
for the full list of configuration items. For example:

    java -javaagent:path/to/opentelemetry-javaagent.jar \
         -Dotel.service.name=your-service-name \
         -Dotel.traces.exporter=otlp \
         -jar myapp.jar

# MDC Logging

When MDC Logging is enabled for the active Camel context the Trace ID
and Span ID will be added and removed from the MDC for each route, the
keys are `trace_id` and `span_id`, respectively.
