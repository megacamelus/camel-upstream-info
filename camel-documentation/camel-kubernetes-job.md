# Kubernetes-job

**Since Camel 2.23**

**Only producer is supported**

The Kubernetes Job component is one of [Kubernetes
Components](#kubernetes-summary.adoc) which provides a producer to
execute kubernetes Job operations.

# Usage

## Supported producer operation

-   `listJob`

-   `listJobByLabels`

-   `getJob`

-   `createJob`

-   `updateJob`

-   `deleteJob`

# Examples

## Kubernetes Job Producer Examples

-   `listJob`: this operation lists the jobs on a kubernetes cluster

<!-- -->

    from("direct:list").
        toF("kubernetes-job:///?kubernetesClient=#kubernetesClient&operation=listJob").
        to("mock:result");

This operation returns a list of jobs from your cluster

-   `listJobByLabels`: this operation lists the jobs by labels on a
    kubernetes cluster

<!-- -->

    from("direct:listByLabels").process(new Processor() {
                @Override
                public void process(Exchange exchange) throws Exception {
                    Map<String, String> labels = new HashMap<>();
                    labels.put("key1", "value1");
                    labels.put("key2", "value2");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_JOB_LABELS, labels);
                }
            });
        toF("kubernetes-job:///?kubernetesClient=#kubernetesClient&operation=listJobByLabels").
        to("mock:result");

This operation returns a list of jobs from your cluster, using a label
selector (with key1 and key2, with value value1 and value2)

-   `createJob`: This operation creates a job on a Kubernetes Cluster

We have a wonderful example of this operation thanks to [Emmerson
Miranda](https://github.com/Emmerson-Miranda) from this [Java
test](https://github.com/Emmerson-Miranda/camel/blob/master/camel3-cdi/cdi-k8s-pocs/src/main/java/edu/emmerson/camel/k8s/jobs/camel_k8s_jobs/KubernetesCreateJob.java)

    import java.util.ArrayList;
    import java.util.Date;
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;
    
    import javax.inject.Inject;
    
    import org.apache.camel.Endpoint;
    import org.apache.camel.builder.RouteBuilder;
    import org.apache.camel.cdi.Uri;
    import org.apache.camel.component.kubernetes.KubernetesConstants;
    import org.apache.camel.component.kubernetes.KubernetesOperations;
    
    import io.fabric8.kubernetes.api.model.Container;
    import io.fabric8.kubernetes.api.model.ObjectMeta;
    import io.fabric8.kubernetes.api.model.PodSpec;
    import io.fabric8.kubernetes.api.model.PodTemplateSpec;
    import io.fabric8.kubernetes.api.model.batch.JobSpec;
    
    public class KubernetesCreateJob extends RouteBuilder {
    
        @Inject
        @Uri("timer:foo?delay=1000&repeatCount=1")
        private Endpoint inputEndpoint;
    
        @Inject
        @Uri("log:output")
        private Endpoint resultEndpoint;
    
        @Override
        public void configure() {
            // you can configure the route rule with Java DSL here
    
            from(inputEndpoint)
                    .routeId("kubernetes-jobcreate-client")
                    .process(exchange -> {
                            exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_JOB_NAME, "camel-job"); //DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_NAMESPACE_NAME, "default");
    
                    Map<String, String> joblabels = new HashMap<String, String>();
                    joblabels.put("jobLabelKey1", "value1");
                    joblabels.put("jobLabelKey2", "value2");
                    joblabels.put("app", "jobFromCamelApp");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_JOB_LABELS, joblabels);
    
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_JOB_SPEC, generateJobSpec());
                    })
                    .toF("kubernetes-job:///{{kubernetes-master-url}}?oauthToken={{kubernetes-oauth-token:}}&operation=" + KubernetesOperations.CREATE_JOB_OPERATION)
                    .log("Job created:")
                    .process(exchange -> {
                            System.out.println(exchange.getIn().getBody());
                    })
                .to(resultEndpoint);
        }
    
            private JobSpec generateJobSpec() {
                    JobSpec js = new JobSpec();
    
                    PodTemplateSpec pts = new PodTemplateSpec();
    
                    PodSpec ps = new PodSpec();
                    ps.setRestartPolicy("Never");
                    ps.setContainers(generateContainers());
                    pts.setSpec(ps);
    
                    ObjectMeta metadata = new ObjectMeta();
                    Map<String, String> annotations = new HashMap<String, String>();
                    annotations.put("jobMetadataAnnotation1", "random value");
                    metadata.setAnnotations(annotations);
    
                    Map<String, String> podlabels = new HashMap<String, String>();
                    podlabels.put("podLabelKey1", "value1");
                    podlabels.put("podLabelKey2", "value2");
                    podlabels.put("app", "podFromCamelApp");
                    metadata.setLabels(podlabels);
    
                    pts.setMetadata(metadata);
                    js.setTemplate(pts);
                    return js;
            }
    
            private List<Container> generateContainers() {
                    Container container = new Container();
                    container.setName("pi");
                    container.setImage("perl");
                    List<String> command = new ArrayList<String>();
                    command.add("echo");
                    command.add("Job created from Apache Camel code at " + (new Date()));
                    container.setCommand(command);
                    List<Container> containers = new ArrayList<Container>();
                    containers.add(container);
                    return containers;
            }
    }

## Component Configurations

  
|Name|Description|Default|Type|
|---|---|---|---|
|kubernetesClient|To use an existing kubernetes client.||object|
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
|operation|Producer operation to do on Kubernetes||string|
|portName|The port name, used for ServiceCall EIP||string|
|portProtocol|The port protocol, used for ServiceCall EIP|tcp|string|
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
