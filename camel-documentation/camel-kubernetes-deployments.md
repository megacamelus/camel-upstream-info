# Kubernetes-deployments

**Since Camel 2.20**

**Both producer and consumer are supported**

The Kubernetes Deployments component is one of [Kubernetes
Components](#kubernetes-summary.adoc) which provides a producer to
execute Kubernetes Deployments operations and a consumer to consume
events related to Deployments objects.

# Usage

## Supported producer operation

-   `listDeployments`

-   `listDeploymentsByLabels`

-   `getDeployment`

-   `createDeployment`

-   `updateDeployment`

-   `deleteDeployment`

-   `scaleDeployment`

# Examples

## Kubernetes Deployments Producer Examples

-   `listDeployments`: this operation lists the deployments on a
    kubernetes cluster

<!-- -->

    from("direct:list").
        toF("kubernetes-deployments:///?kubernetesClient=#kubernetesClient&operation=listDeployments").
        to("mock:result");

This operation returns a List of Deployment from your cluster

-   `listDeploymentsByLabels`: this operation lists the deployments by
    labels on a kubernetes cluster

<!-- -->

    from("direct:listByLabels").process(new Processor() {
                @Override
                public void process(Exchange exchange) throws Exception {
                    Map<String, String> labels = new HashMap<>();
                    labels.put("key1", "value1");
                    labels.put("key2", "value2");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_DEPLOYMENTS_LABELS, labels);
                }
            });
        toF("kubernetes-deployments:///?kubernetesClient=#kubernetesClient&operation=listDeploymentsByLabels").
        to("mock:result");

This operation returns a List of Deployments from your cluster, using a
label selector (with key1 and key2, with value value1 and value2)

## Kubernetes Deployments Consumer Example

    fromF("kubernetes-deployments://%s?oauthToken=%s&namespace=default&resourceName=test", host, authToken).process(new KubernertesProcessor()).to("mock:result");
        public class KubernertesProcessor implements Processor {
            @Override
            public void process(Exchange exchange) throws Exception {
                Message in = exchange.getIn();
                Deployment dp = exchange.getIn().getBody(Deployment.class);
                log.info("Got event with configmap name: " + dp.getMetadata().getName() + " and action " + in.getHeader(KubernetesConstants.KUBERNETES_EVENT_ACTION));
            }
        }

This consumer will return a list of events on the namespace default for
the deployment test.

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
