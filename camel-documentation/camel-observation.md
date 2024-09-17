# Observation.md

**Since Camel 3.21**

The Micrometer Observation component is used for performing
observability of incoming and outgoing Camel messages using [Micrometer
Observation](https://micrometer.io/docs/observation).

By configuring the `ObservationRegistry` you can add behaviour to your
observations such as metrics (e.g., via `Micrometer`) or tracing (e.g.,
via `OpenTelemetry` or `Brave`) or any custom behaviour.

Events are captured for incoming and outgoing messages being sent
to/from Camel.

# Configuration

The configuration properties for the Micrometer Observations are:

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
<td style="text-align: left;"><p>excludePatterns</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Sets exclude pattern(s) that will
disable tracing for Camel messages that matches the pattern. The content
is a Set&lt;String&gt; where the key is a pattern. The pattern uses the
rules from Intercept.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>encoding</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Sets whether the header keys need to be
encoded (connector specific) or not. The value is a boolean. Dashes
required for instances to be encoded for JMS property keys.</p></td>
</tr>
</tbody>
</table>

## Configuration

Include the `camel-opentelemetry` component in your POM, along with any
specific dependencies associated with the chosen OpenTelemetry compliant
Tracer.

To explicitly configure OpenTelemetry support, instantiate the
`OpenTelemetryTracer` and initialize the camel context. You can
optionally specify a `Tracer`, or alternatively it can be implicitly
discovered using the `Registry`

    ObservationRegistry observationRegistry = ObservationRegistry.create();
    MicrometerObservationTracer micrometerObservationTracer = new MicrometerObservationTracer();
    
    // This component comes from Micrometer Core - it's used for creation of metrics
    MeterRegistry meterRegistry = new SimpleMeterRegistry();
    
    // This component comes from Micrometer Tracing - it's an abstraction over tracers
    io.micrometer.tracing.Tracer otelTracer = otelTracer();
    // This component comes from Micrometer Tracing - an example of B3 header propagation via OpenTelemetry
    OtelPropagator otelPropagator = new OtelPropagator(ContextPropagators.create(B3Propagator.injectingSingleHeader()), tracer);
    
    // Configuration ObservationRegistry for metrics
    observationRegistry.observationConfig().observationHandler(new DefaultMeterObservationHandler(meterRegistry));
    
    // Configuration ObservationRegistry for tracing
    observationRegistry.observationConfig().observationHandler(new ObservationHandler.FirstMatchingCompositeObservationHandler(new CamelPropagatingSenderTracingObservationHandler<>(otelTracer, otelPropagator), new CamelPropagatingReceiverTracingObservationHandler<>(otelTracer, otelPropagator), new CamelDefaultTracingObservationHandler(otelTracer)));
    
    // Both components ObservationRegistry and MeterRegistry should be set manually, or they will be resolved from CamelContext if present
    micrometerObservationTracer.setObservationRegistry(observationRegistry);
    micrometerObservationTracer.setTracer(otelTracer);
    
    // Initialize the MicrometerObservationTracer
    micrometerObservationTracer.init(context);

# Spring Boot

If you are using Spring Boot, then you can add the
`camel-observation-starter` dependency, and turn on OpenTracing by
annotating the main class with `@CamelObservation`.

The `MicrometerObservationTracer` will be implicitly obtained from the
camel context’s `Registry`, unless a `MicrometerObservationTracer` bean
has been defined by the application.

# MDC Logging

When MDC Logging is enabled for the active Camel context the Trace ID
and Span ID will be added and removed from the MDC for each route, the
keys are `trace_id` and `span_id`, respectively.
