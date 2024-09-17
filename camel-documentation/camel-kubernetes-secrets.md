# Kubernetes-secrets

**Since Camel 2.17**

**Only producer is supported**

The Kubernetes Secrets component is one of [Kubernetes
Components](#kubernetes-summary.adoc) which provides a producer to
execute Kubernetes Secrets operations.

# Usage

## Supported producer operation

-   `listSecrets`

-   `listSecretsByLabels`

-   `getSecret`

-   `createSecret`

-   `updateSecret`

-   `deleteSecret`

# Example

## Kubernetes Secrets Producer Examples

-   `listSecrets`: this operation lists the secrets on a kubernetes
    cluster

<!-- -->

    from("direct:list").
        toF("kubernetes-secrets:///?kubernetesClient=#kubernetesClient&operation=listSecrets").
        to("mock:result");

This operation returns a list of secrets from your cluster

-   `listSecretsByLabels`: this operation lists the Secrets by labels on
    a kubernetes cluster

<!-- -->

    from("direct:listByLabels").process(new Processor() {
                @Override
                public void process(Exchange exchange) throws Exception {
                    Map<String, String> labels = new HashMap<>();
                    labels.put("key1", "value1");
                    labels.put("key2", "value2");
                    exchange.getIn().setHeader(KubernetesConstants.KUBERNETES_SECRETS_LABELS, labels);
                }
            });
        toF("kubernetes-secrets:///?kubernetesClient=#kubernetesClient&operation=listSecretsByLabels").
        to("mock:result");

This operation returns a list of Secrets from your cluster using a label
selector (with key1 and key2, with value value1 and value2)

# Using secrets properties function with Kubernetes

The `camel-kubernetes` component include the following secrets related
functions:

-   `secret` - A function to lookup the string property from Kubernetes
    Secrets.

-   `secret-binary` - A function to lookup the binary property from
    Kubernetes Secrets.

Camel reads Secrets from the Kubernetes API Server. And when RBAC is
enabled on the cluster, the ServiceAccount that is used to run the
application needs to have the proper permissions for such access.

Before the Kubernetes property placeholder functions can be used they
need to be configured with either (or both)

-   path - A *mount path* that must be mounted to the running pod, to
    load the configmaps or secrets from local disk.

-   kubernetes client - **Autowired** An
    `io.fabric8.kubernetes.client.KubernetesClient` instance to use for
    connecting to the Kubernetes API server.

Camel will first use *mount paths* (if configured) to lookup, and then
fallback to use the `KubernetesClient`.

A secret named `mydb` could contain username and passwords to connect to
a database such as:

    myhost = killroy
    myport = 5555
    myuser = scott
    mypass = tiger

This can be used in Camel with for example the Postrgres Sink Kamelet:

    <camelContext>
      <route>
        <from uri="direct:rome"/>
        <setBody>
          <constant>{ "username":"oscerd", "city":"Rome"}</constant>
        </setBody>
        <to uri="kamelet:postgresql-sink?serverName={{secret:mydb/myhost}}
                 &amp;serverPort={{secret:mydb/myport}}
                 &amp;username={{secret:mydb/myuser}}
                 &amp;password={{secret:mydb/mypass}}
                 &amp;databaseName=cities
                 &amp;query=INSERT INTO accounts (username,city) VALUES (:#username,:#city)"/>
      </route>
    </camelContext>

The postgres-sink Kamelet can also be configured in
`application.properties` which reduces the configuration in the route
above:

    camel.component.kamelet.postgresql-sink.databaseName={{secret:mydb/myhost}}
    camel.component.kamelet.postgresql-sink.serverPort={{secret:mydb/myport}}
    camel.component.kamelet.postgresql-sink.username={{secret:mydb/myuser}}
    camel.component.kamelet.postgresql-sink.password={{secret:mydb/mypass}}

Which reduces the route to:

    <camelContext>
      <route>
        <from uri="direct:rome"/>
        <setBody>
          <constant>{ "username":"oscerd", "city":"Rome"}</constant>
        </setBody>
        <to uri="kamelet:postgresql-sink?databaseName=cities
                 &amp;query=INSERT INTO accounts (username,city) VALUES (:#username,:#city)"/>
      </route>
    </camelContext>

# Automatic Camel context reloading on Secret Refresh

Being able to reload Camel context on a Secret Refresh could be done by
specifying the following properties:

    camel.vault.kubernetes.refreshEnabled=true
    camel.vault.kubernetes.secrets=Secret
    camel.main.context-reload-enabled = true

where `camel.vault.kubernetes.refreshEnabled` will enable the automatic
context reload and `camel.vault.kubernetes.secrets` is a regex
representing or a comma separated lists of the secrets we want to track
for updates.

Whenever a secrets listed in the property, will be updated in the same
namespace of the running application, the Camel context will be
reloaded, refreshing the secret value.

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
