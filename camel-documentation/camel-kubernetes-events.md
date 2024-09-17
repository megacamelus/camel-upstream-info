# Kubernetes-events

**Since Camel 3.20**

**Both producer and consumer are supported**

The Kubernetes Event component is one of [Kubernetes
Components](#kubernetes-summary.adoc) which provides a producer to
execute Kubernetes Event operations and a consumer to consume events
related to Event objects.

# Usage

## Supported producer operation

-   `listEvents`

-   `listEventsByLabels`

-   `getEvent`

-   `createEvent`

-   `updateEvent`

-   `deleteEvent`

# Examples

## Kubernetes Events Producer Examples

-   `listEvents`: this operation lists the events

<!-- -->

    from("direct:list").
        to("kubernetes-events:///?kubernetesClient=#kubernetesClient&operation=listEvents").
        to("mock:result");

This operation returns a list of events from your cluster. The type of
the events is `io.fabric8.kubernetes.api.model.events.v1.Event`.

To indicate from which namespace, the events are expected, it is
possible to set the message header `CamelKubernetesNamespaceName`. By
default, the events of all namespaces are returned.

-   `listEventsByLabels`: this operation lists the events selected by
    labels

<!-- -->

    from("direct:listByLabels").process(new Processor() {
    
                @Override
                public void process(Exchange exchange) throws Exception {
                    Map<String, String> labels = new HashMap<>();
                    labels.put("key1", "value1");
                    labels.put("key2", "value2");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENTS_LABELS, labels);
                }
            });
        to("kubernetes-events:///?kubernetesClient=#kubernetesClient&operation=listEventsByLabels").
        to("mock:result");

This operation returns a list of events from your cluster that occurred
in any namespaces, using a label selector (in the example above only
expect events which have the label "key1" set to "value1" and the label
"key2" set to "value2"). The type of the events is
`io.fabric8.kubernetes.api.model.events.v1.Event`.

This operation expects the message header `CamelKubernetesEventsLabels`
to be set to a `Map<String, String>` where the key-value pairs represent
the expected label names and values.

-   `getEvent`: this operation gives a specific event

<!-- -->

    from("direct:get").process(new Processor() {
    
                @Override
                public void process(Exchange exchange) throws Exception {
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_NAMESPACE_NAME, "test");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_NAME, "event1");
                }
            });
        to("kubernetes-events:///?kubernetesClient=#kubernetesClient&operation=getEvent").
        to("mock:result");

This operation returns the event matching the criteria from your
cluster. The type of the event is
`io.fabric8.kubernetes.api.model.events.v1.Event`.

This operation expects two message headers which are
`CamelKubernetesNamespaceName` and `CamelKubernetesEventName`, the first
one needs to be set to the name of the target namespace and second one
needs to be set to the target name of event.

If no matching event could be found, `null` is returned.

-   `createEvent`: this operation creates a new event

<!-- -->

    from("direct:get").process(new Processor() {
    
                @Override
                public void process(Exchange exchange) throws Exception {
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_NAMESPACE_NAME, "default");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_NAME, "test1");
                    Map<String, String> labels = new HashMap<>();
                    labels.put("this", "rocks");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENTS_LABELS, labels);
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_ACTION_PRODUCER, "Some Action");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_TYPE, "Normal");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_REASON, "Some Reason");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_REPORTING_CONTROLLER, "Some-Reporting-Controller");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_REPORTING_INSTANCE, "Some-Reporting-Instance");
                }
            });
        to("kubernetes-events:///?kubernetesClient=#kubernetesClient&operation=createEvent").
        to("mock:result");

This operation publishes a new event in your cluster. An event can be
created in two ways either from message headers or directly from an
`io.fabric8.kubernetes.api.model.events.v1.EventBuilder`.

Whatever the way used to create the event:

-   The operation expects two message headers which are
    `CamelKubernetesNamespaceName` and `CamelKubernetesEventName`, to
    set respectively the name of namespace and the name of the produced
    event.

-   The operation supports the message header
    `CamelKubernetesEventsLabels` to set the labels to the produced
    event.

The message headers that can be used to create an event are
`CamelKubernetesEventTime`, `CamelKubernetesEventAction`,
`CamelKubernetesEventType`, `CamelKubernetesEventReason`,
`CamelKubernetesEventNote`,`CamelKubernetesEventRegarding`,
`CamelKubernetesEventRelated`, `CamelKubernetesEventReportingController`
and `CamelKubernetesEventReportingInstance`.

In case the supported message headers are not enough for a specific use
case, it is still possible to set the message body with an object of
type `io.fabric8.kubernetes.api.model.events.v1.EventBuilder`
representing a prefilled builder to use when creating the event. Please
note that the labels, name of event and name of namespace are always set
from the message headers, even when the builder is provided.

-   `updateEvent`: this operation updates an existing event

The behavior is exactly the same as `createEvent`, only the name of the
operation is different.

-   `deleteEvent`: this operation deletes an existing event.

<!-- -->

    from("direct:get").process(new Processor() {
    
                @Override
                public void process(Exchange exchange) throws Exception {
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_NAMESPACE_NAME, "default");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_EVENT_NAME, "test1");
                }
            });
        to("kubernetes-events:///?kubernetesClient=#kubernetesClient&operation=deleteEvent").
        to("mock:result");

This operation removes an existing event from your cluster. It returns a
`boolean` to indicate whether the operation was successful or not.

This operation expects two message headers which are
`CamelKubernetesNamespaceName` and `CamelKubernetesEventName`, the first
one needs to be set to the name of the target namespace and second one
needs to be set to the target name of event.

## Kubernetes Events Consumer Example

    fromF("kubernetes-events://%s?oauthToken=%s", host, authToken)
        .setHeader(KubernetesConstants.KUBERNETES_NAMESPACE_NAME, constant("default"))
        .setHeader(KubernetesConstants.KUBERNETES_EVENT_NAME, constant("test"))
        .process(new KubernertesProcessor()).to("mock:result");
    
        public class KubernertesProcessor implements Processor {
            @Override
            public void process(Exchange exchange) throws Exception {
                Message in = exchange.getIn();
                Event cm = exchange.getIn().getBody(Event.class);
                log.info("Got event with event name: " + cm.getMetadata().getName() + " and action " + in.getHeader(KubernetesConstants.KUBERNETES_EVENT_ACTION));
            }
        }

This consumer returns a message per event received on the namespace
"default" for the event "test". It also set the action
(`io.fabric8.kubernetes.client.Watcher.Action`) in the message header
`CamelKubernetesEventAction` and the timestamp (`long`) in the message
header `CamelKubernetesEventTimestamp`.

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|kubernetesClient|To use an existing kubernetes client.||object|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|autowiredEnabled|Whether autowiring is enabled. This is used for automatic autowiring options (the option must be marked as autowired) by looking up in the registry to find if there is a single instance of matching type, which then gets configured on the component. This can be used for automatic configuring JDBC data sources, JMS connection factories, AWS Clients, etc.|true|boolean|

## Endpoint Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|masterUrl|URL to a remote Kubernetes API server. This should only be used when your Camel application is connecting from outside Kubernetes. If you run your Camel application inside Kubernetes, then you can use local or client as the URL to tell Camel to run in local mode. If you connect remotely to Kubernetes, then you may also need some of the many other configuration options for secured connection with certificates, etc.||string|
|apiVersion|The Kubernetes API Version to use||string|
|dnsDomain|The dns domain, used for ServiceCall EIP||string|
|kubernetesClient|Default KubernetesClient to use if provided||object|
|namespace|The namespace||string|
|portName|The port name, used for ServiceCall EIP||string|
|portProtocol|The port protocol, used for ServiceCall EIP|tcp|string|
|crdGroup|The Consumer CRD Resource Group we would like to watch||string|
|crdName|The Consumer CRD Resource name we would like to watch||string|
|crdPlural|The Consumer CRD Resource Plural we would like to watch||string|
|crdScope|The Consumer CRD Resource Scope we would like to watch||string|
|crdVersion|The Consumer CRD Resource Version we would like to watch||string|
|labelKey|The Consumer Label key when watching at some resources||string|
|labelValue|The Consumer Label value when watching at some resources||string|
|poolSize|The Consumer pool size|1|integer|
|resourceName|The Consumer Resource Name we would like to watch||string|
|bridgeErrorHandler|Allows for bridging the consumer to the Camel routing Error Handler, which mean any exceptions (if possible) occurred while the Camel consumer is trying to pickup incoming messages, or the likes, will now be processed as a message and handled by the routing Error Handler. Important: This is only possible if the 3rd party component allows Camel to be alerted if an exception was thrown. Some components handle this internally only, and therefore bridgeErrorHandler is not possible. In other situations we may improve the Camel component to hook into the 3rd party component and make this possible for future releases. By default the consumer will use the org.apache.camel.spi.ExceptionHandler to deal with exceptions, that will be logged at WARN or ERROR level and ignored.|false|boolean|
|exceptionHandler|To let the consumer use a custom ExceptionHandler. Notice if the option bridgeErrorHandler is enabled then this option is not in use. By default the consumer will deal with exceptions, that will be logged at WARN or ERROR level and ignored.||object|
|exchangePattern|Sets the exchange pattern when the consumer creates an exchange.||object|
|operation|Producer operation to do on Kubernetes||string|
|lazyStartProducer|Whether the producer should be started lazy (on the first message). By starting lazy you can use this to allow CamelContext and routes to startup in situations where a producer may otherwise fail during starting and cause the route to fail being started. By deferring this startup to be lazy then the startup failure can be handled during routing messages via Camel's routing error handlers. Beware that when the first message is processed then creating and starting the producer may take a little time and prolong the total processing time of the processing.|false|boolean|
|connectionTimeout|Connection timeout in milliseconds to use when making requests to the Kubernetes API server.||integer|
|caCertData|The CA Cert Data||string|
|caCertFile|The CA Cert File||string|
|clientCertData|The Client Cert Data||string|
|clientCertFile|The Client Cert File||string|
|clientKeyAlgo|The Key Algorithm used by the client||string|
|clientKeyData|The Client Key data||string|
|clientKeyFile|The Client Key file||string|
|clientKeyPassphrase|The Client Key Passphrase||string|
|oauthToken|The Auth Token||string|
|password|Password to connect to Kubernetes||string|
|trustCerts|Define if the certs we used are trusted anyway or not||boolean|
|username|Username to connect to Kubernetes||string|
