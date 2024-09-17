# Metrics

**Since Camel 2.14**

**Only producer is supported**

The Metrics component allows collecting various metrics directly from
Camel routes. Supported metric types are
[counter](##MetricsComponent-counter),
[histogram](##MetricsComponent-histogram),
[meter](##MetricsComponent-meter), [timer](##MetricsComponent-timer) and
[gauge](##MetricsComponent-gauge).
[Metrics](http://metrics.dropwizard.io) provides a simple way to measure
the behaviour of applications. The configurable reporting backend
enables different integration options for collecting and visualizing
statistics. The component also provides a `MetricsRoutePolicyFactory`
which allows exposing route statistics using Dropwizard Metrics, see
bottom of page for details.

Maven users will need to add the following dependency to their `pom.xml`
for this component:

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-metrics</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel core version -->
    </dependency>

# URI format

    metrics:[ meter | counter | histogram | timer | gauge ]:metricname[?options]

# Metric Registry

Camel Metrics component uses by default a `MetricRegistry` instance with
a `Slf4jReporter` that has a 60-second reporting interval. This default
registry can be replaced with a custom one by providing a
`MetricRegistry` bean. If multiple `MetricRegistry` beans exist in the
application, the one with name `metricRegistry` is used.

For example:

Java (Spring)  
@Configuration
public static class MyConfig extends SingleRouteCamelConfiguration {

        @Bean
        @Override
        public RouteBuilder route() {
            return new RouteBuilder() {
                @Override
                public void configure() throws Exception {
                    // define Camel routes here
                }
            };
        }
    
        @Bean(name = MetricsComponent.METRIC_REGISTRY_NAME)
        public MetricRegistry getMetricRegistry() {
            MetricRegistry registry = ...;
            return registry;
        }
    }

Java (CDI)  
class MyBean extends RouteBuilder {

        @Override
        public void configure() {
          from("...")
              // Register the 'my-meter' meter in the MetricRegistry below
              .to("metrics:meter:my-meter");
        }
    
        @Produces
        // If multiple MetricRegistry beans
        // @Named(MetricsComponent.METRIC_REGISTRY_NAME)
        MetricRegistry registry() {
            MetricRegistry registry = new MetricRegistry();
            // ...
            return registry;
        }
    }

# Usage

Each metric has type and name. Supported types are
[counter](##MetricsComponent-counter),
[histogram](##MetricsComponent-histogram),
[meter](##MetricsComponent-meter), [timer](##MetricsComponent-timer) and
[gauge](##MetricsComponent-gauge). Metric name is simple string. If a
metric type is not provided, then type meter is used by default.

## Headers

Metric name defined in URI can be overridden by using header with name
`CamelMetricsName`.

For example

    from("direct:in")
        .setHeader(MetricsConstants.HEADER_METRIC_NAME, constant("new.name"))
        .to("metrics:counter:name.not.used")
        .to("direct:out");

will update counter with name `new.name` instead of `name.not.used`.

All Metrics specific headers are removed from the message once Metrics
endpoint finishes processing of exchange. While processing exchange
Metrics endpoint will catch all exceptions and write log entry using
level `warn`.

## Metrics type counter

    metrics:counter:metricname[?options]

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
<td style="text-align: left;"><p>Long value to add to the
counter</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>decrement</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Long value to subtract from the
counter</p></td>
</tr>
</tbody>
</table>

If neither `increment` or `decrement` is defined then the value of the
counter will be incremented by one. If `increment` and `decrement` are
both defined only increment operation is called.

    // update counter simple.counter by 7
    from("direct:in")
        .to("metrics:counter:simple.counter?increment=7")
        .to("direct:out");
    
    // increment counter simple.counter by 1
    from("direct:in")
        .to("metrics:counter:simple.counter")
        .to("direct:out");
    
    // decrement counter simple.counter by 3
    from("direct:in")
        .to("metrics:counter:simple.counter?decrement=3")
        .to("direct:out");

### Headers

Message headers can be used to override `increment` and `decrement`
values specified in Metrics component URI.

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
<td style="text-align: left;"><p>Long</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>CamelMetricsCounterDecrement</p></td>
<td style="text-align: left;"><p>Override decrement value in
URI</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
</tbody>
</table>

    // update counter simple.counter by 417
    from("direct:in")
        .setHeader(MetricsConstants.HEADER_COUNTER_INCREMENT, constant(417L))
        .to("metrics:counter:simple.counter?increment=7")
        .to("direct:out");
    
    // updates counter using simple language to evaluate body.length
    from("direct:in")
        .setHeader(MetricsConstants.HEADER_COUNTER_INCREMENT, simple("${body.length}"))
        .to("metrics:counter:body.length")
        .to("mock:out");

## Metric type histogram

    metrics:histogram:metricname[?options]

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

If `value` is not set, nothing is added to histogram and warning is
logged.

    // adds value 9923 to simple.histogram
    from("direct:in")
        .to("metrics:histogram:simple.histogram?value=9923")
        .to("direct:out");
    
    // nothing is added to simple.histogram; warning is logged
    from("direct:in")
        .to("metrics:histogram:simple.histogram")
        .to("direct:out");

### Headers

Message header can be used to override value specified in Metrics
component URI.

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

    // adds value 992 to simple.histogram
    from("direct:in")
        .setHeader(MetricsConstants.HEADER_HISTOGRAM_VALUE, constant(992L))
        .to("metrics:histogram:simple.histogram?value=700")
        .to("direct:out")

## Metric type meter

    metrics:meter:metricname[?options]

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
<td style="text-align: left;"><p>mark</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Long value to use as mark</p></td>
</tr>
</tbody>
</table>

If `mark` is not set then `meter.mark()` is called without argument.

    // marks simple.meter without value
    from("direct:in")
        .to("metrics:simple.meter")
        .to("direct:out");
    
    // marks simple.meter with value 81
    from("direct:in")
        .to("metrics:meter:simple.meter?mark=81")
        .to("direct:out");

### Headers

Message header can be used to override `mark` value specified in Metrics
component URI.

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
<td style="text-align: left;"><p>CamelMetricsMeterMark</p></td>
<td style="text-align: left;"><p>Override mark value in URI</p></td>
<td style="text-align: left;"><p>Long</p></td>
</tr>
</tbody>
</table>

    // updates meter simple.meter with value 345
    from("direct:in")
        .setHeader(MetricsConstants.HEADER_METER_MARK, constant(345L))
        .to("metrics:meter:simple.meter?mark=123")
        .to("direct:out");

## Metrics type timer

    metrics:timer:metricname[?options]

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
without any timer update. If action `start` is called on already running
timer or `stop` is called on not running timer then nothing is updated
and warning is logged.

    // measure time taken by route "calculate"
    from("direct:in")
        .to("metrics:timer:simple.timer?action=start")
        .to("direct:calculate")
        .to("metrics:timer:simple.timer?action=stop");

`TimerContext` objects are stored as Exchange properties between
different Metrics component calls.

### Headers

Message header can be used to override action value specified in Metrics
component URI.

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
style="text-align: left;"><p><code>org.apache.camel.component.metrics.MetricsTimerAction</code></p></td>
</tr>
</tbody>
</table>

    // sets timer action using header
    from("direct:in")
        .setHeader(MetricsConstants.HEADER_TIMER_ACTION, MetricsTimerAction.start)
        .to("metrics:timer:simple.timer")
        .to("direct:out");

## Metric type gauge

    metrics:gauge:metricname[?options]

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
<td style="text-align: left;"><p>subject</p></td>
<td style="text-align: left;"><p>-</p></td>
<td style="text-align: left;"><p>Any object to be observed by the
gauge</p></td>
</tr>
</tbody>
</table>

If `subject` is not defined it’s simply ignored, i.e., the gauge is not
registered.

    // update gauge "simple.gauge" by a bean "mySubjectBean"
    from("direct:in")
        .to("metrics:gauge:simple.gauge?subject=#mySubjectBean")
        .to("direct:out");

### Headers

Message headers can be used to override `subject` values specified in
Metrics component URI. Note: if `CamelMetricsName` header is specified,
then new gauge is registered in addition to default one specified in a
URI.

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
<td style="text-align: left;"><p>CamelMetricsGaugeSubject</p></td>
<td style="text-align: left;"><p>Override subject value in URI</p></td>
<td style="text-align: left;"><p>Object</p></td>
</tr>
</tbody>
</table>

    // update gauge simple.gauge by a String literal "myUpdatedSubject"
    from("direct:in")
        .setHeader(MetricsConstants.HEADER_GAUGE_SUBJECT, constant("myUpdatedSubject"))
        .to("metrics:counter:simple.gauge?subject=#mySubjectBean")
        .to("direct:out");

## MetricsRoutePolicyFactory

This factory allows adding a `RoutePolicy` for each route that exposes
route utilization statistics using Dropwizard metrics. This factory can
be used in Java and XML as the examples below demonstrates.

Instead of using the `MetricsRoutePolicyFactory` you can define a
MetricsRoutePolicy per route you want to instrument, in case you only
want to instrument a few selected routes.

From Java, you add the factory to the `CamelContext` as shown below:

    context.addRoutePolicyFactory(new MetricsRoutePolicyFactory());

And from XML DSL you define a \<bean\> as follows:

      <!-- use camel-metrics route policy to gather metrics for all routes -->
      <bean id="metricsRoutePolicyFactory" class="org.apache.camel.component.metrics.routepolicy.MetricsRoutePolicyFactory"/>

The `MetricsRoutePolicyFactory` and `MetricsRoutePolicy` supports the
following options:

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
<td style="text-align: left;"><p>useJmx</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to report fine-grained
statistics to JMX by using the
<code>com.codahale.metrics.JmxReporter</code>.<br />
Notice that if JMX is enabled on CamelContext then a
<code>MetricsRegistryService</code> mbean is enlisted under the services
type in the JMX tree. That mbean has a single operation to output the
statistics using json. Setting <code>useJmx</code> to true is only
needed if you want fine-grained mbeans per statistics type.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>jmxDomain</p></td>
<td style="text-align: left;"><p>org.apache.camel.metrics</p></td>
<td style="text-align: left;"><p>The JMX domain name</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>prettyPrint</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to use pretty print when
outputting statistics in json format</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>metricsRegistry</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Allow using a shared
<code>com.codahale.metrics.MetricRegistry</code>. If none is provided,
then Camel will create a shared instance used by the
CamelContext.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rateUnit</p></td>
<td style="text-align: left;"><p>TimeUnit.SECONDS</p></td>
<td style="text-align: left;"><p>The unit to use for rate in the metrics
reporter or when dumping the statistics as json.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>durationUnit</p></td>
<td style="text-align: left;"><p>TimeUnit.MILLISECONDS</p></td>
<td style="text-align: left;"><p>The unit to use for duration in the
metrics reporter or when dumping the statistics as json.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>namePattern</p></td>
<td
style="text-align: left;"><p><code>##name##.##routeId##.##type##</code></p></td>
<td style="text-align: left;"><p><strong>Camel 2.17:</strong> The name
pattern to use. Use dot as separators, but you can change that. The
values <code>##name##</code>, <code>##routeId##</code>, and
<code>##type##</code> will be replaced with actual value. Where
<code>###name###</code> is the name of the CamelContext.
<code>###routeId###</code> is the name of the route. And
<code>###type###</code> is the value of responses.</p></td>
</tr>
</tbody>
</table>

From Java code you can get hold of the
`com.codahale.metrics.MetricRegistry` from the
`org.apache.camel.component.metrics.routepolicy.MetricsRegistryService`
as shown below:

    MetricRegistryService registryService = context.hasService(MetricsRegistryService.class);
    if (registryService != null) {
      MetricsRegistry registry = registryService.getMetricsRegistry();
      ...
    }

## MetricsMessageHistoryFactory

This factory allows using metrics to capture Message History performance
statistics while routing messages. It works by using a metrics Timer for
each node in all the routes. This factory can be used in Java and XML as
the examples below demonstrates.

From Java, you set the factory to the `CamelContext` as shown below:

    context.setMessageHistoryFactory(new MetricsMessageHistoryFactory());

And from XML DSL you define a \<bean\> as follows:

      <!-- use camel-metrics message history to gather metrics for all messages being routed -->
      <bean id="metricsMessageHistoryFactory" class="org.apache.camel.component.metrics.messagehistory.MetricsMessageHistoryFactory"/>

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
<td style="text-align: left;"><p>useJmx</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to report fine-grained
statistics to JMX by using the
<code>com.codahale.metrics.JmxReporter</code>.<br />
Notice that if JMX is enabled on CamelContext then a
<code>MetricsRegistryService</code> mbean is enlisted under the services
type in the JMX tree. That mbean has a single operation to output the
statistics using json. Setting <code>useJmx</code> to true is only
needed if you want fine-grained mbeans per statistics type.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>jmxDomain</p></td>
<td style="text-align: left;"><p>org.apache.camel.metrics</p></td>
<td style="text-align: left;"><p>The JMX domain name</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>prettyPrint</p></td>
<td style="text-align: left;"><p>false</p></td>
<td style="text-align: left;"><p>Whether to use pretty print when
outputting statistics in json format</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>metricsRegistry</p></td>
<td style="text-align: left;"></td>
<td style="text-align: left;"><p>Allow using a shared
<code>com.codahale.metrics.MetricRegistry</code>. If none is provided,
then Camel will create a shared instance used by the
CamelContext.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>rateUnit</p></td>
<td style="text-align: left;"><p>TimeUnit.SECONDS</p></td>
<td style="text-align: left;"><p>The unit to use for rate in the metrics
reporter or when dumping the statistics as json.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p>durationUnit</p></td>
<td style="text-align: left;"><p>TimeUnit.MILLISECONDS</p></td>
<td style="text-align: left;"><p>The unit to use for duration in the
metrics reporter or when dumping the statistics as json.</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p>namePattern</p></td>
<td
style="text-align: left;"><p><code>##name##.##routeId##.###id###.##type##</code></p></td>
<td style="text-align: left;"><p>The name pattern to use. Use dot as
separators, but you can change that. The values <code>##name##</code>,
<code>##routeId##</code>, <code>##type##</code>, and
<code>###id###</code> will be replaced with actual value. Where
<code>###name###</code> is the name of the CamelContext.
<code>###routeId###</code> is the name of the route. The
<code>###id###</code> pattern represents the node id. And
<code>###type###</code> is the value of history.</p></td>
</tr>
</tbody>
</table>

At runtime the metrics can be accessed from Java API or JMX, which
allows to gather the data as json output.

From Java code, you can get the service from the CamelContext as shown:

    MetricsMessageHistoryService service = context.hasService(MetricsMessageHistoryService.class);
    String json = service.dumpStatisticsAsJson();

And the JMX API the MBean is registered in the `type=services` tree with
`name=MetricsMessageHistoryService`.

## InstrumentedThreadPoolFactory

This factory allows you to gather performance information about Camel
Thread Pools by injecting a `InstrumentedThreadPoolFactory` which
collects information from the inside of Camel. See more details at
Advanced configuration of CamelContext using Spring

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|metricRegistry|To use a custom configured MetricRegistry.||object|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|metricsType|Type of metrics||object|
|metricsName|Name of metrics||string|
|action|Action when using timer type||object|
|decrement|Decrement value when using counter type||integer|
|increment|Increment value when using counter type||integer|
|mark|Mark when using meter type||integer|
|subject|Subject value when using gauge type||object|
|value|Value value when using histogram type||integer|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
