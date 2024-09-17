# Micrometer

**Since Camel 2.22**

**Only producer is supported**

The Micrometer component allows collecting various metrics directly from
Camel routes. Supported metric types are
[counter](##MicrometerComponent-counter),
[summary](##MicrometerComponent-summary), and
[timer](##MicrometerComponent-timer).
[Micrometer](http://micrometer.io/) provides a simple way to measure the
behaviour of an application. The configurable reporting backend (via
Micrometer registries) enables different integration options for
collecting and visualizing statistics.

The component also provides a `MicrometerRoutePolicyFactory` which
allows to expose route statistics using Micrometer as well as
`EventNotifier` implementations for counting routes and timing exchanges
from their creation to their completion.

Maven users need to add the following dependency to their `pom.xml` for
this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-micrometer</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    micrometer:[ counter | summary | timer ]:metricname[?options]

# Options

# Usage

## Meter Registry

By default the Camel Micrometer component creates a
`SimpleMeterRegistry` instance, suitable mainly for testing. You should
define a dedicated registry by providing a `MeterRegistry` bean.
Micrometer registries primarily determine the backend monitoring system
to be used. A `CompositeMeterRegistry` can be used to address more than
one monitoring target.

## Default Camel Metrics

Some Camel specific metrics are available out of the box.

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Type</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>camel.message.history</p></td>
<td style="text-align: left;"><p>timer</p></td>
<td style="text-align: left;"><p>Sample of performance of each node in
the route when message history is enabled</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>camel.routes.added</p></td>
<td style="text-align: left;"><p>gauge</p></td>
<td style="text-align: left;"><p>Number of routes in total</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>camel.routes.reloaded</p></td>
<td style="text-align: left;"><p>gauge</p></td>
<td style="text-align: left;"><p>Number of routes that has been
reloaded</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>camel.routes.running</p></td>
<td style="text-align: left;"><p>gauge</p></td>
<td style="text-align: left;"><p>Number of routes currently
running</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>camel.exchanges.inflight</p></td>
<td style="text-align: left;"><p>gauge</p></td>
<td style="text-align: left;"><p>Route inflight messages</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>camel.exchanges.total</p></td>
<td style="text-align: left;"><p>counter</p></td>
<td style="text-align: left;"><p>Total number of processed
exchanges</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>camel.exchanges.succeeded</p></td>
<td style="text-align: left;"><p>counter</p></td>
<td style="text-align: left;"><p>Number of successfully completed
exchanges</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>camel.exchanges.failed</p></td>
<td style="text-align: left;"><p>counter</p></td>
<td style="text-align: left;"><p>Number of failed exchanges</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p>camel.exchanges.failures.handled</p></td>
<td style="text-align: left;"><p>counter</p></td>
<td style="text-align: left;"><p>Number of failures handled</p></td>
</tr>
<tr class="even">
<td
style="text-align: left;"><p>camel.exchanges.external.redeliveries</p></td>
<td style="text-align: left;"><p>counter</p></td>
<td style="text-align: left;"><p>Number of external initiated
redeliveries (such as from JMS broker)</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>camel.exchange.event.notifier</p></td>
<td style="text-align: left;"><p>gauge + summary</p></td>
<td style="text-align: left;"><p>Metrics for messages created, sent,
completed, and failed events</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>camel.route.policy</p></td>
<td style="text-align: left;"><p>gauge + summary</p></td>
<td style="text-align: left;"><p>Route performance metrics</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>camel.route.policy.long.task</p></td>
<td style="text-align: left;"><p>gauge + summary</p></td>
<td style="text-align: left;"><p>Route long task metric</p></td>
</tr>
</tbody>
</table>

### Using legacy metrics naming

In Camel 3.20 or older, then the naming of metrics is using *camelCase*
style. However, since Camel 3.21 onwards, the naming is using the
Micrometer convention style (see table above).

To use the legacy naming, then you can use the `LEGACY` naming from the
`xxxNamingStrategy` interfaces.

For example:

    MicrometerRoutePolicyFactory factory = new MicrometerRoutePolicyFactory();
    factory.setNamingStrategy(MicrometerRoutePolicyNamingStrategy.LEGACY);

The naming style can be configured on:

-   `MicrometerRoutePolicyFactory`

-   `MicrometerExchangeEventNotifier`

-   `MicrometerRouteEventNotifier`

-   `MicrometerMessageHistoryFactory`

## Usage of producers

Each meter has type and name. Supported types are
[counter](##MicrometerComponent-counter), [distribution
summary](##MicrometerComponent-summary), and timer. If no type is
provided, then a counter is used by default.

The meter name is a string that is evaluated as `Simple` expression. In
addition to using the `CamelMetricsName` header (see below), this allows
selecting the meter depending on exchange data.

The optional `tags` URI parameter is a comma-separated string,
consisting of `key=value` expressions. Both `key` and `value` are
strings that are also evaluated as `Simple` expression. E.g., the URI
parameter `tags=X=${header.Y}` would assign the current value of header
`Y` to the key `X`.

### Headers

The meter name defined in URI can be overridden by populating a header
with name `CamelMetricsName`. The meter tags defined as URI parameters
can be augmented by populating a header with name `CamelMetricsTags`.

For example

    from("direct:in")
        .setHeader(MicrometerConstants.HEADER_METRIC_NAME, constant("new.name"))
        .setHeader(MicrometerConstants.HEADER_METRIC_TAGS, constant(Tags.of("dynamic-key", "dynamic-value")))
        .to("micrometer:counter:name.not.used?tags=key=value")
        .to("direct:out");

will update a counter with name `new.name` instead of `name.not.used`
using the tag `dynamic-key` with value `dynamic-value` in addition to
the tag `key` with value `value`.

All Metrics specific headers are removed from the message once the
Micrometer endpoint finishes processing of exchange. While processing
exchange Micrometer endpoint will catch all exceptions and write log
entry using level `warn`.

## Counter

    micrometer:counter:name[?options]

### Options

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>increment</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Double value to add to the
counter</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>decrement</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Double value to subtract from the
counter</p></td>
</tr>
</tbody>
</table>

If neither `increment` or `decrement` is defined then value of the
counter will be incremented by one. If `increment` and `decrement` are
both defined only increment operation is called.

    // update counter simple.counter by 7
    from("direct:in")
        .to("micrometer:counter:simple.counter?increment=7")
        .to("direct:out");
    
    // increment counter simple.counter by 1
    from("direct:in")
        .to("micrometer:counter:simple.counter")
        .to("direct:out");

Both `increment` and `decrement` values are evaluated as `Simple`
expressions with a Double result, e.g., if header `X` contains a value
that evaluates to 3.0, the `simple.counter` counter is decremented by
3\.0:

    // decrement counter simple.counter by 3
    from("direct:in")
        .to("micrometer:counter:simple.counter?decrement=${header.X}")
        .to("direct:out");

### Headers

Like in `camel-metrics`, specific Message headers can be used to
override `increment` and `decrement` values specified in the Micrometer
endpoint URI.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 79%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Expected type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>CamelMetricsCounterIncrement</p></td>
<td style="text-align: left;"><p>Override increment value in
URI</p></td>
<td style="text-align: left;"><p>Double</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>CamelMetricsCounterDecrement</p></td>
<td style="text-align: left;"><p>Override decrement value in
URI</p></td>
<td style="text-align: left;"><p>Double</p></td>
</tr>
</tbody>
</table>

    // update counter simple.counter by 417
    from("direct:in")
        .setHeader(MicrometerConstants.HEADER_COUNTER_INCREMENT, constant(417.0D))
        .to("micrometer:counter:simple.counter?increment=7")
        .to("direct:out");
    
    // updates counter using simple language to evaluate body.length
    from("direct:in")
        .setHeader(MicrometerConstants.HEADER_COUNTER_INCREMENT, simple("${body.length}"))
        .to("micrometer:counter:body.length")
        .to("direct:out");

## Distribution Summary

    micrometer:summary:metricname[?options]

### Options

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>value</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Value to use in histogram</p></td>
</tr>
</tbody>
</table>

If no `value` is not set, nothing is added to histogram and warning is
logged.

    // adds value 9923 to simple.histogram
    from("direct:in")
        .to("micrometer:summary:simple.histogram?value=9923")
        .to("direct:out");
    
    // nothing is added to simple.histogram; warning is logged
    from("direct:in")
        .to("micrometer:summary:simple.histogram")
        .to("direct:out");

`value` is evaluated as `Simple` expressions with a Double result, e.g.,
if header `X` contains a value that evaluates to 3.0, this value is
registered with the `simple.histogram`:

    from("direct:in")
        .to("micrometer:summary:simple.histogram?value=${header.X}")
        .to("direct:out");

### Headers

Like in `camel-metrics`, a specific Message header can be used to
override the value specified in the Micrometer endpoint URI.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 79%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Expected type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>CamelMetricsHistogramValue</p></td>
<td style="text-align: left;"><p>Override histogram value in
URI</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
</tbody>
</table>

    // adds value 992.0 to simple.histogram
    from("direct:in")
        .setHeader(MicrometerConstants.HEADER_HISTOGRAM_VALUE, constant(992.0D))
        .to("micrometer:summary:simple.histogram?value=700")
        .to("direct:out")

## Timer

    micrometer:timer:metricname[?options]

### Options

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>action</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>start or stop</p></td>
</tr>
</tbody>
</table>

If no `action` or invalid value is provided then warning is logged
without any timer update. If action `start` is called on an already
running timer or `stop` is called on an unknown timer, nothing is
updated and warning is logged.

    // measure time spent in route "direct:calculate"
    from("direct:in")
        .to("micrometer:timer:simple.timer?action=start")
        .to("direct:calculate")
        .to("micrometer:timer:simple.timer?action=stop");

`Timer.Sample` objects are stored as Exchange properties between
different Metrics component calls.

`action` is evaluated as a `Simple` expression returning a result of
type `MicrometerTimerAction`.

### Headers

Like in `camel-metrics`, a specific Message header can be used to
override action value specified in the Micrometer endpoint URI.

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 79%" />
<col style="width: 10%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Expected type</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>CamelMetricsTimerAction</p></td>
<td style="text-align: left;"><p>Override timer action in URI</p></td>
<td
style="text-align: left;"><p><code>org.apache.camel.component.micrometer.MicrometerTimerAction</code></p></td>
</tr>
</tbody>
</table>

    // sets timer action using header
    from("direct:in")
        .setHeader(MicrometerConstants.HEADER_TIMER_ACTION, MicrometerTimerAction.start)
        .to("micrometer:timer:simple.timer")
        .to("direct:out");

## Using Micrometer route policy factory

`MicrometerRoutePolicyFactory` allows to add a RoutePolicy for each
route to expose route utilization statistics using Micrometer. This
factory can be used in Java and XML as the examples below demonstrates.

Instead of using the `MicrometerRoutePolicyFactory` you can define a
dedicated `MicrometerRoutePolicy` per route you want to instrument, in
case you only want to instrument a few selected routes.

From Java, you add the factory to the `CamelContext` as shown below:

    context.addRoutePolicyFactory(new MicrometerRoutePolicyFactory());

And from XML DSL you define a \<bean\> as follows:

      <!-- use camel-micrometer route policy to gather metrics for all routes -->
      <bean id="metricsRoutePolicyFactory" class="org.apache.camel.component.micrometer.routepolicy.MicrometerRoutePolicyFactory"/>

The `MicrometerRoutePolicyFactory` and `MicrometerRoutePolicy` supports
the following options:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>prettyPrint</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to use pretty print when
outputting statistics in json format</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>meterRegistry</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Allow using a shared
<code>MeterRegistry</code>. If none is provided, then Camel will create
a shared instance used by the CamelContext.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>durationUnit</p></td>
<td style="text-align: left;"><p>TimeUnit.MILLISECONDS</p></td>
<td style="text-align: left;"><p>The unit to use for duration in when
dumping the statistics as json.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>configuration</p></td>
<td style="text-align: left;"><p>see below</p></td>
<td
style="text-align: left;"><p>MicrometerRoutePolicyConfiguration.class</p></td>
</tr>
</tbody>
</table>

The `MicrometerRoutePolicyConfiguration` supports the following options:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>contextEnabled</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>whether to include counter for context
level metrics</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>routeEnabled</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>whether to include counter for route
level metrics</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>additionalCounters</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>activates all additional
counters</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchangesSucceeded</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>activates counter for succeeded
exchanges</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>exchangesFailed</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>activates counter for failed
exchanges</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>exchangesTotal</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>activates counter for total count of
exchanges</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>externalRedeliveries</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>activates counter for redeliveries of
exchanges</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>failuresHandled</p></td>
<td style="text-align: left;"><p>true</p></td>
<td style="text-align: left;"><p>activates counter for handled
failures</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>longTask</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>activates long task timer (current
processing time for micrometer)</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>timerInitiator</p></td>
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"><p>Consumer&lt;Timer.Builder&gt; for
custom initialize Timer</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>longTaskInitiator</p></td>
<td style="text-align: left;"><p>null</p></td>
<td style="text-align: left;"><p>Consumer&lt;LongTaskTimer.Builder&gt;
for custom initialize LongTaskTimer</p></td>
</tr>
</tbody>
</table>

If JMX is enabled in the CamelContext, the MBean is registered in the
`type=services` tree with `name=MicrometerRoutePolicy`.

## Using Micrometer message history factory

`MicrometerMessageHistoryFactory` allows to use metrics to capture
Message History performance statistics while routing messages. It works
by using a Micrometer Timer for each node in all the routes. This
factory can be used in Java and XML as the examples below demonstrates.

From Java, you set the factory to the `CamelContext` as shown below:

    context.setMessageHistoryFactory(new MicrometerMessageHistoryFactory());

And from XML DSL you define a \<bean\> as follows:

      <!-- use camel-micrometer message history to gather metrics for all messages being routed -->
      <bean id="metricsMessageHistoryFactory" class="org.apache.camel.component.micrometer.messagehistory.MicrometerMessageHistoryFactory"/>

The following options are supported on the factory:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 33%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Default</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p>prettyPrint</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to use pretty print when
outputting statistics in json format</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>meterRegistry</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Allow using a shared
<code>MeterRegistry</code>. If none is provided, then Camel will create
a shared instance used by the CamelContext.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>durationUnit</p></td>
<td style="text-align: left;"><p>TimeUnit.MILLISECONDS</p></td>
<td style="text-align: left;"><p>The unit to use for duration when
dumping the statistics as json.</p></td>
</tr>
</tbody>
</table>

At runtime the metrics can be accessed from Java API or JMX, which
allows to gather the data as json output.

From Java code, you can get the service from the CamelContext as shown:

    MicrometerMessageHistoryService service = context.hasService(MicrometerMessageHistoryService.class);
    String json = service.dumpStatisticsAsJson();

If JMX is enabled in the CamelContext, the MBean is registered in the
`type=services` tree with `name=MicrometerMessageHistory`.

## Micrometer event notification

There is a `MicrometerRouteEventNotifier` (counting added and running
routes) and a `MicrometerExchangeEventNotifier` (timing exchanges from
their creation to their completion).

EventNotifiers can be added to the CamelContext, e.g.:

    camelContext.getManagementStrategy().addEventNotifier(new MicrometerExchangeEventNotifier())

At runtime the metrics can be accessed from Java API or JMX, which
allows to gather the data as json output.

From Java code, you can get the service from the CamelContext as shown:

    MicrometerEventNotifierService service = context.hasService(MicrometerEventNotifierService.class);
    String json = service.dumpStatisticsAsJson();

If JMX is enabled in the CamelContext, the MBean is registered in the
`type=services` tree with `name=MicrometerEventNotifier`.

## Instrumenting Camel thread pools

`InstrumentedThreadPoolFactory` allows you to gather performance
information about Camel Thread Pools by injecting a
`InstrumentedThreadPoolFactory` which collects information from the
inside of Camel. See more details at [Threading
Model](#manual::threading-model.adoc).

## Exposing Micrometer statistics in JMX

Micrometer uses `MeterRegistry` implementations to publish statistics.
While in production scenarios it is advisable to select a dedicated
backend like Prometheus or Graphite, it may be sufficient for test or
local deployments to publish statistics to JMX.

To achieve this, add the following dependency:

        <dependency>
          <groupId>io.micrometer</groupId>
          <artifactId>micrometer-registry-jmx</artifactId>
          <version>${micrometer-version}</version>
        </dependency>

and add a `JmxMeterRegistry` instance:

Java  
@Bean(name = MicrometerConstants.METRICS\_REGISTRY\_NAME)
public MeterRegistry getMeterRegistry() {
CompositeMeterRegistry meterRegistry = new CompositeMeterRegistry();
meterRegistry.add(...);
meterRegistry.add(new JmxMeterRegistry(
CamelJmxConfig.DEFAULT,
Clock.SYSTEM,
HierarchicalNameMapper.DEFAULT));
return meterRegistry;
}

CDI  
@Produces
@Named(MicrometerConstants.METRICS\_REGISTRY\_NAME))
public MeterRegistry getMeterRegistry() {
CompositeMeterRegistry meterRegistry = new CompositeMeterRegistry();
meterRegistry.add(...);
meterRegistry.add(new JmxMeterRegistry(
CamelJmxConfig.DEFAULT,
Clock.SYSTEM,
HierarchicalNameMapper.DEFAULT));
return meterRegistry;
}

The `HierarchicalNameMapper` strategy determines how meter name and tags
are assembled into an MBean name.

## Using Camel Micrometer with Camel Main

When you use Camel standalone (`camel-main`), then if you need to expose
metrics for Prometheus, then you can use `camel-micrometer-prometheus`
JAR. And easily enable and configure this from `application.properties`
as shown:

    # enable HTTP server with metrics
    camel.server.enabled=true
    camel.server.metricsEnabled=true
    
    # turn on micrometer metrics
    camel.metrics.enabled=true
    # include more camel details
    camel.metrics.enableMessageHistory=true
    # include additional out-of-the-box micrometer metrics for cpu, jvm and used file descriptors
    camel.metrics.binders=processor,jvm-info,file-descriptor

## Using Camel Micrometer with Spring Boot

When you use `camel-micrometer-starter` with Spring Boot, then Spring
Boot autoconfiguration will automatically enable metrics capture if a
`io.micrometer.core.instrument.MeterRegistry` is available.

For example, to capture data with Prometheus, you can add the following
dependency:

    <dependency>
        <groupId>io.micrometer</groupId>
        <artifactId>micrometer-registry-prometheus</artifactId>
    </dependency>

See the following table for options to specify what metrics to capture,
or to turn it off.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|metricsRegistry|To use a custom configured MetricRegistry.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|metricsType|Type of metrics||object|
|metricsName|Name of metrics||string|
|tags|Tags of metrics||object|
|action|Action expression when using timer type||string|
|decrement|Decrement value expression when using counter type||string|
|increment|Increment value expression when using counter type||string|
|metricsDescription|Description of metrics||string|
|value|Value expression when using histogram type||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
