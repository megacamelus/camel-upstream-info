# Controlbus

**Since Camel 2.11**

**Only producer is supported**

The [Control Bus](http://www.eaipatterns.com/ControlBus.html) from the
EIP patterns allows for the integration system to be monitored and
managed from within the framework.

<figure>
<img src="control_bus.png" alt="image" />
</figure>

Use a Control Bus to manage an enterprise integration system. The
Control Bus uses the same messaging mechanism used by the application
data, but uses separate channels to transmit data that is relevant to
the management of components involved in the message flow.

In Camel, you can manage and monitor the application:

-   using JMX.

-   by using a Java API from the `CamelContext`.

-   from the `org.apache.camel.api.management` package.

-   using the event notifier.

-   using the ControlBus component.

The ControlBus component provides easy management of Camel applications
based on the [Control Bus](#controlbus-component.adoc) EIP pattern. For
example, by sending a message to an endpoint, you can control the
lifecycle of routes, or gather performance statistics.

    controlbus:command[?options]

Where `command` can be any string to identify which type of command to
use.

# Commands

<table>
<colgroup>
<col style="width: 10%" />
<col style="width: 89%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Command</th>
<th style="text-align: left;">Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><code>route</code></p></td>
<td style="text-align: left;"><p>To control routes using the
<code>routeId</code> and <code>action</code> parameter.</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><code>language</code></p></td>
<td style="text-align: left;"><p>Allows you to specify a <a
href="#language-component.adoc">Language</a> to use for evaluating the
message body. If there is any result from the evaluation, then the
result is put in the message body.</p></td>
</tr>
</tbody>
</table>

# Examples

## Using route command

The route command allows you to do common tasks on a given route very
easily. For example, to start a route, you can send an empty message to
this endpoint:

    template.sendBody("controlbus:route?routeId=foo&action=start", null);

To get the status of the route, you can do:

    String status = template.requestBody("controlbus:route?routeId=foo&action=status", null, String.class);

## Getting performance statistics

This requires JMX to be enabled (it is enabled by default) then you can
get the performance statics per route, or for the CamelContext. For
example, to get the statics for a route named foo, we can use:

    String xml = template.requestBody("controlbus:route?routeId=foo&action=stats", null, String.class);

The returned statics is in XML format. It is the same data you can get
from JMX with the `dumpRouteStatsAsXml` operation on the
`ManagedRouteMBean`.

To get statics for the entire `CamelContext` you just omit the routeId
parameter as shown below:

    String xml = template.requestBody("controlbus:route?action=stats", null, String.class);

## Using Simple language

You can use the [Simple](#languages:simple-language.adoc) language with
the control bus. For example, to stop a specific route, you can send a
message to the `"controlbus:language:simple"` endpoint containing the
following message:

    template.sendBody("controlbus:language:simple", "${camelContext.getRouteController().stopRoute('myRoute')}");

As this is a void operation, no result is returned. However, if you want
the route status, you can use:

    String status = template.requestBody("controlbus:language:simple", "${camelContext.getRouteController().getRouteStatus('myRoute')}", String.class);

It’s easier to use the `route` command to control lifecycle of routes.
The `language` command allows you to execute a language script that has
stronger powers such as [Groovy](#languages:groovy-language.adoc) or to
some extend the [Simple](#languages:simple-language.adoc) language.

For example, to shut down Apache Camel itself, you can do:

    template.sendBody("controlbus:language:simple?async=true", "${camelContext.stop()}");

We use `async=true` to stop Camel asynchronously as otherwise we would
be trying to stop Camel while it was in-flight processing the message we
sent to the control bus component.

You can also use other languages such as
[Groovy](#languages:groovy-language.adoc), etc.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|command|Command can be either route or language||string|
|language|Allows you to specify the name of a Language to use for evaluating the message body. If there is any result from the evaluation, then the result is put in the message body.||object|
|action|To denote an action that can be either: start, stop, or status. To either start or stop a route, or to get the status of the route as output in the message body. You can use suspend and resume to either suspend or resume a route. You can use stats to get performance statics returned in XML format; the routeId option can be used to define which route to get the performance stats for, if routeId is not defined, then you get statistics for the entire CamelContext. The restart action will restart the route. And the fail action will stop and mark the route as failed (stopped due to an exception)||string|
|async|Whether to execute the control bus task asynchronously. Important: If this option is enabled, then any result from the task is not set on the Exchange. This is only possible if executing tasks synchronously.|false|boolean|
|loggingLevel|Logging level used for logging when task is done, or if any exceptions occurred during processing the task.|INFO|object|
|restartDelay|The delay in millis to use when restarting a route.|1000|integer|
|routeId|To specify a route by its id. The special keyword current indicates the current route.||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
