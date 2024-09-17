# Knative

**Since Camel 3.15**

**Both producer and consumer are supported**

The Knative component provides support for interacting with
[Knative](https://knative.dev/).

Maven users will need to add the following dependency to their `pom.xml`
for this component.

    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-knative</artifactId>
        <version>x.x.x</version>
        <!-- use the same version as your Camel K version -->
    </dependency>

# URI format

    knative:type/name[?options]

You can append query options to the URI in the following format:

    ?option=value&option=value&...

# Options

# Usage

## Supported Knative resources

The component support the following Knative resources you can target or
exposes using the `type` path parameter:

-   `channel`: allow producing or consuming events to or from a
    [**Knative Channel**](https://knative.dev/docs/eventing/channels/)

-   `endpoint`: allow exposing or targeting serverless workloads using
    [**Knative
    Services**](https://knative.dev/docs/serving/spec/knative-api-specification-1.0/#service)

-   `event`: allow producing or consuming events to or from a [**Knative
    Broker**](https://knative.dev/docs/eventing/broker)

## Knative Environment

As the Knative component hides the technical details of how to
communicate with Knative services to the user (protocols, addresses,
etc.), it needs some metadata that describes the Knative environment to
set up the low-level transport details. To do so, the component needs a
so called `Knative Environment`, which is essence is a Json document
made by a number of `service` elements which looks like the below
example:

**Example**

    {
        "services": [
            {
                 "type": "channel|endpoint|event", 
                 "name": "", 
                 "metadata": {
                     "service.url": "http://my-service.svc.cluster.local" 
                     "knative.event.type": "", 
                     "camel.endpoint.kind": "source|sink", 
                 }
            }, {
                ...
            }
        ]
    }

-   the type of the Knative resource

-   the name of the resource

-   the url of the service to invoke (for producer only)

-   the Knative event type received or produced by the component

-   the type of the Camel Endpoint associated with this Knative resource
    (source=consumer, sink=producer)

The `metadata` fields has some additional advanced fields:

<table>
<colgroup>
<col style="width: 11%" />
<col style="width: 55%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Name</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Example</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><p><strong>filter.</strong></p></td>
<td style="text-align: left;"><p>The prefix to define filters to be
applied to the incoming message headers.</p></td>
<td
style="text-align: left;"><p>```filter.ce.source=my-source```</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>knative.kind</strong></p></td>
<td style="text-align: left;"><p>The type of the k8s resource referenced
by the endpoint.</p></td>
<td
style="text-align: left;"><p>```knative.kind=InMemoryChannel```</p></td>
</tr>
<tr class="odd">
<td
style="text-align: left;"><p><strong>knative.apiVersion</strong></p></td>
<td style="text-align: left;"><p>The version of the k8s resource
referenced by the endpoint</p></td>
<td
style="text-align: left;"><p>```knative.apiVersion=messaging.knative.dev/v1beta1```</p></td>
</tr>
<tr class="even">
<td style="text-align: left;"><p><strong>knative.reply</strong></p></td>
<td style="text-align: left;"><p>If the consumer should construct a full
reply to knative request.</p></td>
<td style="text-align: left;"><p>```knative.reply=false```</p></td>
</tr>
<tr class="odd">
<td style="text-align: left;"><p><strong>ce.override.</strong></p></td>
<td style="text-align: left;"><p>The prefix to define CloudEvents values
that have to be overridden.</p></td>
<td
style="text-align: left;"><p>```ce.override.ce-type=MyType```</p></td>
</tr>
</tbody>
</table>

**Example**

    CamelContext context = new DefaultCamelContext();
    
    KnativeComponent component = context.getComponent("knative", KnativeComponent.class);
    component.getConfiguration().setEnvironmentPath("classpath:knative.json"); // 
    
    RouteBuilder.addRoutes(context, b -> {
        b.from("knative:endpoint/myEndpoint") // 
            .to("log:info");
    });

-   set the location of the `Knative Environment` file

-   expose knative service

## Using custom Knative Transport

As today the component only support `http` as transport as it is the
only supported protocol on Knative side but the transport is pluggable
by implementing the following interface:

    public interface KnativeTransport extends Service {
        /**
         * Create a camel {@link org.apache.camel.Producer} in place of the original endpoint for a specific protocol.
         *
         * @param endpoint the endpoint for which the producer should be created
         * @param configuration the general transport configuration
         * @param service the service definition containing information about how make reach the target service.
         */
        Producer createProducer(
            Endpoint endpoint,
            KnativeTransportConfiguration configuration,
            KnativeEnvironment.KnativeServiceDefinition service);
    
        /**
         * Create a camel {@link org.apache.camel.Producer} in place of the original endpoint for a specific protocol.
         *
         * @param endpoint the endpoint for which the consumer should be created.
         * @param configuration the general transport configuration
         * @param service the service definition containing information about how make the route reachable from knative.
         */
        Consumer createConsumer(
            Endpoint endpoint,
            KnativeTransportConfiguration configuration,
            KnativeEnvironment.KnativeServiceDefinition service, Processor processor);
    }

## Using ProducerTemplate

When using Knative producer with a ProducerTemplate, it is necessary to
specify a value for the CloudEvent source, simply by setting a value for
the header *CamelCloudEventSource*.

**Example**

    producerTemplate.sendBodyAndHeader("knative:event/broker-test", body, CloudEvent.CAMEL_CLOUD_EVENT_SOURCE, "my-source-name");

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|ceOverride|CloudEvent headers to override||object|
|cloudEventsSpecVersion|Set the version of the cloudevents spec.|1.0|string|
|cloudEventsType|Set the event-type information of the produced events.|org.apache.camel.event|string|
|configuration|Set the configuration.||object|
|consumerFactory|The protocol consumer factory.||object|
|environment|The environment||object|
|environmentPath|The path ot the environment definition||string|
|filters|Set the filters.||object|
|producerFactory|The protocol producer factory.||object|
|sinkBinding|The SinkBinding configuration.||object|
|transportOptions|Set the transport options.||object|
|typeId|The name of the service to lookup from the KnativeEnvironment.||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|replyWithCloudEvent|Transforms the reply into a cloud event that will be processed by the caller. When listening to events from a Knative Broker, if this flag is enabled, replies will be published to the same Broker where the request comes from (beware that if you don't change the type of the received message, you may create a loop and receive your same reply). When this flag is disabled, CloudEvent headers are removed from the reply.|false|boolean|
|reply|If the consumer should construct a full reply to knative request.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|apiVersion|The version of the k8s resource referenced by the endpoint.||string|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|
|kind|The type of the k8s resource referenced by the endpoint.||string|
|name|The name of the k8s resource referenced by the endpoint.||string|
|healthCheckConsumerEnabled|Used for enabling or disabling all consumer based health checks from this component|true|boolean|
|healthCheckProducerEnabled|Used for enabling or disabling all producer based health checks from this component. Notice: Camel has by default disabled all producer based health-checks. You can turn on producer checks globally by setting camel.health.producersEnabled=true.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|type|The Knative resource type||object|
|typeId|The identifier of the Knative resource||string|
|ceOverride|CloudEvent headers to override||object|
|cloudEventsSpecVersion|Set the version of the cloudevents spec.|1.0|string|
|cloudEventsType|Set the event-type information of the produced events.|org.apache.camel.event|string|
|environment|The environment||object|
|filters|Set the filters.||object|
|sinkBinding|The SinkBinding configuration.||object|
|transportOptions|Set the transport options.||object|
|replyWithCloudEvent|Transforms the reply into a cloud event that will be processed by the caller. When listening to events from a Knative Broker, if this flag is enabled, replies will be published to the same Broker where the request comes from (beware that if you don't change the type of the received message, you may create a loop and receive your same reply). When this flag is disabled, CloudEvent headers are removed from the reply.|false|boolean|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|reply|If the consumer should construct a full reply to knative request.|true|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|apiVersion|The version of the k8s resource referenced by the endpoint.||string|
|kind|The type of the k8s resource referenced by the endpoint.||string|
|name|The name of the k8s resource referenced by the endpoint.||string|
